//
//  Analytics.m
//  TalkEnglish
//
//  Created by YYYH on 2014. 12. 26..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "Analytics.h"
#import "Env.h"
@import Firebase;

@implementation Analytics

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
