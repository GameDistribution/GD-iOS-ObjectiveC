//
//  ViewController.h
//  GDApiSample
//
//  Created by Emre Demir on 06/01/17.
//  Copyright © 2017 Vooxe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *intApiBtn;
@property (weak, nonatomic) IBOutlet UIButton *reqBannerBtn;
@property (weak, nonatomic) IBOutlet UIButton *reqInterstitialBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBannerBtn;

- (IBAction)onReqBannerClicked:(id)sender;
- (IBAction)onReqInterstitialClicked:(id)sender;
- (IBAction)onInitClicked:(id)sender;
- (IBAction)onCloseClicked:(id)sender;

@end

