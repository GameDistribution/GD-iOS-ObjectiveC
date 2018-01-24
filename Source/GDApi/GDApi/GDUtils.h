//
//  GDUtils.h
//  gdapi
//
//  Created by Emre Demir on 18/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#ifndef GDUtils_h
#define GDUtils_h

#import <Foundation/Foundation.h>


@interface GDUtils : NSObject

+(void) log:(NSString*) str;
+(NSString*) getBannerServerURL;
+(NSString*) getAnalyticServerURL;
+(NSString*) objectToJSONString:(NSObject*)obj;

@end

#endif /* GDUtils_h */
