//
//  GDcustomLog.h
//  gdapi
//
//  Created by Emre Demir on 16/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#ifndef GDcustomLog_h
#define GDcustomLog_h
#import <Foundation/Foundation.h>

@interface GDcustomLog:NSObject

@property (nonatomic,strong) NSString* key;
@property (assign) NSNumber* value;

-(id) initWithKeyValue:(NSString*)_newKey andWithValue:(NSNumber*) _newValue;
-(id) init;

@end

#endif /* GDcustomLog_h */
