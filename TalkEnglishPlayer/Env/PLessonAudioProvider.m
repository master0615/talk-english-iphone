//
//  LessonAudioProvider.m
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "PLessonAudioProvider.h"


@implementation PLessonAudioProvider

static PLessonAudioProvider* _instance = nil;

+ (PLessonAudioProvider*)provider
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[PLessonAudioProvider alloc] init];
    });
    
    return _instance;
}


@end
