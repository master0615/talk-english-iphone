//
//  Analytics.h
//  TalkEnglish
//
//  Created by Yoo Yong-Ha on 2014. 12. 26..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBaseViewController;

@interface SAnalytics : NSObject

+ (void)init;
+ (void)sendScreenName:(NSString*)screenName;
+ (void)sendEvent:(NSString*)action
            label:(NSString*)label;

@end
