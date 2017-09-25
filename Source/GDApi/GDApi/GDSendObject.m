//
//  GDSendObject.m
//  testiosComand
//
//  Created by Emre Demir on 16/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDSendObject.h"

@implementation GDSendObject


-(NSString*) toJson{
    
    NSNumber* val;
    GDcustomLog* val2;
    NSString* str =@"";
    
    if( [self.value isKindOfClass:[NSNumber class]]){
        val = (NSNumber*)self.value;
        if(self.state != nil){
            return [[NSString alloc] initWithFormat:@"{\"action\":\"%@\",\"state\":%@,\"value\":%d}",self.action,self.state,[val intValue]];
        }
        else{
            return [[NSString alloc] initWithFormat:@"{\"action\":\"%@\",\"value\":%d}",self.action,[val intValue]];        }
        
    }
    else if([self.value isKindOfClass:[NSString class]]){

        str = (NSString*)self.value;
        if(self.state != nil){
            return [[NSString alloc] initWithFormat:@"{\"action\":\"%@\",\"state\":%@,\"value\":\"%@\"}",self.action,self.state,str];
        }
        else{
            return [[NSString alloc] initWithFormat:@"{\"action\":\"%@\",\"value\":\"%@\"}",self.action,str];
        }
     

    }
    else{
        val2 = (GDcustomLog*) self.value;
        if(self.state != nil){
               return [[NSString alloc] initWithFormat:@"{\"action\":\"%@\",\"state\":%@,\"value\":{\"key\":\"%@\",\"value\":%d}}",self.action,self.state, val2.key,[val2.value intValue]];
        }
        else{
               return [[NSString alloc] initWithFormat:@"{\"action\":\"%@\",\"value\":{\"key\":\"%@\",\"value\":%d}}",self.action, val2.key,[val2.value intValue]];
        }
     
    }
    
}

@end
