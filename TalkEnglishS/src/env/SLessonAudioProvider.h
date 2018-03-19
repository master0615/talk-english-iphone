//
//  LessonAudioProvider.h
//  TalkEnglish
//
//  Created by Yoo Yong-Ha on 2014. 12. 19..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPDownloader.h"

@protocol SLessonAudioPrepareDelegate <NSObject>

- (void)lessonAudio:(NSString*)filename
         didPrepare:(NSURL*)url;
- (void)lessonAudio:(NSString*)filename
        didDownload:(float)progress;
- (void)lessonAudio:(NSString*)filename
            didFail:(NSString*)message;
@end



@interface SLessonAudioProvider : NSObject

@property dispatch_queue_t queue;
@property HTTPDownloader *downloader;

+ (SLessonAudioProvider*)provider;

@end
