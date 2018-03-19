//
//  LessonAudioProvider+Offline.m
//  TalkEnglish
//
//  Created by Yoo Yong-Ha on 2014. 12. 19..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SLessonAudioProvider+Standard.h"
#import "FileUtils.h"

static NSString *kURLPrefix = @"http://www.talkenglish.com/oidua/";

@implementation SLessonAudioProvider (Standard)

- (void)prepare:(NSString*)filename
   withDelegate:(id<SLessonAudioPrepareDelegate>)delegate {
    if(self.queue == NULL) {
        self.queue = dispatch_queue_create("com.talkenglish", DISPATCH_QUEUE_SERIAL);
    }
    
    dispatch_async(self.queue, ^{
        NSString *targetPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[filename lastPathComponent]];
        if(self.downloader != nil && [self.downloader.targetPath isEqualToString:targetPath]) {
            return;
        }
        else if([FileUtils fileExistsAtPath:targetPath]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate lessonAudio:filename didPrepare:[NSURL fileURLWithPath:targetPath]];
            });
        }
        else {
            if(self.downloader != nil) {
                [self.downloader cancel];
                self.downloader = nil;
            }
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kURLPrefix, filename]];
            NSString *userAgent = [NSString stringWithFormat:@"TalkEnglish %@ for iOS",
                                   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
            HTTPDownloader *downloader = [[HTTPDownloader alloc] initWithUrl:url
                                                                  targetPath:targetPath
                                                                   userAgent:userAgent];
            self.downloader = downloader;
            [downloader startWithProgressBlock:
             ^(int64_t totalSize, int64_t downloadedSize) {
                 if(downloader != self.downloader) return;
                 [delegate lessonAudio:filename didDownload:(double)downloadedSize / (double)totalSize];
             }
                                completionBlock:
             ^(BOOL success, int64_t totalSize, int64_t downloadedSize) {
                 if(downloader != self.downloader) return;
                 self.downloader = nil;
                 if(success) {
                     [delegate lessonAudio:filename didPrepare:[NSURL fileURLWithPath:targetPath]];
                 }
                 else {
                     [delegate lessonAudio:filename didFail:@"failed"];
                 }
             }
             ];
        }
    });
}

- (void)cancel {
    dispatch_async(self.queue, ^{
        if(self.downloader != nil) {
            [self.downloader cancel];
            self.downloader = nil;
        }
    });
}


@end
