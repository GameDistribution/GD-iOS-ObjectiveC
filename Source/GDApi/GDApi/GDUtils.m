//
//  GDUtils.m
//  gdapi
//
//  Created by Emre Demir on 18/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDUtils.h"
#include <time.h>
#include <stdlib.h>
#import "GDLogger.h"
#import "GDstatic.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>


@implementation GDUtils:NSObject

int static counter = 0;

+(NSString*) getSessionId{
    
    NSDate* sid1 = [NSDate date];
    srand(time(NULL));
    int sid2 = rand();
    NSString *sid = [NSString stringWithFormat:@"%@%d%d",sid1,sid2,counter++];
    
    return [self generateMD5:sid];
}

+(void) setCookie:(NSString *)key andValue:(NSObject*) value{
    [[GDLogger cookie] setObject:value forKey:key];
    [[GDLogger cookie] synchronize];
}

+(NSObject*) getCookie:(NSString*) key{
    return [[GDLogger cookie] objectForKey:key];
}

+(void) log:(NSString *)str{
    NSLog(@"GD: %@",str);
}

+(NSString*) getBannerServerURL{    
    NSString* url = [[NSString alloc] initWithFormat:@"http://%@.bn.submityourgame.com/%@.xml?ver=800&url=http://www.gamedistribution.com",[GDstatic serverId],[GDstatic gameId]];
    return url;
}

+(NSString*) getAnalyticServerURL{
    NSString* url = [[NSString alloc] initWithFormat:@"http://%@.%@.submityourgame.com/%@/",[GDstatic regId],[GDstatic serverId],[GDstatic sVersion]];
    return url;
}

+(NSString*) generateMD5:(NSString *)str{
        const char *cStr = [str UTF8String];
        unsigned char result[CC_MD5_DIGEST_LENGTH];
    
        CC_MD5( cStr, strlen(cStr), result );
    
        return [NSString
                 stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                 result[0], result[1],
                 result[2], result[3],
                 result[4], result[5],
                 result[6], result[7],
                 result[8], result[9],
                 result[10], result[11],
                 result[12], result[13],
                 result[14], result[15]
                 ];
}

+(NSString*) objectToJSONString:(NSObject*)obj{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    objc_property_t *attributes = class_copyPropertyList([obj class], &count);
    objc_property_t property;
    NSString *key, *value;
    
    for (int i = 0; i < count; i++)
    {
        property = attributes[i];
        key = [NSString stringWithUTF8String:property_getName(property)];
        value = [obj valueForKey:key];
        [dict setObject:(value ? value : @"") forKey:key];
    }
    
    free(attributes);
    attributes = nil;
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData.length > 0 && !error)
    {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"json string: %@",jsonString);
        
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n"
                                                          withString:@""];
//        
//        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\"
//                                                           withString:@"reha"];

        return jsonString;
        
    }
    return nil;
}

@end
