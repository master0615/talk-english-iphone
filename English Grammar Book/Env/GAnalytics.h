//
//  GAnalytics.h
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseViewController;

@interface GAnalytics : NSObject

+ (void)init;
+ (void)sendScreenName:(NSString*)screenName;
+ (void)sendEvent:(NSString*)action
            label:(NSString*)label;

@end
