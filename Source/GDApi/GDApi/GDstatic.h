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

+(Boolean) enable;
+(void) setEnable:(Boolean) val;
+(Boolean) debug;
+(void) setDebug:(Boolean) val;
+(Boolean) testAds;
+(void) setTestAds:(Boolean) val;
+(NSString*) serverId;
+(void) setServerId:(NSString*) val;
+(NSString*)regId;
+(void) setRegId:(NSString*) val;
+(NSString*) gameId;
+(void) setGameId:(NSString*) val;
+(NSString*) adUnit;
+(void) setAdUnit:(NSString*) val;
+(NSString*) testAdUnitID;
+(void) setTestAdUnitID:(NSString*) val;
+(NSString*) affiliateId;
+(void) setAffiliateId:(NSString*) val;
+(NSString*) GAME_API_URL;
+(void) setGAME_API_URL:(NSString*)val;


@end
#endif /* GDstatic_h */
