//
//  LessonAudioProvider+Offline.h
//  TalkEnglish
//
//  Created by Yoo Yong-Ha on 2014. 12. 19..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLessonAudioProvider.h"

@interface SLessonAudioProvider (Standard)


- (void)prepare:(NSString*)filename
   withDelegate:(id<SLessonAudioPrepareDelegate>)delegate;

- (void)cancel;


@end
