//
//  PAnalytics.m
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "PAnalytics.h"
#import "PEnv.h"
@import Firebase;

@implementation PAnalytics

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
