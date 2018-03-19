//
//  LessonAudioProvider.m
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "LLessonAudioProvider.h"


@implementation LLessonAudioProvider

static LLessonAudioProvider* _instance = nil;

+ (LLessonAudioProvider*)provider
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[LLessonAudioProvider alloc] init];
    });
    
    return _instance;
}


@end
