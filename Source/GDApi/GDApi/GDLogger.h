//
//  GDLogger.h
//  gdapi
//
//  Created by Emre Demir on 19/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#ifndef GDLogger_h
#define GDLogger_h
#import "GDAd.h"

@interface GDLogger :NSObject

@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) NSMutableArray *arrNeighboursData;
@property (nonatomic, strong) NSMutableDictionary *dictTempDataStorage;
@property (nonatomic, strong) NSMutableString *foundValue;
@property (nonatomic, strong) NSString *currentElement;

+(GDAd*) gdAPI;
+(GDAd*) gdPreloadStream;
+(void) init:(NSString*) gameId andWithRegId:(NSString*) regId;
+(void) debug:(Boolean)val;
+(void) showBanner:(Boolean) isInterstitial;
+(void) showBanner:(NSString*) adsize withAlignment:(NSString*) alignment withPosition:(NSString*) position;
+(void) addEventListener:(GDAdDelegate*) sender;
+(void) closeBanner;
+(void) enableTestAds;
+(void) showAd:(Boolean)isInterstitial withSize:(NSString *)adsize withAlignment:(NSString *)alignment withPosition:(NSString *)position;

@end

#endif /* GDLogger_h */
