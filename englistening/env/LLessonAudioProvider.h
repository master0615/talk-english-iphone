//
//  LessonAudioProvider.h
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHTTPDownloader.h"

@protocol LessonAudioPrepareDelegate <NSObject>

- (void)lessonAudio:(NSString*)filename
         didPrepare:(NSURL*)url;
- (void)lessonAudio:(NSString*)filename
        didDownload:(float)progress;
- (void)lessonAudio:(NSString*)filename
            didFail:(NSString*)message;
@end


@interface LLessonAudioProvider : NSObject
{
}
@property dispatch_queue_t queue;
@property NSMutableArray* downloaders;
@property NSMutableDictionary* delegates;

+ (LLessonAudioProvider*)provider;

@end
