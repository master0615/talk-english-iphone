//
//  LessonAudioProvider+Offline.m
//  TalkEnglish
//
//  Created by Yoo Yong-Ha on 2014. 12. 19..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "LessonAudioProvider+Standard.h"
#import "LFileUtils.h"

static NSString *kURLPrefix = @"http://www.skesl.com/apps/listening/audio/";

@implementation LLessonAudioProvider (Standard)

- (LHTTPDownloader*) getDownloaderByFilename: (NSString*) filename {
    if (self.downloaders == nil) {
        return nil;
    }
    NSString *targetPath = [NSTemporaryDirectory() stringByAppendingPathComponent: filename];
    for (LHTTPDownloader* downloader in self.downloaders) {
        if ([downloader.targetPath isEqualToString: targetPath]) {
            return downloader;
        }
    }
    return nil;
}
- (void) deleteLessonAudioFile: (NSString*) filename {
    NSString *targetPath = [NSTemporaryDirectory() stringByAppendingPathComponent: filename];
    if ([LFileUtils fileExistsAtPath: targetPath]) {
        [LFileUtils removeFile: targetPath];
    }
}
- (NSURL*) lessonAudioUrlByFilename: (NSString*) filename {
    NSString *targetPath = [NSTemporaryDirectory() stringByAppendingPathComponent: filename];
    if ([LFileUtils fileExistsAtPath: targetPath]) {
        return [NSURL fileURLWithPath: targetPath];
    }
    return nil;
}
- (void)prepare:(NSString*)filename
   withDelegate:(id<LessonAudioPrepareDelegate>)delegate {
    if(self.queue == NULL) {
        self.queue = dispatch_queue_create("com.talkenglish.listening", DISPATCH_QUEUE_SERIAL);
    }
    
    dispatch_async(self.queue, ^{
        LHTTPDownloader* downloader = [self getDownloaderByFilename: filename];
        if (downloader != nil) {
            
            if (self.delegates == nil) {
                self.delegates = [[NSMutableDictionary alloc] init];
            }
            [self.delegates setObject: delegate forKey: downloader.targetPath];
            
            return;
        }
        NSString *targetPath = [NSTemporaryDirectory() stringByAppendingPathComponent: filename];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kURLPrefix, filename]];
        NSString *userAgent = [NSString stringWithFormat:@"TalkEnglish %@ for iOS",
                               [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        downloader = [[LHTTPDownloader alloc] initWithUrl: url
                                              targetPath: targetPath
                                               userAgent: userAgent];
        [self.downloaders addObject: downloader];
        if (self.delegates == nil) {
            self.delegates = [[NSMutableDictionary alloc] init];
        }
        if (delegate != nil) {
            [self.delegates setObject: delegate forKey: downloader.targetPath];
        }
        [downloader startWithProgressBlock:
         ^(int64_t totalSize, int64_t downloadedSize) {
             id<LessonAudioPrepareDelegate> delegate0 = [self.delegates objectForKey: downloader.targetPath];
             if (delegate0 != nil) {
                 [delegate0 lessonAudio: filename didDownload: (double)downloadedSize / (double)totalSize];
             }
         }
                           completionBlock:
         ^(BOOL success, int64_t totalSize, int64_t downloadedSize) {
             id<LessonAudioPrepareDelegate> delegate0 = [self.delegates objectForKey: downloader.targetPath];
             
             if(success) {
                 if (delegate0 != nil) {
                     [delegate0 lessonAudio: filename didPrepare: [NSURL fileURLWithPath: targetPath]];
                 }
             }
             else {
                 if (delegate0 != nil) {
                     [delegate0 lessonAudio: filename didFail:@"failed"];
                 }
             }
             
             [self.delegates removeObjectForKey: downloader.targetPath];
             [self.downloaders removeObject: downloader];
             LHTTPDownloader* downloader0 = [self getDownloaderByFilename: filename];
             if (downloader0 != nil) {
                 [self.downloaders removeObject: downloader0];
             }
         }];
    });
}

- (void)cancel: (NSString*) filename {
    if (self.queue != nil){
        dispatch_async(self.queue, ^{
            if(self.downloaders != nil) {
                LHTTPDownloader* downloader = [self getDownloaderByFilename: filename];
                if (downloader != nil) {
                    id<LessonAudioPrepareDelegate> delegate0 = [self.delegates objectForKey: downloader.targetPath];
                    if (delegate0 != nil) {
                        [self.delegates removeObjectForKey: downloader.targetPath];
                    }
                    [downloader cancel];
                    [self.downloaders removeObject: downloader];
                }
            }
        });
    }
}


@end
