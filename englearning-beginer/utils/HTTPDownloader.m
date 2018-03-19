//
//  HTTPDownloader.m
//  TalkEnglish
//
//  Created on 2014. 12. 21..
//  Copyright © 2014 David. All rights reserved.
//

#import "HTTPDownloader.h"

@interface HTTPDownloader ()
{
    DownloadProgressBlock _progressBlock;
    DownloadCompletionBlock _completionBlock;
    
    NSURLConnection *_connection;
    NSFileHandle *_file;
    uint64_t _totalSize;
    uint64_t _downloadedSize;
    NSDictionary *_responseHeaders;
    BOOL _canceled;
}
@end

@implementation HTTPDownloader

- (id)initWithUrl:(NSURL*)url targetPath:(NSString*)targetPath userAgent:(NSString*)userAgent {
    if(self = [super init]) {
        _targetPath = targetPath;
        _url = url;
        _userAgent = userAgent;
        _file = nil;
        _connection = nil;
        _canceled = NO;
    }
    
    return self;
}

-(void)dealloc {
    if(_connection != nil) {
        [_connection cancel];
    }
}

- (void)close {
    _canceled = YES;
    if(_connection != nil) {
        [_connection cancel];
        _connection = nil;
    }
    if(_file != nil) {
        [_file closeFile];
        _file = nil;
    }
    
    if(_targetPath != nil) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath: _targetPath]) {
            NSError *error;
            [fileManager removeItemAtPath:_targetPath error:&error];
        }
    }
}

- (void)completion:(BOOL) success
             total:(int64_t) total
        downloaded:(int64_t) downloaded {
    if(_completionBlock != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _completionBlock(success, total, downloaded);
        });
    }
}

- (BOOL)startWithProgressBlock:(DownloadProgressBlock) progressBlock
               completionBlock:(DownloadCompletionBlock) completionBlock {
    if(_canceled) return NO;
    
    _progressBlock = progressBlock;
    _completionBlock = completionBlock;
    
    //NSLog(@"%@\n", urlString);
    
    if(_targetPath != nil) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath: _targetPath]) {
            NSError *error;
            [fileManager removeItemAtPath:_targetPath error:&error];
        }
        [[NSFileManager defaultManager] createFileAtPath: _targetPath
                                                contents: nil
                                              attributes: nil];
        
        [[NSURL fileURLWithPath:_targetPath] setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
        
        _file = [NSFileHandle fileHandleForWritingAtPath: _targetPath];
        if(_file == nil) {
            [self completion:NO total: 0 downloaded: 0];
            return NO;
        }
    }
    
    NSMutableURLRequest *req =[NSMutableURLRequest requestWithURL: _url
                                                      cachePolicy: NSURLRequestReloadIgnoringCacheData
                                                  timeoutInterval: 10.0];
    [req setHTTPMethod: @"GET"];
    [req setValue:@"plain" forHTTPHeaderField:@"Accept-Encoding"];
    if(_userAgent != nil) {
        [req setValue: _userAgent forHTTPHeaderField:@"User-Agent"];
    }
    
    //NSLog(@"[GXNetHttpDownloader] Start download\n");
    dispatch_async(dispatch_get_main_queue(), ^{
        _connection = [[NSURLConnection alloc] initWithRequest:req delegate: self];
        if(_connection == nil) {
            NSLog(@"[HttpDownloader] connection create failed\n");
            [self completion:NO total: 0 downloaded: 0];
        }
    });
    
    return YES;
}

- (void) cancel {
    [self close];
    [self completion:NO total: (int64_t)_totalSize downloaded: (int64_t)_downloadedSize];
    
}

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"did recv %@, %@", conn, response);
    if(_canceled || _connection != conn) return;
    
    if([response isKindOfClass: NSHTTPURLResponse.class]) {
        NSHTTPURLResponse *res = (NSHTTPURLResponse*)response;
        
        if(res.statusCode != 200) {
            [self close];
            [self completion:NO total: 0 downloaded: 0];
            return;
        }
    }
    
    _downloadedSize = 0;
    
    _totalSize = [response expectedContentLength];
    if(_progressBlock != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _progressBlock(_totalSize, _downloadedSize);
        });
    }
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data {
    if(_canceled || _connection != conn) return;
    
    if(_file != nil) {
        [_file seekToEndOfFile];
        [_file writeData: data];
    }
    
    _downloadedSize += data.length;
    
    if(_progressBlock != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _progressBlock(_totalSize, _downloadedSize);
        });
    }
}

- (void)connection:(NSURLConnection *)conn
  didFailWithError:(NSError *)error {
    [self close];
    [self completion:NO total: _totalSize downloaded: _downloadedSize];
    
    // inform the user
    NSLog(@"[HttpDownloader] Connection failed! Error - %@ %@",
          [error localizedDescription],
          [error userInfo][NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    if(_canceled || _connection != conn) return;
    
    _connection = nil;
    if(_file != nil) {
        [_file closeFile];
        _file = nil;
    }
    
    [self completion:YES total: _totalSize downloaded: _downloadedSize];
    
    //NSLog(@"[GXNetHttpDownloader] Complete download: %@ %llu bytes\n", _urlString, _totalSize);
    
}


@end
