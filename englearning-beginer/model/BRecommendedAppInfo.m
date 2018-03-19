//
//  BRecommendedAppInfo.m
//  englistening
//
//  Created by alex on 6/8/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BRecommendedAppInfo.h"
#import "BEnv.h"

@implementation BRecommendedAppInfo
+ (NSArray*) recommendedApps {
    BRecommendedAppInfo* app1 = [[BRecommendedAppInfo alloc] init];
    BRecommendedAppInfo* app2 = [[BRecommendedAppInfo alloc] init];
    BRecommendedAppInfo* app3 = [[BRecommendedAppInfo alloc] init];
    BRecommendedAppInfo* app4 = [[BRecommendedAppInfo alloc] init];
    BRecommendedAppInfo* app5 = [[BRecommendedAppInfo alloc] init];
    BRecommendedAppInfo* app6 = [[BRecommendedAppInfo alloc] init];
    BRecommendedAppInfo* app7 = [[BRecommendedAppInfo alloc] init];
    BRecommendedAppInfo* app8 = [[BRecommendedAppInfo alloc] init];
    
    app1.appLogo = @"recommend_app1";
    app1.appTitle = @"Learn to Speak English";
    app1.appDescription = @"Over 800 lessons and 8000 audio files.  All completely free!";
    app1.appId = [BEnv currentTalkEnglishApp];
    
    app2.appLogo = @"recommend_app2";
    app2.appTitle = @"English Conversation";
    app2.appDescription = @"Great English conversation practice.  Excellent for speaking practice.";
    app2.appId = [BEnv currentEnglishConvApp];

    app3.appLogo = @"recommend_app3";
    app3.appTitle = @"English Vocabulary";
    app3.appDescription = @"Learn how to use words in sentences. Learn how to remember words. Over 40,000 audio files.";
    app3.appId = [BEnv currentEnglishVocabApp];
    
    app4.appLogo = @"recommend_app4";
    app4.appTitle = @"English Listening";
    app4.appDescription = @"Improve your English listening with great lessons and fun quizzes.";
    app4.appId = [BEnv currentEnglishListeningApp];
    
    app5.appLogo = @"recommend_app5";
    app5.appTitle = @"English Listening Player";
    app5.appDescription = @"Listen to English conversations and English lessons.  Create playlists and listen for hours without clicking on sentences.";
    app5.appId = [BEnv currentEnglishPlayerApp];
    
    app6.appLogo = @"recommend_app6";
    app6.appTitle = @"Learn English for Kids";
    app6.appDescription = @"POPULAR: The best way to learn English using an app. Thousands of pictures and audio files to help your child learn English";
    app6.appId = [BEnv currentEnglishKidsApp];
    
    app7.appLogo = @"recommend_app7";
    app7.appTitle = @"English Grammar Book";
    app7.appDescription = @"Learn the structure of English with this English grammar app. Very simple and fun with over 130 grammar lessons.";
    app7.appId = [BEnv currentEnglishGrammarApp];
    
    app8.appLogo = @"recommend_app8";
    app8.appTitle = @"English Speaking Practice";
    app8.appDescription = @"Practice your English speaking using beginner level conversations (includes basic business conversations too).";
    app8.appId = [BEnv currentEnglishPracticeApp];
    
    return [[NSArray alloc] initWithObjects: app1, app2, app3, app4, app5, app6, app7, app8, nil];
    
}
@end
