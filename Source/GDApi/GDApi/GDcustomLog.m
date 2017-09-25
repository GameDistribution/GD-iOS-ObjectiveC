//
//  GDcustomLog.m
//  gdapi
//
//  Created by Emre Demir on 16/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDcustomLog.h"

@implementation GDcustomLog

-(id) initWithKeyValue:(NSString *)_newkey andWithValue:(NSNumber*)_newvalue{
    self.key = _newkey;
    self.value = _newvalue;
    return self;
}

-(id) init{
    self.key = @"";
    self.value = 0;
    return self;
}

@end
