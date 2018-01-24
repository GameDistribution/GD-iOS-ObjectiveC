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

+(void) log:(NSString *)str{
    NSLog(@"GD: %@",str);
}

+(NSString*) getBannerServerURL{    
    NSString* url = [[NSString alloc] initWithFormat:@"http://%@.bn.submityourgame.com/%@.xml?ver=800&url=http://www.gamedistribution.com",[GDstatic serverId],[GDstatic gameId]];
    return url;
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
        return jsonString;
        
    }
    return nil;
}

@end
