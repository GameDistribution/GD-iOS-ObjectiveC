//
//  GDstatic.h
//  gdapi
//
//  Created by Emre Demir on 19/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#ifndef GDstatic_h
#define GDstatic_h

@interface GDstatic : NSObject

+(float) apiVersion;
+(NSString*) version;
+(Boolean) enable;
+(void) setEnable:(Boolean) val;
+(Boolean) debug;
+(void) setDebug:(Boolean) val;
+(NSString*) serverId;
+(void) setServerId:(NSString*) val;
+(NSString*)regId;
+(void) setRegId:(NSString*) val;
+(NSString*) gameId;
+(void) setGameId:(NSString*) val;
+(NSString*) sVersion;
+(NSString*) PREFS_NAME;
+(NSString*) adUnit;
+(void) setAdUnit:(NSString*) val;
+(NSString*) affiliateId;
+(void) setAffiliateId:(NSString*) val;
+(NSString*) bannerServerURL;
+(void) setBannerServerURL:(NSString*)val;
+(NSString*) analyticServerURL;
+(void) setAnalyticServerURL:(NSString*)val;

@end
#endif /* GDstatic_h */
