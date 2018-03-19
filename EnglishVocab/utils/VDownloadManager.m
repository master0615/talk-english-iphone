//
//  DownloadManager.m
//  EnglishConversation
//
//  Created by SongJiang on 6/29/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VDownloadManager.h"
#import "VHTTPDownloader.h"

@implementation VDownloadManager

+ (VDownloadManager*)sharedInstance {
    static VDownloadManager *sDownloadManager = nil;
    if (sDownloadManager == nil) {
        sDownloadManager = [VDownloadManager new];
        [sDownloadManager initData];
        sDownloadManager.nStartedDownload = 0;
    }
    return sDownloadManager;
}
- (void) initData{
    _downloadBookArray = [[NSMutableArray alloc] init];
    _arrayAudioFileItem = nil;
}

- (void) startDownload{
    if (self.nStartedDownload == 0) {
        [self downloadBooks];
    }
}

- (void) downloadBooks{
    self.nStartedDownload = 1;
    if(_downloadBookArray.count > 0) {
        _nCurrentBook = [_downloadBookArray[0] integerValue];
        _arrayAudioFileItem = [VAudioFileItem getBookAudioFiles:_nCurrentBook];
        _nTotalCount = _arrayAudioFileItem.count;
        [self downloadOneBook:0];
        return;
    }
    self.nStartedDownload = 0;
    if (self.vc != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Add setUpdateOffline 2018-01-26 by GoldRabbit
            [self.vc setUpdateOffline:_nCurrentBook on:1];
            [self.vc updateUI];
            [self.vc hideProgressBar];
        });
    }
}

- (void) downloadOneBook:(NSInteger) index {
    if (index == 0) {
        self.nDownloadCount = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.vc showProgressBar];
        });
    }
    for (NSInteger i = index; i < _arrayAudioFileItem.count; i ++) {
        VAudioFileItem* item = _arrayAudioFileItem[i];
        
        if([self isExistFile:item]) {
            _nDownloadCount += 1;
            NSLog(@"download count %ld", _nDownloadCount);
            float fProgress = (float)((double)_nDownloadCount / (double)_nTotalCount);
            NSLog(@"%d / %d", _nDownloadCount, _nTotalCount);
            if (self.vc != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.vc setProgress:fProgress];
                });
            }
        } else {
            [self downloadFile:item];
            return;
        }
    }
    
    [[VPurchaseInfo sharedInfo] setUpdateOffline:self.nCurrentBook on:1];
    [_downloadBookArray removeObjectAtIndex:0];
    if (self.vc != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.vc updateUI];
        });
    }
    [self downloadBooks];
    return;
}

- (BOOL) isExistFile:(VAudioFileItem*)item{
    NSString* strFilePath = [item getDownloadPath];
    NSString* strKeyName = [item getKeyString];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:strFilePath];
    NSInteger nExisted = [[NSUserDefaults standardUserDefaults] integerForKey:strKeyName];
    return fileExists && (nExisted == 1);
}

- (void) downloadFile:(VAudioFileItem*)item {
    NSURL* url = [NSURL URLWithString:[item getUrl]];
    VHTTPDownloader* downloader = [[VHTTPDownloader alloc] initWithUrl:url targetPath:[item getDownloadPath] userAgent:nil];
    [downloader startWithProgressBlock:^(int64_t totalSize, int64_t downloadedSize) {
        NSLog(@"downloading count %lld %ld", totalSize, downloadedSize);
    } completionBlock:^(BOOL success, int64_t totalSize, int64_t downloadedSize) {
        if (totalSize != 0 && totalSize == downloadedSize) {
            NSString* strKeyName = [item getKeyString];
            [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:strKeyName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _nDownloadCount += 1;
            float fProgress = (float)((double)_nDownloadCount / (double)_nTotalCount);
            NSLog(@"complete %d / %d", _nDownloadCount, _nTotalCount);
            if (self.vc != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.vc setProgress:fProgress];
                });
            }
            [self downloadOneBook:_nDownloadCount];
        }else{
            if (self.vc != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.vc hideProgressBar];
                });
            }
            [self downloadOneBook:0];
        }
    }];
}
@end
