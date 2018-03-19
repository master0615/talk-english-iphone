//
//  LessonAudioProvider.h
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHTTPDownloader.h"

@protocol VLessonAudioPrepareDelegate <NSObject>

- (void)lessonAudio:(NSString*)filename
         didPrepare:(NSURL*)url;
- (void)lessonAudio:(NSString*)filename
        didDownload:(float)progress;
- (void)lessonAudio:(NSString*)filename
            didFail:(NSString*)message;
@end



@interface VLessonAudioProvider : NSObject
{
    NSString* _strCurrentFileName;
}
@property dispatch_queue_t queue;
@property VHTTPDownloader *downloader;

+ (VLessonAudioProvider*)provider;

@end
