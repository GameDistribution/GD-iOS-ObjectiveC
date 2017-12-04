//  GDLogger.m
//  gdapi
//
//  Created by Emre Demir on 19/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDLogger.h"
#import "GDstatic.h"
#import "GDUtils.h"
#import "GDAd.h"
#import "GDAdPosition.h"
#import "GDAlignment.h"
#import "GDAdSize.h"
#import "GDAdDelegate.h"
#import "GDGameData.h"

@implementation GDLogger

static GDAd* gdAPI;
static NSUserDefaults* cookie;
static Boolean isCordovaPlugin = false;
NSMutableArray* elementsArray;
NSString* currentString;
Boolean preShowed = false;
GDAdDelegate* delegate;

+(void) init:(NSString *)gameId andWithRegId:(NSString *)regId
{
    if(gdAPI == nil){
        NSString* lowercaseRegId = [regId lowercaseString];
        NSArray* gameserver = [lowercaseRegId componentsSeparatedByString:@"-"];
        
        if([gameserver count] == 6){
            
            NSString *targetUrl = [NSString stringWithFormat:@"https://game.api.gamedistribution.com/game/get/%@?domain=test.mobile.ios",gameId];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            [request setURL:[NSURL URLWithString:targetUrl]];
            
            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
              ^(NSData * _Nullable data,
                NSURLResponse * _Nullable response,
                NSError * _Nullable error) {
                  
                  if(error == nil){
                      NSDictionary* res = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:kNilOptions
                                                                            error:&error];
                      if(error == nil){
                          
                          bool success = [res objectForKey:@"success"];
                          if(success){
                              NSDictionary* _result = [res objectForKey:@"result"];
                              NSDictionary* game = [_result objectForKey:@"game"];
                              
                              [GDGameData setEnableAds:[game valueForKey:@"enableAds"]];
                              [GDGameData setGameMd5:[game valueForKey:@"gameMd5"]];
                              [GDGameData setpreRoll:[game valueForKey:@"preRoll"]];
                              [GDGameData setTimeAds:[[game valueForKey:@"timeAds"] intValue]];
                              [GDGameData setTitle:[game valueForKey:@"title"]];
                              
                              [GDstatic setRegId:[NSString stringWithFormat:@"%@-%@-%@-%@-%@",[gameserver objectAtIndex:0],[gameserver objectAtIndex:1],[gameserver objectAtIndex:2],[gameserver objectAtIndex:3],[gameserver objectAtIndex:4]]];
                              [GDstatic setServerId:[gameserver objectAtIndex:5]];
                              [GDstatic setGameId:gameId];
                              [GDstatic setEnable:true];
                              
                              [self initGDApi];
                              [GDUtils log:@"Game Distribution iOS API Init"];

                              
                          }
                          else{
                              NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                              [GDUtils log:@"Something went wrong parsing json game data."];
                              [GDUtils log:myData];
                          }
                      }
                      else{
                          [GDUtils log:@"Gama data is not json."];
                      }
                      
                  }
                  
              }] resume];
            
                        
            
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
        gdAPI = [[GDAd alloc] init:rootViewController];
    
        [gdAPI addCustomTargeting:@"apptype" andValue:@"ios"];
        [gdAPI addCustomTargeting:@"gdp" andValue:@"1"];
        
        if(delegate != nil){
            [gdAPI setDelegate:delegate];
        }
        
        if([GDGameData preRoll]){
            [gdAPI requestInterstitial];
        }

    }

}

+(GDAd*) gdAPI{
    return gdAPI;
}

+(void) debug:(Boolean)val{
    [GDstatic setDebug:true];
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

+(void) closeBanner{
    if(gdAPI != nil){
        [gdAPI destroyBanner];
    }
    else{
        NSLog(@"Api is not initialized!");
    }
}

+(void) addEventListener:(GDAdDelegate *)sender{
    delegate = sender;
    
    if(gdAPI != nil){
        [gdAPI setDelegate:delegate];
    }
}

@end
