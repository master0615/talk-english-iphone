//
//  LessonAudioProvider.m
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "VLessonAudioProvider.h"


@implementation VLessonAudioProvider

static VLessonAudioProvider* _instance = nil;

+ (VLessonAudioProvider*)provider
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[VLessonAudioProvider alloc] init];
    });
    
    return _instance;
}


@end
