//
//  VHTTPDownloader.h
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DownloadProgressBlock)(int64_t totalSize, int64_t downloadedSize);
typedef void (^DownloadCompletionBlock)(BOOL success, int64_t totalSize, int64_t downloadedSize);


@interface VHTTPDownloader : NSObject

@property (readonly) NSURL *url;
@property (readonly) NSString *targetPath;
@property (readonly) NSString *userAgent;

- (id)initWithUrl: (NSURL*) url targetPath: (NSString*) targetPath userAgent: (NSString*)userAgent;

- (BOOL) startWithProgressBlock: (DownloadProgressBlock) progressBlock
                completionBlock: (DownloadCompletionBlock) completionBlock;
- (void) cancel;

@end
