//
//  GDlogchannel.h
//  gdapi
//
//  Created by Emre Demir on 19/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#ifndef GDlogchannel_h
#define GDlogchannel_h
#import "GDpostObj.h"
#import "GDSendObject.h"

@interface GDlogchannel : NSObject

+(GDpostObject*) postObj;
+(GDSendObject*) lastAction;

+(void) init;
+(void) timerHandler:(id)param;
+(void) fetchData:(NSString *)reqUrl andWithObject:(GDpostObject*)postObj;
+(void) onFailure:(NSError*) error;
+(void) onSuccess:(NSData*) data;
@end

#endif /* GDlogchannel_h */
