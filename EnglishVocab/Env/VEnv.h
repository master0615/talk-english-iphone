//
//  VEnv.h
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VEnv : NSObject

+ (NSString*)adMobIdForBanner;
+ (NSString*)adMobIdForInterstitial;
+ (NSString*)analyticsTrackingId;
+ (NSString*)currentAppId;
+ (NSString*)currentTalkEnglishApp;
+ (NSString*)currentEnglishConvApp;
+ (NSString*)currentEnglishListeningApp;
+ (NSString*)currentEnglishGrammarApp;
+ (NSString*)currentEnglishPlayerApp;
+ (NSString*)currentEnglishBeginnerApp;
+ (NSString*)currentEnglishKidsApp;
+ (NSString*)currentEnglishPracticeApp;

@end
