//
//  GDlogchannel.m
//  gdapi
//
//  Created by Emre Demir on 19/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDpostObj.h"
#import "GDSendObject.h"
#import "GDlogchannel.h"
#import "GDUtils.h"
#import "GDstatic.h"
#import "GDLogger.h"
#import "GDLogRequest.h"
#import "GDResponseActRes.h"

@implementation GDlogchannel: NSObject

//NSString* callbackParam;
NSThread* thread;

static GDpostObject* postObj;
static GDSendObject* lastAction;


+(GDpostObject*) postObj{
    return postObj;
}
+(GDSendObject*) lastAction{
    return lastAction;
}

+(void) init{
    
    if([GDstatic enable]){
        thread = [[NSThread alloc]
                  initWithTarget:self
                  selector:@selector(timerHandler:)
                  object:nil];

        postObj = [[GDpostObject alloc] init];
        postObj.gid = [GDstatic gameId];
        postObj.ref = @"http://ios.os";
        postObj.sid = [GDUtils getSessionId];
        postObj.ver = [GDstatic version];
        [thread start];
    }
   
}

+(void) timerHandler:(id)param{
    
    @autoreleasepool {
        do {
            [GDUtils log:@"Timer is working"];
            
            if([GDstatic enable]){
                
                GDSendObject* actionArray = [GDLogger ping];
                if([[GDLogRequest pool] count]>0){
                    lastAction = actionArray = [[GDLogRequest pool] objectAtIndex:0];
                    [[GDLogRequest pool] removeObjectAtIndex:0];
                }
                
            //    postObj.cbp = callbackParam;
//                postObj.act =[GDUtils objectToJSONString:actionArray];
                postObj.act = [actionArray toJson];
//                postObj.act = [actionArray toJSONString]; // handle error, dont forget!
                
                [self fetchData:[GDUtils getAnalyticServerURL] andWithObject: postObj];
                
            }
            
            [NSThread sleepForTimeInterval:30.0];
        } while (TRUE);
    }
}


+(void) fetchData:(NSString *)reqUrl andWithObject:(GDpostObject*)postObj{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:reqUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSString* params = [postObj toQueryString];
    NSData *postData = [params dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        if (error != nil) {
            [self onFailure:error];
        }
        else{
            // If no error occurs, check the HTTP status code.
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            // If it's other than 200, then show it on the console.
            if (HTTPStatusCode == 200) {
                [self onSuccess:data];
            }
        }

    }];
    
    [postDataTask resume];
}

+(void) onFailure:(NSError*) error{
    
    [GDUtils log:[NSString stringWithFormat:@"fetchData onFailure: %@",[error description]]];
    
    if(lastAction != nil && ![lastAction.action isEqualToString:@"visit"]){
        [GDLogRequest pushLog:lastAction];
    }
    
    GDSendObject* sendObj = [[GDSendObject alloc] init];
    sendObj.action = @"visit";
    sendObj.value = (NSNumber*)[GDUtils getCookie:@"visit"];
    sendObj.state = (NSNumber*)[GDUtils getCookie:@"state"];
    
    [GDLogRequest pushLogFirst:sendObj];
}

+(void) onSuccess:(NSData*) data{
    lastAction = nil;
    NSError* error;
    NSDictionary* res = [NSJSONSerialization JSONObjectWithData:data
                                                    options:0
                                                      error:&error];
    
    if(data != nil && error == nil && ![[res description] isEqualToString:@"{}"]){
        
        GDresponseData* vars= [[GDresponseData alloc] init];
        vars.res = [res objectForKey:@"res"];
        vars.act = [res objectForKey:@"act"];
        vars.custom = [res objectForKey:@"custom"];
        
        if(vars.custom != nil && vars.res !=nil && vars.act != nil){
            [GDLogRequest doResponse:vars];
        }
        else if(vars.custom == nil && vars.res !=nil && vars.act != nil){
            [GDLogRequest doResponse:vars];
        }
        else{
            [GDUtils log:[NSString stringWithFormat:@"onCompleted JSON Error: %@",[error description]]];
            [GDLogger visit];
        }
    
    }
    
    else{
        [GDUtils log:[NSString stringWithFormat:@"onCompleted JSON Error: %@",[error description]]];
        [GDLogger visit];
    }
    
    
}

//-(void) startGetRequest:(NSString *)reqUrl{
//    NSError *error;
//    NSURL *url = [NSURL URLWithString:reqUrl];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
//                                            completionHandler:
//                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
//                                      if (data.length > 0 && error == nil)
//                                      {
//                                          NSDictionary * jsonDic =[NSDictionary ];
//                                          NSLog(@"Response print Hear%@",jsonDic);
//                                      }
//                                  }];
//    
//    [task resume];
//}




@end
