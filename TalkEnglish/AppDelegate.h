//
//  AppDelegate.h
//  TalkEnglish
//
//  Created by Xander Addison on 11/22/17.
//  Copyright © 2017 X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCommonViewController.h"
#import "BAdsTimeCounter.h"

//@protocol AdsDismissDelegate <NSObject>
//- (void) adsDismissed;
//@end

#define APPDELEGATE     ((AppDelegate*)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GCommonViewController *showingAdsViewController;
@property (strong, nonatomic) UINavigationController *rootNavigationController;

//- (BOOL) showGADInterstitialWithViewController:(CommonViewController *)controller;

+ (AppDelegate *)shared;

@end
