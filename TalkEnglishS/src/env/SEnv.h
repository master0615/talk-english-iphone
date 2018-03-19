//
//  Env.h
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 16..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEnv : NSObject

+ (NSString*)adMobIdForBanner;
+ (NSString*)adMobIdForInterstitial;
+ (NSString*)analyticsTrackingId;
+ (void)openItunesLink;
+ (void)openItunesOfflinleVersionLink;

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
