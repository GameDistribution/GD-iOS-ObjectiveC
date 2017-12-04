//
//  GDGameData.m
//  GDApi
//
//  Created by Emre Demir on 1.12.2017.
//  Copyright © 2017 Vooxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDGameData.h"

@implementation GDGameData:NSObject

static NSString* title;
static NSString* gameMd5;
static bool enableAds;
static bool preRoll;
static int timeAds;



+(bool) enableAds{
    return enableAds;
}
+(void) setEnableAds:(bool)val{
    enableAds = val;
}

+(bool) preRoll{
    return preRoll;
}
+(void) setpreRoll:(bool) val{
    preRoll = val;
}

+(NSString*) gameMd5{
    return gameMd5;
}
+(void) setGameMd5:(NSString *)val{
    gameMd5 = val;
}

+(NSString*) title{
    return title;
}
+(void) setTitle:(NSString *)val{
    title = val;
}

+(int) timeAds{
    return timeAds;
}
+(void) setTimeAds:(int) val{
    timeAds = val;
}

@end
