//
//  GDSendObject.h
//  gdapi
//
//  Created by Emre Demir on 16/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#ifndef GDSendObject_h
#define GDSendObject_h

#import <Foundation/Foundation.h>
#import "GDcustomLog.h"

@interface GDSendObject : NSObject 

@property (nonatomic,strong) NSString* action;
@property NSObject* value;
@property (assign) NSNumber* state;

-(NSString*) toJson;

@end

#endif /* GDSendObject_h */
