//
//  GDLogger.h
//  gdapi
//
//  Created by Emre Demir on 19/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#ifndef GDLogger_h
#define GDLogger_h
#import "GDSendObject.h"
#import "GDAd.h"

@interface GDLogger :NSObject

@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) NSMutableArray *arrNeighboursData;
@property (nonatomic, strong) NSMutableDictionary *dictTempDataStorage;
@property (nonatomic, strong) NSMutableString *foundValue;
@property (nonatomic, strong) NSString *currentElement;

+(GDAd*) gdAPI;
+(NSUserDefaults*) cookie;
+(void) init:(NSString*) gameId andWithRegId:(NSString*) regId;
+(NSNumber*)incVisit;
+(void) visit;
+(GDSendObject*) ping;
+(void) debug:(Boolean)val;
+(void) play;
+(void) customlog:(NSString*)key;
+(NSNumber*) incPlay;
+(void) getXMLData:(NSString *)reqUrl;
+(void) showBanner:(Boolean) isInterstitial;
+(void) showBanner:(NSString*) adsize withAlignment:(NSString*) alignment withPosition:(NSString*) position;
+(void) addTestDevice:(NSString*) deviceID;
+(NSString*) getTestDevice;
+(void) addEventListener:(GDAdDelegate*) sender;
+(void) closeBanner;
@end

#endif /* GDLogger_h */
