//
//  GDLogReuest.h
//  gdapi
//
//  Created by Emre Demir on 16/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#ifndef GDLogReuest_h
#define GDLogReuest_h

#import "GDSendObject.h"
#import "GDresponseData.h"
#import <Foundation/Foundation.h>

@interface GDLogRequest : NSObject

+(NSMutableArray*) pool;

+(void) pushLog:(GDSendObject*) _pushAction;
+(void) pushLogFirst:(GDSendObject*) _pushAction;
+(void) doResponse:(GDresponseData*) _data;

@end


#endif /* GDLogReuest_h */
