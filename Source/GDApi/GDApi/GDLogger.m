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
#import "Reachability.h"

@implementation GDLogger

static GDAd* gdAPI;
static GDAd* gdPreloadStream;
NSMutableArray* elementsArray;
NSString* currentString;
GDAdDelegate* delegate;

+(void) init:(NSString *)gameId andWithRegId:(NSString *)regId
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status != NotReachable)
    {
        NSString* lowercaseRegId = [regId lowercaseString];
        NSArray* gameserver = [lowercaseRegId componentsSeparatedByString:@"-"];
        
        if([gameserver count] == 6){
            
            NSString *targetUrl = [NSString stringWithFormat:@"%@/%@",[GDstatic GAME_API_URL],gameId];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            [request setURL:[NSURL URLWithString:targetUrl]];
            
            [self initGDApi];
            
            if(![GDstatic testAds]){
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
                                  
                                  @try {
                                      NSDictionary* _result = [res objectForKey:@"result"];
                                      NSDictionary* game = [_result objectForKey:@"game"];
                                      
                                      [GDGameData setEnableAds:[game valueForKey:@"enableAds"]];
                                      [GDGameData setGameMd5:[game valueForKey:@"gameMd5"]];
                                      [GDGameData setpreRoll:[game valueForKey:@"preRoll"]];
                                      [GDGameData setTimeAds:[[game valueForKey:@"timeAds"] intValue]];
                                      [GDGameData setTitle:[game valueForKey:@"title"]];
                                      [GDGameData setBundleId:[game valueForKey:@"iosBundleId"]];
                                      
                                      [GDstatic setRegId:[NSString stringWithFormat:@"%@-%@-%@-%@-%@",[gameserver objectAtIndex:0],[gameserver objectAtIndex:1],[gameserver objectAtIndex:2],[gameserver objectAtIndex:3],[gameserver objectAtIndex:4]]];
                                      [GDstatic setServerId:[gameserver objectAtIndex:5]];
                                      [GDstatic setGameId:gameId];
                                      [GDstatic setEnable:true];
                                      
                                      [self requestPreload];

                                      if([self gdAPI].delegate != nil){
                                          [[self gdAPI].delegate dispatchEvent:@"onAPIReady" withData:nil];
                                      }
                                      
                                      
                                  }
                                  @catch (NSException *exception) {
                                      if([self gdAPI].delegate != nil){
                                          
                                          NSArray *keys = [NSArray arrayWithObjects:@"error", nil];
                                          NSArray *objects = [NSArray arrayWithObjects: @"Something wrong with parsing game data.", nil];
                                          NSDictionary *myData = [NSDictionary dictionaryWithObjects:objects
                                                                                             forKeys:keys];
                                          NSData* eventData = [NSKeyedArchiver archivedDataWithRootObject:myData];
                                          
                                          [[self gdAPI].delegate dispatchEvent:@"onAPINotReady" withData:eventData];
                                      }
                                      gdAPI = nil;
                                      
                                  }
                                  
                              }
                              else{
                                  NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                  [GDUtils log:@"Something went wrong fetching game data."];
                                  [GDUtils log:errorStr];
                                  
                                  if([self gdAPI].delegate != nil){
                                      
                                      NSArray *keys = [NSArray arrayWithObjects:@"error", nil];
                                      NSArray *objects = [NSArray arrayWithObjects: errorStr, nil];
                                      NSDictionary *myData = [NSDictionary dictionaryWithObjects:objects
                                                                                         forKeys:keys];
                                      NSData* eventData = [NSKeyedArchiver archivedDataWithRootObject:myData];
                                      
                                      [[self gdAPI].delegate dispatchEvent:@"onAPINotReady" withData:eventData];
                                  }
                                  
                                  gdAPI = nil;
                              }
                          }
                          else{
                              [GDUtils log:@"Gama data is not available."];
                              
                              if([self gdAPI].delegate != nil){
                                  
                                  NSArray *keys = [NSArray arrayWithObjects:@"error", nil];
                                  NSArray *objects = [NSArray arrayWithObjects:@"Gama data is not available.", nil];
                                  NSDictionary *myData = [NSDictionary dictionaryWithObjects:objects
                                                                                     forKeys:keys];
                                  NSData* eventData = [NSKeyedArchiver archivedDataWithRootObject:myData];
                                  
                                  [[self gdAPI].delegate dispatchEvent:@"onAPINotReady" withData:eventData];
                              }
                              
                              gdAPI = nil;
                              
                          }
                          
                      }
                      else{
                          [GDUtils log:@"Network error."];
                          
                          if([self gdAPI].delegate != nil){
                              
                              NSArray *keys = [NSArray arrayWithObjects:@"error", nil];
                              NSArray *objects = [NSArray arrayWithObjects:@"Network error.", nil];
                              NSDictionary *myData = [NSDictionary dictionaryWithObjects:objects
                                                                                 forKeys:keys];
                              NSData* eventData = [NSKeyedArchiver archivedDataWithRootObject:myData];
                              
                              [[self gdAPI].delegate dispatchEvent:@"onAPINotReady" withData:eventData];
                          }
                          
                          gdAPI = nil;
                      }
                      
                  }] resume];
                
            }
            else{
                if([self gdAPI].delegate != nil){
                    [[self gdAPI].delegate dispatchEvent:@"onAPIReady" withData:nil];
                }
            }
            
        }
        else{
            NSLog(@"RegID is not valid.");
            
            if([self gdAPI].delegate != nil){
                
                NSArray *keys = [NSArray arrayWithObjects:@"error", nil];
                NSArray *objects = [NSArray arrayWithObjects: @"RegID is not valid.", nil];
                NSDictionary *myData = [NSDictionary dictionaryWithObjects:objects
                                                                   forKeys:keys];
                NSData* eventData = [NSKeyedArchiver archivedDataWithRootObject:myData];
                
                [[self gdAPI].delegate dispatchEvent:@"onAPINotReady" withData:eventData];
            }
        }
    }
    else{
        
        if([self gdAPI].delegate != nil){
            NSArray *keys = [NSArray arrayWithObjects:@"error", nil];
            NSArray *objects = [NSArray arrayWithObjects:@"API cannot connect to internet. Please check the network connection.", nil];
            NSDictionary *myData = [NSDictionary dictionaryWithObjects:objects
                                                               forKeys:keys];
            NSData* eventData = [NSKeyedArchiver archivedDataWithRootObject:myData];
            
            [[self gdAPI].delegate dispatchEvent:@"onAPINotReady" withData:eventData];
        }
        
    }
    
   
    
}

+(void) initGDApi{
    if(gdAPI == nil){
        UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        gdAPI = [[GDAd alloc] init:rootViewController andWithDelegate:delegate andWithIsPreloadStream:false];
        gdPreloadStream = [[GDAd alloc] init:rootViewController andWithDelegate:delegate andWithIsPreloadStream:true];
    }
}

+(GDAd*) gdAPI{
    return gdAPI;
}

+(GDAd*) gdPreloadStream{
    return gdPreloadStream;
}

+(void) debug:(Boolean)val{
    [GDstatic setDebug:true];
}

+(void) showBanner:(Boolean)isInterstitial{
    
    if(gdAPI != nil){
        
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
        
        NetworkStatus status = [reachability currentReachabilityStatus];
        
        if(status != NotReachable)
        {
            if(isInterstitial){
                
                if([gdPreloadStream isPreloadedAdExist]){
                    [gdPreloadStream showPreloadedAd];
                }
                else{
                    if(![GDstatic testAds])
                        [self showAd:true withSize:nil withAlignment:nil withPosition:nil];
                    else
                        [gdAPI requestInterstitial];
                    
                    //[self requestPreload]; // preload ad for next request.
                }
            }
            else{
                if(![GDstatic testAds])
                    [self showAd:false withSize:BANNER withAlignment:CENTER withPosition:BOTTOM];
                else
                    [gdAPI requestBanner:BANNER andAlinment:CENTER andPositon:BOTTOM];
            }
        }
        else{
           // no internet connection
            
            if([self gdAPI].delegate != nil){
                NSArray *keys = [NSArray arrayWithObjects:@"error", nil];
                NSArray *objects = [NSArray arrayWithObjects:@"API cannot connect to internet. Please check the network connection.", nil];
                NSDictionary *myData = [NSDictionary dictionaryWithObjects:objects
                                                                   forKeys:keys];
                NSData* eventData = [NSKeyedArchiver archivedDataWithRootObject:myData];
                
                [[self gdAPI].delegate dispatchEvent:@"onBannerFailedToLoad" withData:eventData];
            }
        }
    }
    else{
        NSLog(@"Api is not initialized!");
    }
}

+(void) showBanner:(NSString *)adsize withAlignment:(NSString *)alignment withPosition:(NSString *)position{
    
    if(gdAPI != nil){
        
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
        
        NetworkStatus status = [reachability currentReachabilityStatus];
        
        if(status != NotReachable){
            [self showAd:false withSize:adsize withAlignment:alignment withPosition:position];
        }
        else{
            if([self gdAPI].delegate != nil){
                NSArray *keys = [NSArray arrayWithObjects:@"error", nil];
                NSArray *objects = [NSArray arrayWithObjects:@"API cannot connect to internet. Please check the network connection.", nil];
                NSDictionary *myData = [NSDictionary dictionaryWithObjects:objects
                                                                   forKeys:keys];
                NSData* eventData = [NSKeyedArchiver archivedDataWithRootObject:myData];
                
                [[self gdAPI].delegate dispatchEvent:@"onBannerFailedToLoad" withData:eventData];
            }
        }
        
    }
    else{
        NSLog(@"Api is not initialized!");
    }
}

+(void) showAd:(Boolean)isInterstitial withSize:(NSString *)adsize withAlignment:(NSString *)alignment withPosition:(NSString *)position{
    
    if(gdAPI != nil){
        NSString *msize = @"interstitial";
        
        if(!isInterstitial){
            msize = adsize;
        }
        
        NSString *targetUrl = [NSString stringWithFormat:@"https://pub.tunnl.com/oppm?bundleid=ios.%@&msize=%@",[GDGameData bundleId],msize];
        
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
                      NSArray *tunnlData = [res objectForKey:@"Items"];
                      [gdAPI setTunnlData:tunnlData];
                      
                      if([tunnlData count] > 0){
                          if(isInterstitial){
                              [gdAPI requestInterstitial];
                          }
                          else{
                              [gdAPI requestBanner:adsize andAlinment:alignment andPositon:position];
                          }
                      }
                      else{
                          [GDUtils log:@"Game data is not empty."];
                          NSArray *keys = [NSArray arrayWithObjects:@"error", nil];
                          NSArray *objects = [NSArray arrayWithObjects: @"Game data is empty.", nil];
                          NSDictionary *myData = [NSDictionary dictionaryWithObjects:objects
                                                                             forKeys:keys];
                          NSData* eventData = [NSKeyedArchiver archivedDataWithRootObject:myData];
                          
                          [[self gdAPI].delegate dispatchEvent:@"onBannerFailedToLoad" withData:eventData];
                      }
                      
                  }
                  else{
                      [GDUtils log:@"Tunnl data is not json."];
                      NSArray *keys = [NSArray arrayWithObjects:@"error", nil];
                      NSArray *objects = [NSArray arrayWithObjects: @"Something went wrong parsing game data.", nil];
                      NSDictionary *myData = [NSDictionary dictionaryWithObjects:objects
                                                                         forKeys:keys];
                      NSData* eventData = [NSKeyedArchiver archivedDataWithRootObject:myData];
                      
                      [[self gdAPI].delegate dispatchEvent:@"onBannerFailedToLoad" withData:eventData];
                  }
              }
              else{
                  NSArray *keys = [NSArray arrayWithObjects:@"error", nil];
                  NSArray *objects = [NSArray arrayWithObjects: @"Something went wrong fetching game data.", nil];
                  NSDictionary *myData = [NSDictionary dictionaryWithObjects:objects
                                                                     forKeys:keys];
                  NSData* eventData = [NSKeyedArchiver archivedDataWithRootObject:myData];
                  
                  [[self gdAPI].delegate dispatchEvent:@"onBannerFailedToLoad" withData:eventData];
              }
              
          }] resume];
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
}

+(void) enableTestAds {
    [GDstatic setTestAds:true];
}

+(void) requestPreload {
    if(gdPreloadStream != nil){
        NSString *msize = @"interstitial";
        
        NSString *targetUrl = [NSString stringWithFormat:@"https://pub.tunnl.com/oppm?bundleid=ios.%@&msize=%@",[GDGameData bundleId],msize];
        
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
                      NSArray *tunnlData = [res objectForKey:@"Items"];
                      [gdPreloadStream setTunnlData:tunnlData];
                      
                      if([tunnlData count] > 0){
                          [gdPreloadStream requestInterstitial];
                      }
                      else{
                          [GDUtils log:@"Game data is empty."];
                          NSArray *keys = [NSArray arrayWithObjects:@"error", nil];
                          NSArray *objects = [NSArray arrayWithObjects: @"Game data is empty.", nil];
                          NSDictionary *myData = [NSDictionary dictionaryWithObjects:objects
                                                                             forKeys:keys];
                          NSData* eventData = [NSKeyedArchiver archivedDataWithRootObject:myData];
                          
                          [[self gdPreloadStream].delegate dispatchEvent:@"onPreloadFailed" withData:eventData];
                      }
                      
                  }
                  else{
                      [GDUtils log:@"Tunnl data is not json."];
                      NSArray *keys = [NSArray arrayWithObjects:@"error", nil];
                      NSArray *objects = [NSArray arrayWithObjects: @"Something went wrong parsing game data.", nil];
                      NSDictionary *myData = [NSDictionary dictionaryWithObjects:objects
                                                                         forKeys:keys];
                      NSData* eventData = [NSKeyedArchiver archivedDataWithRootObject:myData];
                      
                      [[self gdPreloadStream].delegate dispatchEvent:@"onPreloadFailed" withData:eventData];
                  }
              }
              else{
                  NSArray *keys = [NSArray arrayWithObjects:@"error", nil];
                  NSArray *objects = [NSArray arrayWithObjects: @"Something went wrong fetching game data.", nil];
                  NSDictionary *myData = [NSDictionary dictionaryWithObjects:objects
                                                                     forKeys:keys];
                  NSData* eventData = [NSKeyedArchiver archivedDataWithRootObject:myData];
                  
                 [[self gdPreloadStream].delegate dispatchEvent:@"onPreloadFailed" withData:eventData];
              }
              
          }] resume];
    }
}
@end
