//
//  LessonAudioProvider.m
//  TalkEnglish
//
//  Created by Yoo Yong-Ha on 2014. 12. 19..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SLessonAudioProvider.h"


@implementation SLessonAudioProvider

static SLessonAudioProvider* _instance = nil;

+ (SLessonAudioProvider*)provider
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[SLessonAudioProvider alloc] init];
    });
    
    return _instance;
}


@end
