//
//  AppDelegate.m
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import "AppDelegate.h"

#import "GAnalytics.h"
#import "GDBManager.h"
#import "GLessonItem.h"
#import "GLevelItem.h"
#import "GQuizItem.h"
#import "GEnv.h"

#import "GInAppPurchaseController.h"
#import "GSharedPref.h"
#import "GAdsTimeCounter.h"

@import GoogleMobileAds;

@interface AppDelegate () <GADInterstitialDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation AppDelegate

- (void)successInAppPurchase:(NSNotification*)ntf
{
    NSString* productId = [ntf.userInfo objectForKey:IAPHelperProductPurchasedNotification];
    int isPurchased = [GSharedPref intForKey: @"isPurchased" default: 0];
    if (productId.length > 0) {
        if ([productId isEqualToString:kIAPItemRemoveAds]) {
            isPurchased |= 1;
            [GSharedPref setInt: isPurchased forKey: @"isPurchased"];
        } else if ([productId isEqualToString:kIAPItemDonate]) {
            isPurchased |= 2;
            [GSharedPref setInt: isPurchased forKey: @"isPurchased"];
        } else if ([productId isEqualToString:kIAPItemRemoveAdsAndDonate]) {
            isPurchased |= 4;
            [GSharedPref setInt: isPurchased forKey: @"isPurchased"];
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GAnalytics init];
    
    int isPurchased = [GSharedPref intForKey: @"isPurchased" default: 0];
    if ((isPurchased&0x5) == 0) {
        
//        [GADMobileAds configureWithApplicationID:[Env adMobIdForBanner]];
//        [self createAndLoadInterstitial];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successInAppPurchase:) name:IAPHelperProductPurchasedNotification object:nil];
    
    [self loadData];
    
    return YES;
}

-(void)loadData
{
    NSMutableArray *levelList = [GDBManager loadLevelList];
    if (levelList == nil) {
        return;
    }
    for (GLevelItem *levelItem in levelList) {
        NSMutableArray *lessonList = [GDBManager loadLevelList:levelItem.nLevel];
        
        int nScore = 0;
        double dblTotalMark = 0;
        for (GLessonItem *lesson in lessonList)
        {
            nScore += lesson.fMark;
            NSMutableArray *quizList = [GDBManager loadQuiz:lesson.nQuizId];
            
            int nTotalQuizScore = 0;
            int nQuiz1Score = 0;
            for(GQuizItem *quiz in quizList) {
                if (quiz.nQuizType1 != 0) {
                    if (quiz.nQuizType1 != 3) {
                        NSArray *splitAnswer = [quiz.strAnswer1 componentsSeparatedByString:@","];
                        if (splitAnswer != nil) {
                            nTotalQuizScore += [splitAnswer count];
                            nQuiz1Score += [splitAnswer count];
                        }
                    } else {
                        nTotalQuizScore++;
                        nQuiz1Score++;
                    }
                }
                
                if (quiz.nQuizType2 != 0) {
                    if (quiz.nQuizType2 != 3) {
                        NSArray *splitAnswer = [quiz.strAnswer2 componentsSeparatedByString:@","];
                        if (splitAnswer != nil) {
                            nTotalQuizScore += [splitAnswer count];
                        }
                    } else {
                        nTotalQuizScore++;
                    }
                }
            }
            dblTotalMark = dblTotalMark + nTotalQuizScore * lesson.fPointX;
            [GDBManager updateLessonTotalScore:lesson.nLevelOrder score:nTotalQuizScore * lesson.fPointX quiz1_score:nQuiz1Score * lesson.fPointX];
        }
        levelItem.nCompleted = nScore;
        levelItem.nTotal = (int)round(dblTotalMark);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (void)createAndLoadInterstitial
//{
//    self.interstitial =
//    [[GADInterstitial alloc] initWithAdUnitID:[Env adMobIdForInterstitial]];
//    self.interstitial.delegate = self;
//    
//    GADRequest *request = [GADRequest request];
//    // Request test ads on devices you specify. Your test device ID is printed to the console when
//    // an ad request is made.
//    request.testDevices = @[ kGADSimulatorID, @"2077ef9a63d2b398840261c8221a0c9b" ];
//    [self.interstitial loadRequest:request];
//}
//
//- (BOOL) showGADInterstitialWithViewController:(CommonViewController *)controller
//{
//    int isPurchased = [SharedPref intForKey: @"isPurchased" default: 0];
//    if ((isPurchased&0x5) != 0) {
//        return NO;
//    }
//    
//    if (self.interstitial.isReady) {
//        [self.interstitial presentFromRootViewController:controller];
//        self.showingAdsViewController = controller;
//        
//        return YES;
//    }
//    
//    return NO;
//}

#pragma mark - AdMob

- (BOOL) isNull_InterstitialAd {
    return (self.interstitial == nil);
}
- (BOOL) isReady_InterstitialAd {
    if (self.interstitial == nil) {
        return NO;
    }
    return [self.interstitial isReady];
}
- (void) showInterstitialAd: (UIViewController*) rootVC {
    [self.interstitial presentFromRootViewController: rootVC];
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self loadAd];
}

- (void) loadAd {
    self.interstitial.delegate = nil;
    
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:[GEnv adMobIdForInterstitial]];
    self.interstitial.delegate = self;
    
    GADRequest *request = [GADRequest request];
    
    [self.interstitial loadRequest:request];
    [GAdsTimeCounter setLastTimeLoadTried: [[NSDate date] timeIntervalSince1970]];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"Interstitial Ad Ready");
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    self.interstitial.delegate = nil;
    self.interstitial = nil;
}

#pragma mark Google ads interstitial delegate

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    
    self.interstitial.delegate = nil;
    self.interstitial = nil;
    
    [self loadAd];
    if (self.delegate != nil) {
        [self.delegate adsDismissed];
        self.delegate = nil;
    }
    NSLog(@"Interstitial Ad Dismiss");
}

@end
