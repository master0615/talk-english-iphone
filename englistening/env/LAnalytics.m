//
//  LAnalytics.m
//  TalkEnglish
//
//  Created by YYYH on 2014. 12. 26..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "LAnalytics.h"
#import "LEnv.h"
@import Firebase;

@implementation LAnalytics

+ (void)init {
    [FIRApp configure];
}

+ (void)sendScreenName:(NSString*)screenName {
    
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
