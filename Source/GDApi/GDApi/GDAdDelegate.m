//
//  GDAdDelegate.m
//  TestGDApi
//
//  Created by Emre Demir on 28/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDAdDelegate.h"

@implementation GDAdDelegate

@synthesize delegate;

-(void) dispatchEvent:(NSString*) event withData:(NSData*) data{
    
    if([event isEqualToString:@"onBannerReceived"]){
        [self.delegate onBannerReceived:self withData:data];
    }
//    else if([event isEqualToString:@"onBannerStarted"]){
//        [self.delegate onBannerStarted:self];
//    }
    else if([event isEqualToString:@"onBannerClosed"]){
        [self.delegate onBannerClosed:self];
    }
    else if([event isEqualToString:@"onBannerFailedToLoad"]){
        [self.delegate onBannerFailedToLoad:self withData:data];
    }
}
@end
