//
//  AppDelegate.m
//  TalkEnglish
//
//  Created by Xander Addison on 11/22/17.
//  Copyright © 2017 X. All rights reserved.
//

#import "AppDelegate.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "AVFoundation/AVAudioRecorder.h"
#import "AVFoundation/AVAudioSession.h"
#import "GAnalytics.h"
#import "GDBManager.h"
#import "GLessonItem.h"
#import "GLevelItem.h"
#import "GQuizItem.h"
#import "GEnv.h"

#import "GInAppPurchaseController.h"
#import "InAppPurchaseController.h"
#import "GSharedPref.h"
#import "GAdsTimeCounter.h"

#import "PAnalytics.h"
#import "PDBManager.h"
#import "PTrackItem.h"
#import "PConstant.h"
#import "PPurchaseInfo.h"

#import "MainViewController.h"

@import GoogleMobileAds;

@interface AppDelegate ()

//@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation AppDelegate

+ (AppDelegate *)shared {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

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
    // Override point for customization after application launch.
    [GAnalytics init];
    
    BOOL isLoggedin = [[NSUserDefaults standardUserDefaults] boolForKey:@"loginKey"];
    if (isLoggedin) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainViewController* mainVC = (MainViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
        _window.rootViewController = nav;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successInAppPurchase:) name:IAPHelperProductPurchasedNotification object:nil];
    
    [self loadData];
    
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetoothA2DP
                        error:&err];
    if(err){
        NSLog(@"audioSession: %@ %lu %@", [err domain], (long)[err code], [[err userInfo] description]);
    }
    err = nil;
    [audioSession setActive:YES error:&err];
    if(err){
        NSLog(@"audioSession: %@ %lu %@", [err domain], (long)[err code], [[err userInfo] description]);
    }
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successInAppPurchase:) name:IAPHelperProductPurchasedNotification object:nil];
//    [PAnalytics init];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"FirstRun"] == 0) {
        [self copyFirstAlbum];
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"FirstRun"];
    }
    
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString* targetPath = [documentsDirectory stringByAppendingPathComponent:@"record"];
    NSError *error;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:targetPath
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
    
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    NSError *err = nil;
    [audioSession setActive:NO error:&err];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetoothA2DP error:&err];
    [audioSession setActive:YES error:&err];
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        
    }];
    return YES;
}

- (void) copyFirstAlbum {
    NSMutableArray* trackList = [PDBManager loadTrackList:1 nGenderMode:0];
    for (int i = 0; i < trackList.count; i++) {
        PTrackItem* item = trackList[i];
        if ([PConstant checkExistFile:item.strAudioNormal] == NO) {
            [self copyFile:item.strAudioNormal];
        }
        if ([PConstant checkExistFile:item.strAudioSlow] == NO) {
            [self copyFile:item.strAudioSlow];
        }
        if ([PConstant checkExistFile:item.strAudioVerySlow] == NO) {
            [self copyFile:item.strAudioVerySlow];
        }
    }
    [[PPurchaseInfo sharedInfo] setDownloadAlbum:1 on:1];
}

- (void) copyFile:(NSString*)strFileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:strFileName];
    
    if ([fileManager fileExistsAtPath:txtPath] == NO) {
        NSString* filename = [[strFileName lastPathComponent] stringByDeletingPathExtension];
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"mp3"];
        [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:strFileName];
    
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
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
