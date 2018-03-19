//
//  LessonAudioProvider.h
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHTTPDownloader.h"

@protocol PLessonAudioPrepareDelegate <NSObject>

- (void)lessonAudio:(NSString*)filename
         didPrepare:(NSURL*)url;
- (void)lessonAudio:(NSString*)filename
        didDownload:(float)progress;
- (void)lessonAudio:(NSString*)filename
            didFail:(NSString*)message;
@end



@interface PLessonAudioProvider : NSObject
{
    NSString* _strCurrentFileName;
}
@property dispatch_queue_t queue;
@property PHTTPDownloader *downloader;

+ (PLessonAudioProvider*)provider;

@end
