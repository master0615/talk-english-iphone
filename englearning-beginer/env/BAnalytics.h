//
//  BAnalytics.h
//  TalkEnglish
//
//  Created by YYYH on 2014. 12. 26..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBaseViewController;

@interface BAnalytics : NSObject

+ (void)init;
+ (void)sendScreenName:(NSString*)screenName;
+ (void)sendEvent:(NSString*)action
            label:(NSString*)label;

@end
