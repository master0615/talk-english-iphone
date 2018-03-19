//
//  Env.m
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 16..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SEnv.h"

@implementation SEnv

+ (NSString*)adMobIdForBanner {
    //return @"ca-app-pub-3940256099942544/2934735716"; // For Test
    return @"ca-app-pub-9184026071571490/8323492996";
}

+ (NSString*)adMobIdForInterstitial {
    //return @"ca-app-pub-3940256099942544/4411468910"; // For Test
    return @"ca-app-pub-9184026071571490/9800226191";
}

+ (NSString*)analyticsTrackingId {
    return @"UA-57953802-5";
}

+ (NSString*)currentEnglishVocabApp {
    return @"1111189019";
}

+ (NSString*)currentTalkEnglishApp {
    return @"955106394";
}

+ (NSString*)currentEnglishListeningApp {
    return @"1123439201";
}

+ (NSString*)currentEnglishConvApp {
    return @"1111165116";
}

+ (NSString*)currentEnglishGrammarApp {
    return @"1166588245";
}

+ (NSString*)currentEnglishPlayerApp {
    return @"1148397000";
}

+ (NSString*)currentEnglishBeginnerApp {
    return @"1178452669";
}

+ (NSString*)currentEnglishKidsApp {
    return @"1154885644";
}

+ (NSString*)currentEnglishPracticeApp {
    return @"1238639729";
}

+ (void)openItunesLink {
#if PRODUCT_TYPE == PRODUCT_TYPE_OFFLINE
    NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id602910688"];
    [[UIApplication sharedApplication] openURL:url];
#else
    NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id602910688"];
    [[UIApplication sharedApplication] openURL:url];
#endif
}

+ (void)openItunesOfflinleVersionLink {
    NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id602910688"];
    [[UIApplication sharedApplication] openURL:url];
}


@end
