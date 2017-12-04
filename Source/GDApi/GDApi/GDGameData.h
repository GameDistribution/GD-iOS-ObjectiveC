//
//  GDGameData.h
//  GDApi
//
//  Created by Emre Demir on 1.12.2017.
//  Copyright © 2017 Vooxe. All rights reserved.
//

#ifndef GDGameData_h
#define GDGameData_h

@interface GDGameData : NSObject

+(bool) enableAds;
+(void) setEnableAds:(bool) val;
+(bool) preRoll;
+(void) setpreRoll:(bool) val;
+(NSString*) gameMd5;
+(void) setGameMd5:(NSString*) val;
+(NSString*)title;
+(void) setTitle:(NSString*) val;
+(int) timeAds;
+(void) setTimeAds:(int) val;


@end

#endif /* GDGameData_h */
