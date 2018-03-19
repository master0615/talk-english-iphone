//
//  LessonAudioProvider+Offline.m
//  TalkEnglish
//
//  Created by Yoo Yong-Ha on 2014. 12. 19..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "VLessonAudioProvider+Standard.h"
#import "VFileUtils.h"

//static NSString *kURLPrefix = @"http://www.englishcollocation.com";
static NSString *kURLPrefix = @"http://www.skesl.com/apps/vocab";


@implementation VLessonAudioProvider (Standard)

- (void)prepare:(NSString*)filename
   withDelegate:(id<VLessonAudioPrepareDelegate>)delegate {
    if(self.queue == NULL) {
        self.queue = dispatch_queue_create("com.talkenglish", DISPATCH_QUEUE_SERIAL);
    }
    
    NSString* strFileName = [filename lastPathComponent];
    NSString* strPath = [filename stringByDeletingLastPathComponent];
    strPath = [strPath stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    NSString* strKey = [NSString stringWithFormat:@"%@%@", strPath, strFileName];
    strKey = [strKey stringByReplacingOccurrencesOfString:@"/" withString:@""];
    strKey = [strKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    strPath = [NSString stringWithFormat:@"%@/%@/%@", documentsDirectory, strPath, strFileName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:strPath];
    NSInteger nExisted = [[NSUserDefaults standardUserDefaults] integerForKey:strKey];
    if (fileExists && (nExisted == 1)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate lessonAudio:filename didPrepare:[NSURL fileURLWithPath:strPath]];
        });
        return;
    }
    
    dispatch_async(self.queue, ^{
        NSString *targetPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"lesson_temp.mp3"];//[filename lastPathComponent]
        if(self.downloader != nil && [self.downloader.targetPath isEqualToString:targetPath]) {
            return;
        }
        else if(_strCurrentFileName != nil && [_strCurrentFileName isEqualToString:filename]  && [VFileUtils fileExistsAtPath:targetPath]) {
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
            VHTTPDownloader *downloader = [[VHTTPDownloader alloc] initWithUrl:url
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
                     _strCurrentFileName = filename;
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
