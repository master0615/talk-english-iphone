//
//  BAnalytics.m
//  TalkEnglish
//
//  Created by YYYH on 2014. 12. 26..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "BAnalytics.h"
#import "BEnv.h"
@import Firebase;

@implementation BAnalytics

+ (void)init {
    
//    // Optional: automatically send uncaught exceptions to Google BAnalytics.
//    [GAI sharedInstance].trackUncaughtExceptions = YES;
//    
//    // Optional: set Google BAnalytics dispatch interval to e.g. 20 seconds.
//    [GAI sharedInstance].dispatchInterval = 20;
//    
//    // Optional: set Logger to VERBOSE for debug information.
//    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
//    
//    // Initialize tracker. Replace with your tracking ID.
//    [[GAI sharedInstance] trackerWithTrackingId:[BEnv analyticsTrackingId]];

    [FIRApp configure];
    
}

+ (void)sendScreenName:(NSString*)screenName {
//    id tracker = [[GAI sharedInstance] defaultTracker];
//    [tracker set:kGAIScreenName
//           value:screenName];
//    
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    [FIRAnalytics setScreenName:screenName screenClass:nil];

}


+ (void)sendEvent:(NSString*)action
            label:(NSString*)label {
    [FIRAnalytics logEventWithName:action
                        parameters:@{
                                     @"Action": label
                                     }];
}

@end
