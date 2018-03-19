//
//  BEnv.h
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 16..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BEnv : NSObject

+ (NSString*)adMobIdForBanner;
+ (NSString*)adMobIdForInterstitial;
+ (NSString*)analyticsTrackingId;
+ (NSString*)currentAppId;

+ (NSString*)currentEnglishVocabApp;
+ (NSString*)currentTalkEnglishApp;
+ (NSString*)currentEnglishListeningApp;
+ (NSString*)currentEnglishConvApp;
+ (NSString*)currentEnglishGrammarApp;
+ (NSString*)currentEnglishPlayerApp;
+ (NSString*)currentEnglishBeginnerApp;
+ (NSString*)currentEnglishKidsApp;
+ (NSString*)currentEnglishPracticeApp;

@end
