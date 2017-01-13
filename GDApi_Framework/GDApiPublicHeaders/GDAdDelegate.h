//
//  GDAdDelegate.h
//  TestGDApi
//
//  Created by Emre Demir on 27/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#ifndef GDAdDelegate_h
#define GDAdDelegate_h
#import <Foundation/Foundation.h>

@class GDAdDelegate;
@protocol AdDelegate <NSObject>

-(void) onBannerReceived:(GDAdDelegate*) sender withData:(NSData*) data;
//-(void) onBannerStarted:(GDAdDelegate*) sender;
-(void) onBannerClosed:(GDAdDelegate*) sender;
-(void) onBannerFailedToLoad:(GDAdDelegate*) sender withData:(NSData*) data;

@end

@interface GDAdDelegate : NSObject

@property (nonatomic, weak) id <AdDelegate> delegate;
-(void) dispatchEvent:(NSString*) event withData:(NSData*) data;

@end

#endif /* GDAdDelegate_h */
