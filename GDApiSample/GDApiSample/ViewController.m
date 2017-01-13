//
//  ViewController.m
//  GDApiSample
//
//  Created by Emre Demir on 06/01/17.
//  Copyright © 2017 Vooxe. All rights reserved.
//

#import "ViewController.h"
@import GoogleMobileAds;
#import <GDApi/GDApi.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onReqBannerClicked:(id)sender {
 
    NSString* size = BANNER;
    NSString* alignment = CENTER;
    NSString* position = TOP;
    
    [GDLogger showBanner:size withAlignment:alignment withPosition:position];
    
//    [GDLogger play];
//    
//    NSString* key =@"your key";
//    [GDLogger customlog:key];

}

- (IBAction)onReqInterstitialClicked:(id)sender {
    [GDLogger showBanner:true];

}

- (IBAction)onInitClicked:(id)sender {
    
    NSString *gid = @"51deada1cd904e0d8e2a4d33e889e038";
    NSString *regid = @"82B343C2-7535-41F8-A620-C518E96DE8F6-s1";
    [GDLogger init:gid andWithRegId:regid];
    
    [GDLogger debug:true];
    
    [GDLogger addEventListener:self];
    

}

- (IBAction)onCloseClicked:(id)sender {
    
    [GDLogger closeBanner];
}


-(void) onBannerReceived:(GDAdDelegate*) sender withData:(NSData*) data{
    NSDictionary *adData = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"Banner received!");
}
-(void) onBannerClosed:(GDAdDelegate*) sender{
    NSLog(@"Banner closed!");

}
-(void) onBannerFailedToLoad:(GDAdDelegate*) sender withData:(NSData*) data{
    NSDictionary *adData = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"Banner failed to load!");
}



@end
