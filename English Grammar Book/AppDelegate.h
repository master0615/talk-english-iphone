//
//  AppDelegate.h
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCommonViewController.h"

@protocol AdsDismissDelegate <NSObject>
- (void) adsDismissed;
@end

#define APPDELEGATE     ((AppDelegate*)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) id<AdsDismissDelegate> delegate;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GCommonViewController *showingAdsViewController;

//- (BOOL) showGADInterstitialWithViewController:(CommonViewController *)controller;

- (void) loadAd;
- (BOOL) isNull_InterstitialAd;
- (BOOL) isReady_InterstitialAd;
- (void) showInterstitialAd: (UIViewController*) rootVC;

@end

