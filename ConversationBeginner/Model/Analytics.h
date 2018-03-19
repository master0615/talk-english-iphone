//
//  Analytics.h
//  TalkEnglish
//
//  Created by YYYH on 2014. 12. 26..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>

#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
//#import "GAITrackedViewController.h"
//#import "GAIDictionaryBuilder.h"
//#import "GAITracker.h"
//#import "GAI.h"
//#import "GAIFields.h"
#endif

@class BaseViewController;

@interface Analytics : NSObject

+ (void)init;
+ (void)sendScreenName:(NSString*)screenName;
+ (void)sendEvent:(NSString*)action
            label:(NSString*)label;

@end
