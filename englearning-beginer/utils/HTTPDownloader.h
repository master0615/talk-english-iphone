//
//  HTTPDownloader.h
//  TalkEnglish
//
//  Created on 2014. 12. 21..
//  Copyright © 2014 David. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WEBSERVICE_URL @"http://www.skesl.com"

#define INSTRUCTION_VIDEO_URL  WEBSERVICE_URL @"/apps/chobo/video/instruction.mp4"
#define INSTRUCTION_VIDEO_NAME  @"instruction.mp4"
#define AUDIO_URL WEBSERVICE_URL @"/apps/chobo/audio/"

typedef void (^DownloadProgressBlock)(int64_t totalSize, int64_t downloadedSize);
typedef void (^DownloadCompletionBlock)(BOOL success, int64_t totalSize, int64_t downloadedSize);


@interface HTTPDownloader : NSObject

@property (readonly) NSURL *url;
@property (readonly) NSString *targetPath;
@property (readonly) NSString *userAgent;

- (id)initWithUrl: (NSURL*) url targetPath: (NSString*) targetPath userAgent: (NSString*)userAgent;

- (BOOL) startWithProgressBlock: (DownloadProgressBlock) progressBlock
                completionBlock: (DownloadCompletionBlock) completionBlock;
- (void) cancel;

@end
