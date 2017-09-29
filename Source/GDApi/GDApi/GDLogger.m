//  GDLogger.m
//  gdapi
//
//  Created by Emre Demir on 19/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDLogger.h"
#import "GDstatic.h"
#import "GDlogchannel.h"
#import "GDUtils.h"
#import "GDLogRequest.h"
#import "GDcustomLog.h"
#import "GDbannerData.h"
#import "GDAd.h"
#import "GDAdPosition.h"
#import "GDAlignment.h"
#import "GDAdSize.h"
#import "GDAdDelegate.h"

@implementation GDLogger

static GDAd* gdAPI;
static NSUserDefaults* cookie;
static Boolean isCordovaPlugin = false;
NSMutableArray* elementsArray;
NSString* currentString;
GDbannerData* bannerData;
Boolean preShowed = false;
GDAdDelegate* delegate;

+(void) init:(NSString *)gameId andWithRegId:(NSString *)regId
{
    if(gdAPI == nil){
        NSString* lowercaseRegId = [regId lowercaseString];
        NSArray* gameserver = [lowercaseRegId componentsSeparatedByString:@"-"];
        
        if([gameserver count] == 6){
            [GDstatic setRegId:[NSString stringWithFormat:@"%@-%@-%@-%@-%@",[gameserver objectAtIndex:0],[gameserver objectAtIndex:1],
                                [gameserver objectAtIndex:2],[gameserver objectAtIndex:3],[gameserver objectAtIndex:4]]];
            [GDstatic setServerId:[gameserver objectAtIndex:5]];
            [GDstatic setGameId:gameId];
            [GDstatic setEnable:true];
            
            [self visit];
            
            [GDlogchannel init];
            [GDUtils log:@"Game Distribution iOS API Init"];
            [self getXMLData:[GDUtils getBannerServerURL]];
            
            
            cookie = [[NSUserDefaults alloc] init];
        }
        else{
            NSLog(@"RegID is not valid.");
        }
    }
    else{
        [GDUtils log:@"Api is already initialized!"];
    }
    
}

+(void) init:(NSString *)gameId andWithRegId:(NSString *)regId andWithIsPlugin:(Boolean)isPlugin{
    
    if(gdAPI == nil){
        
        if(isPlugin){
            isCordovaPlugin = true;
        }
        [self init:gameId andWithRegId:regId];
        
    }
    else{
        [GDUtils log:@"Api is already initialized!"];
    }

}


+(void) initGDApi{
    if(gdAPI == nil){
        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        gdAPI = [[GDAd alloc] init:[[GDstatic adUnit] stringByAppendingString:[GDstatic affiliateId]]   andContext:rootViewController];
    
        [gdAPI addCustomTargeting:@"apptype" andValue:@"ios"];
        [gdAPI addCustomTargeting:@"gdp" andValue:@"1"];
        
        if(delegate != nil){
            [gdAPI setDelegate:delegate];
        }
    }

}

+(GDAd*) gdAPI{
    return gdAPI;
}

+(NSUserDefaults*) cookie{
    return cookie;
}

+(NSNumber*) incVisit{
    NSNumber* visit = (NSNumber*)[GDUtils getCookie:@"visit"];
    visit =@([visit intValue]+1);
    [GDUtils setCookie:@"visit" andValue:visit];
    return visit;
    
}

+(void) visit{
    if([GDstatic enable]){
        GDSendObject* sendObj = [[GDSendObject alloc] init];
        sendObj.action =@"visit";
        sendObj.value = [self incVisit];
        NSNumber* tmp = (NSNumber*)[GDUtils getCookie:@"state"];
        if(tmp == nil){
            sendObj.state = [NSNumber numberWithInt:0];
        }
        else{
            sendObj.state = tmp;
        }
        [GDLogRequest pushLog:sendObj];
    }
}

+(void) play{
    if([GDstatic enable]){
        GDSendObject* sendObj = [[GDSendObject alloc] init];
        sendObj.action =@"play";
        sendObj.value = [self incPlay];
        [GDLogRequest pushLog:sendObj];
    }
}

+(NSNumber*) incPlay{
    NSNumber* play = (NSNumber*)[GDUtils getCookie:@"play"];
    play =@([play intValue]+1);
    [GDUtils setCookie:@"play" andValue:play];
    return play;

}

+(void) customlog:(NSString *)key{
    if([GDstatic enable]){
        if(![key  isEqualToString: @"play"] || ![key isEqualToString:@"visit"]){
            NSNumber* customValue = (NSNumber*)[GDUtils getCookie:key];
            if(customValue == nil){
                customValue = @1;
                [GDUtils setCookie:key andValue:customValue];
            }
            
            GDSendObject* sendObj = [[GDSendObject alloc] init];
            sendObj.action = @"custom";
            sendObj.value = [[GDcustomLog alloc] initWithKeyValue:key andWithValue:customValue];
            sendObj.state = @0; // initial
            [GDLogRequest pushLog:sendObj];
        }
    }
}

+(GDSendObject*)ping{
    if([GDstatic enable]){
        GDSendObject* sendObj = [[GDSendObject alloc] init];
        sendObj.action = @"ping";
        sendObj.value =  @"ping";
        return sendObj;
    }
    return nil;
}

+(void) debug:(Boolean)val{
    [GDstatic setDebug:true];
}

+(void) getXMLData:(NSString *)reqUrl{
    NSURL *url = [NSURL URLWithString:reqUrl];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
            ^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if( data != nil && error ==nil){
                    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithData:data];//init NSXMLParser with receivedXMLData
                    
                    bannerData = [[GDbannerData alloc] init];
                    [xmlParser setDelegate:self]; // Set delegate for NSXMLParser
                    [xmlParser parse]; //Start parsing

                }
                                      
            }];

    [task resume];
}

+(void)parserDidStartDocument:(NSXMLParser *)parser
{
    elementsArray = [[NSMutableArray alloc] init];
}

//store all found characters between elements in currentString mutable string
+(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(!currentString)
    {
        currentString = [[NSString alloc] init];
    }
    currentString = string;
}

//When end of XML tag is found this method gets notified
+(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if([elementName isEqualToString:@"tim"])
    {
        bannerData.timeOut = [currentString intValue];
        return;
    }
    if([elementName isEqualToString:@"act"])
    {
        bannerData.enable = [currentString intValue] || 0;
        [GDstatic setEnable:bannerData.enable];
        return;
    }
    if([elementName isEqualToString:@"pre"])
    {
        bannerData.pre = [currentString intValue] || 0;
        return;
    }

//    if([elementName isEqualToString:@"sat"])
//    {
//        bannerData.showAfterTimeout = (int) currentString;
//        
//        return;
//    }
    if([elementName isEqualToString:@"andver"])
    {
        bannerData.apiVersion = [currentString floatValue];
        
        return;
    }
    if([elementName isEqualToString:@"aid"])
    {
        bannerData.affiliateId = currentString;
        [GDstatic setAffiliateId:currentString];
        return;
    }
    if([elementName isEqualToString:@"iosadu"])
    {
        bannerData.adUnit = currentString;
        [GDstatic setAdUnit:currentString];
        return;
    }
}

//Parsing has ended
+ (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if(gdAPI == nil){
        [self initGDApi]; // initialize GDApi
        NSLog(@"Api is initialized.");
    }
    
    if(bannerData.pre && !preShowed){
        if(isCordovaPlugin){
            [gdAPI requestInterstitialForCordova];
        }
        else{
            [gdAPI requestInterstitial];
        }
        
        preShowed = true;
    }
}

+ (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [parseError localizedDescription];
}


+(void) showBanner:(Boolean)isInterstitial{
    
    if(gdAPI != nil){
        if(isInterstitial){
            [gdAPI requestInterstitial];
        }
        else{
            NSString* defAlignment = CENTER;
            NSString* defPosition = BOTTOM;
            NSString* defAdsize = BANNER;
            [gdAPI requestBanner:defAdsize andAlinment:defAlignment andPositon:defPosition];
        }
    }
    else{
        NSLog(@"Api is not initialized!");
    }
}

+(void) showBanner:(NSString *)adsize withAlignment:(NSString *)alignment withPosition:(NSString *)position{
    
    if(gdAPI != nil){
        [gdAPI requestBanner:adsize andAlinment:alignment andPositon:position];
    }
    else{
        NSLog(@"Api is not initialized!");
    }
}
+(void) addTestDevice:(NSString *)deviceID{
    
    if(gdAPI != nil){
        [gdAPI addTestDevice:deviceID];
    }
    else{
        NSLog(@"Api is not initialized!");
    }
}

+(void) closeBanner{
    if(gdAPI != nil){
        [gdAPI destroyBanner];
    }
    else{
        NSLog(@"Api is not initialized!");
    }
}

+(NSString*) getTestDevice{
    
    if(gdAPI != nil){
        return [gdAPI getTestDevice];
    }
    else{
        NSLog(@"Api is not initialized!");
        return nil;
    }
}

+(void) addEventListener:(GDAdDelegate *)sender{
    delegate = sender;
    
    if(gdAPI != nil){
        [gdAPI setDelegate:delegate];
    }
}

@end
