//
//  LessonAudioProvider+Offline.h
//  TalkEnglish
//
//  Created by Yoo Yong-Ha on 2014. 12. 19..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLessonAudioProvider.h"

@interface LLessonAudioProvider (Standard)

- (LHTTPDownloader*) getDownloaderByFilename: (NSString*) filename;
- (NSURL*) lessonAudioUrlByFilename: (NSString*) filename;
- (void) deleteLessonAudioFile: (NSString*) filename;
- (void)prepare:(NSString*)filename
   withDelegate:(id<LessonAudioPrepareDelegate>)delegate;

- (void)cancel: (NSString*) filename;


@end
