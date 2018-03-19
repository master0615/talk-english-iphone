//
//  RecommendedAppInfo.m
//  englistening
//
//  Created by alex on 6/8/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "RecommendedAppInfo.h"
#import "LEnv.h"

@implementation RecommendedAppInfo
+ (NSArray*) recommendedApps {
    RecommendedAppInfo* app1 = [[RecommendedAppInfo alloc] init];
    RecommendedAppInfo* app2 = [[RecommendedAppInfo alloc] init];
    RecommendedAppInfo* app3 = [[RecommendedAppInfo alloc] init];
    RecommendedAppInfo* app4 = [[RecommendedAppInfo alloc] init];
    RecommendedAppInfo* app5 = [[RecommendedAppInfo alloc] init];
    RecommendedAppInfo* app6 = [[RecommendedAppInfo alloc] init];
    RecommendedAppInfo* app7 = [[RecommendedAppInfo alloc] init];
    RecommendedAppInfo* app8 = [[RecommendedAppInfo alloc] init];
    
    app1.appLogo = @"recommend_app1";
    app1.appTitle = @"Learn to Speak English";
    app1.appDescription = @"Over 800 lessons and 8000 audio files.  All completely free!";
    app1.appId = [LEnv currentTalkEnglishApp];
    
    app2.appLogo = @"recommend_app2";
    app2.appTitle = @"English Conversation";
    app2.appDescription = @"Great English conversation practice.  Excellent for speaking practice.";
    app2.appId = [LEnv currentEnglishConvApp];

    app3.appLogo = @"recommend_app3";
    app3.appTitle = @"English Vocabulary";
    app3.appDescription = @"Learn how to use words in sentences. Learn how to remember words. Over 40,000 audio files.";
    app3.appId = [LEnv currentEnglishVocabApp];

    app4.appLogo = @"recommend_app4";
    app4.appTitle = @"English Grammar Book";
    app4.appDescription = @"Learn the structure of English with this English grammar app. Very simple and fun with over 130 grammar lessons.";
    app4.appId = [LEnv currentEnglishGrammarApp];

    app5.appLogo = @"recommend_app5";
    app5.appTitle = @"English Listening Player";
    app5.appDescription = @"Listen to English conversations and English lessons.  Create playlists and listen for hours without clicking on sentences.";
    app5.appId = [LEnv currentEnglishListeningApp];
    
    app6.appLogo = @"recommend_app6";
    app6.appTitle = @"Basic English for Beginners";
    app6.appDescription = @"Learn English step by step. Great for beginners and completely FREE!";
    app6.appId = [LEnv currentEnglishBeginnerApp];
    
    app7.appLogo = @"recommend_app7";
    app7.appTitle = @"Learn English for Kids";
    app7.appDescription = @"POPULAR: The best way to learn English using an app. Thousands of pictures and audio files to help your child learn English";
    app7.appId = [LEnv currentEnglishKidsApp];

    app8.appLogo = @"recommend_app8";
    app8.appTitle = @"English Speaking Practice";
    app8.appDescription = @"Practice your English speaking using beginner level conversations (includes basic business conversations too).";
    app8.appId = [LEnv currentEnglishPracticeApp];

    return [[NSArray alloc] initWithObjects: app1, app2, app3, app4, app5, app6, app7, app8, nil];
    
}
@end
