//
//  Analytics.m
//  TalkEnglish
//
//  Created by Yoo Yong-Ha on 2014. 12. 26..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SAnalytics.h"
#import "SEnv.h"
//@import Firebase;

@implementation SAnalytics

+ (void)init {
//    [FIRApp configure];
}

+ (void)sendScreenName:(NSString*)screenName {
    
//    [FIRAnalytics setScreenName:screenName screenClass:nil];
}


+ (void)sendEvent:(NSString*)action
            label:(NSString*)label {
//    [FIRAnalytics logEventWithName:action
//                        parameters:@{
//                                     @"Action": label
//                                     }];
    
}

@end
