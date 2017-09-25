//
//  GDLogRequest.m
//  gdapi
//
//  Created by Emre Demir on 16/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDLogRequest.h"
#import "GDSendObject.h"
#import "GDUtils.h"


@implementation GDLogRequest

NSString* ANALYTIC_CMD =@"cmd";
NSString* ANALYTIC_VISIT =@"visit";
NSString* ANALYTIC_PLAY  =@"play";
NSString* ANALYTIC_CUSTOM = @"custom";
NSString* ANALYTIC_STATE = @"state";
NSString* ANALYTIC_URL = @"url";
NSString* ANALYTIC_JS = @"js";

static NSMutableArray* pool;

+(NSMutableArray*) pool{
    
    if(pool == nil){
        pool = [[NSMutableArray alloc] init];
    }
    
    return pool;
}


+(void) pushLogFirst:(GDSendObject *)_pushAction{
    [[self pool] insertObject:_pushAction atIndex:0];
}

+(void) pushLog:(GDSendObject *)_pushAction{
    
    [self pool]; // just for initialize the Pool if not
    
    GDSendObject* obj;
    int i;
    
    for(i = 0; i< [pool count];i++){
        
        obj = [pool objectAtIndex:i];
     
        if(obj.action == _pushAction.action){
            
            if(obj.action == ANALYTIC_CUSTOM && ((GDcustomLog*) obj.value).key == ((GDcustomLog*)_pushAction.value).key){
                
                NSNumber* num = ((GDcustomLog*)obj.value).value ;
                num = @([num intValue]+1);
                ((GDcustomLog*)obj.value).value = num;
            }
            else{
                obj.value = _pushAction.value;
            }
            break;
        }
    }
    
    if(i == [pool count]){
        [pool addObject:_pushAction];
    }
}

+ (void) doResponse:(GDresponseData *)_data{
    
    NSString* currentSid = [GDUtils getSessionId];
    NSString* responseSid = _data.res;
    
    if(_data.act == ANALYTIC_CMD){
        
        GDSendObject* sendObj = [[GDSendObject alloc] init];
        
        if(_data.res == ANALYTIC_VISIT){
            sendObj.action = @"visit";
            sendObj.value = (NSNumber*)[GDUtils getCookie:@"visit"];
            sendObj.state = (NSNumber*)[GDUtils getCookie:@"state"];
            [self pushLogFirst:sendObj];
            
        }

    }
    else if(_data.act == ANALYTIC_VISIT){
        if (responseSid == currentSid) {
            int state = (int)[GDUtils getCookie:@"state"];
            state++;
            [GDUtils setCookie:@"visit" andValue:[NSNumber numberWithInt:0]];
            [GDUtils setCookie:@"state" andValue:[NSNumber numberWithInt:state]];
        
        }
    }
    else if(_data.act == ANALYTIC_PLAY){
        if (responseSid == currentSid) {
            [GDUtils setCookie:@"play" andValue:[NSNumber numberWithInt:0]];
        }
    }
    else if(_data.act == ANALYTIC_CUSTOM){
        if (responseSid == currentSid) {
            [GDUtils setCookie:_data.custom andValue:[NSNumber numberWithInt:0]];
        }
    }
    
    
}


@end
