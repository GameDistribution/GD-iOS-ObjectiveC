//
//  GDAd.h
//  GDApi
//
//  Created by Emre Demir on 30/12/16.
//  Copyright © 2016 Vooxe. All rights reserved.
//

#ifndef GDAd_h
#define GDAd_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "GDAdDelegate.h"


@interface GDAd : NSObject
-(id) init:(UIViewController *) context andWithDelegate:(GDAdDelegate*) eventlistener;
-(void) requestInterstitial;
-(void) requestBanner: (NSString *) size andAlinment:(NSString*) alignment andPositon:(NSString *)position;
-(void) addCustomTargeting:(NSString *) tag andValue:(NSString*) value;
-(void) destroyBanner;
-(GDAdDelegate*) delegate;
-(void) setDelegate:(GDAdDelegate*) del;
-(void) setTunnlData:(NSArray*) tunnlData;
@end


#endif /* GDAd_h */
