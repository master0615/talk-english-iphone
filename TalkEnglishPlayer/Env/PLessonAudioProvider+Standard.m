//
//  LessonAudioProvider+Offline.m
//  TalkEnglish
//
//  Created by Yoo Yong-Ha on 2014. 12. 19..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "PLessonAudioProvider+Standard.h"
#import "PFileUtils.h"
#import "PConstant.h"
static NSString *kURLPrefix = @"http://www.skesl.com/apps/listenlong/audio/";

@implementation PLessonAudioProvider (Standard)

- (void)prepare:(NSString*)filename
   withDelegate:(id<PLessonAudioPrepareDelegate>)delegate {
    if(self.queue == NULL) {
        self.queue = dispatch_queue_create("com.talkenglish", DISPATCH_QUEUE_SERIAL);
    }
    
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString* strPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, filename];
    
    if ([PConstant checkExistFile:filename]) {
        [delegate lessonAudio:filename didPrepare:[NSURL fileURLWithPath:strPath]];
        return;
    }
    
    dispatch_async(self.queue, ^{
        if(self.downloader != nil && [self.downloader.targetPath isEqualToString:strPath]) {
            return;
        }
        else if(_strCurrentFileName != nil && [_strCurrentFileName isEqualToString:filename]  && [PFileUtils fileExistsAtPath:strPath]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate lessonAudio:filename didPrepare:[NSURL fileURLWithPath:strPath]];
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
            PHTTPDownloader *downloader = [[PHTTPDownloader alloc] initWithUrl:url
                                                                  targetPath:strPath
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
                     _strCurrentFileName = filename;
                     [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:filename];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     [delegate lessonAudio:filename didPrepare:[NSURL fileURLWithPath:strPath]];
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
    if (self.queue != nil){
        dispatch_async(self.queue, ^{
            if(self.downloader != nil) {
                [self.downloader cancel];
                self.downloader = nil;
            }
        });
    }
}


@end
