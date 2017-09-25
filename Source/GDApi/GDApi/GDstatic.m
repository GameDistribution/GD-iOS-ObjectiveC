//
//  GDstatic.m
//  gdapi
//
//  Created by Emre Demir on 19/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDstatic.h"

@implementation GDstatic:NSObject


static float apiVersion = (float) 1.0;
static NSString* version = @"v1.0";
static Boolean enable = false;
static Boolean debug = false;
static NSString* serverId;
static NSString* regId;
static NSString* gameId;
static NSString* sVersion = @"v1";
static NSString* PREFS_NAME = @"GDPrefsFile";
static NSString* adUnit;
static NSString* affiliateId;
static NSString* bannerServerURL;
static NSString* analyticServerURL;


+(NSString*) bannerServerURL{
    return bannerServerURL;
}
+(void) setBannerServerURL:(NSString *)val{
    bannerServerURL = val;
}
+(NSString*) analyticServerURL{
    return analyticServerURL;
}
+(void) setAnalyticServerURL:(NSString *)val{
    analyticServerURL = val;
}
+(float)apiVersion{
    return apiVersion;
}
+(NSString*) version{
    return version;
}
+(Boolean) enable{
    return enable;
}
+(void) setEnable:(Boolean)val{
    enable = val;
}
+(Boolean) debug{
    return debug;
}
+(void) setDebug:(Boolean)val{
    debug = val;
}
+(NSString*) serverId{
    return serverId;
}
+(void) setServerId:(NSString*)val{
    serverId = val;
}
+(NSString*) regId{
    return regId;
}
+(void) setRegId:(NSString *)val{
    regId = val;
}
+(NSString*) gameId{
    return gameId;
}
+(void) setGameId:(NSString *)val{
    gameId = val;
}
+(NSString*) sVersion{
    return sVersion;
}
+(NSString*) PREFS_NAME{
    return PREFS_NAME;
}
+(NSString*) adUnit{
    return adUnit;
}
+(void) setAdUnit:(NSString *)val{
    adUnit = val;
}
+(NSString*) affiliateId{
    return affiliateId;
}
+(void) setAffiliateId:(NSString *)val{
    affiliateId = val;
}


@end
