//
//  RecommendedAppInfo.h
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import "GRecommendedAppInfo.h"
#import "GEnv.h"

@implementation GRecommendedAppInfo
+ (NSArray*) recommendedApps {
    GRecommendedAppInfo* app1 = [[GRecommendedAppInfo alloc] init];
    GRecommendedAppInfo* app2 = [[GRecommendedAppInfo alloc] init];
    GRecommendedAppInfo* app3 = [[GRecommendedAppInfo alloc] init];
    GRecommendedAppInfo* app4 = [[GRecommendedAppInfo alloc] init];
    GRecommendedAppInfo* app5 = [[GRecommendedAppInfo alloc] init];
    GRecommendedAppInfo* app6 = [[GRecommendedAppInfo alloc] init];
    GRecommendedAppInfo* app7 = [[GRecommendedAppInfo alloc] init];
    GRecommendedAppInfo* app8 = [[GRecommendedAppInfo alloc] init];

    app1.appLogo = @"recommend_app1";
    app1.appTitle = @"Learn to Speak English";
    app1.appDescription = @"Over 800 lessons and 8000 audio files.  All completely free!";
    app1.appId = [GEnv currentTalkEnglishApp];
    
    app2.appLogo = @"recommend_app2";
    app2.appTitle = @"English Conversation";
    app2.appDescription = @"Great English conversation practice.  Excellent for speaking practice.";
    app2.appId = [GEnv currentEnglishConvApp];

    app3.appLogo = @"recommend_app3";
    app3.appTitle = @"English Vocabulary";
    app3.appDescription = @"Learn how to use words in sentences. Learn how to remember words. Over 40,000 audio files.";
    app3.appId = [GEnv currentEnglishVocabApp];
    
    app4.appLogo = @"recommend_app4";
    app4.appTitle = @"English Listening";
    app4.appDescription = @"Highly rated and very popular!  Improve your English listening with this amazing FREE app.";
    app4.appId = [GEnv currentEnglishListeningApp];
    
    app5.appLogo = @"recommend_app5";
    app5.appTitle = @"English Listening Player";
    app5.appDescription = @"Listen to English conversations and English lessons.  Create playlists and listen for hours without clicking on sentences.";
    app5.appId = [GEnv currentEnglishPlayerApp];

    app6.appLogo = @"recommend_app6";
    app6.appTitle = @"Learn English for Kids";
    app6.appDescription = @"POPULAR: The best way to learn English using an app.  Thousands of pictures and audio files to help your child learn English.";
    app6.appId = [GEnv currentEnglishKidsApp];

    app7.appLogo = @"recommend_app7";
    app7.appTitle = @"Basic English for Beginners";
    app7.appDescription = @"Learn English step by step. Great for beginners and completely FREE!";
    app7.appId = [GEnv currentEnglishBeginnerApp];

    app8.appLogo = @"recommend_app8";
    app8.appTitle = @"English Speaking Practice";
    app8.appDescription = @"Practice your English speaking using beginner level conversations (includes basic business conversations too).";
    app8.appId = [GEnv currentEnglishPracticeApp];
    
    return [[NSArray alloc] initWithObjects: app1, app2, app3, app4, app5, app6, app7, app8, nil];
    
}
@end
