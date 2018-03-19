//
//  DownloadManager.m
//  EnglishConversation
//
//  Created by SongJiang on 6/29/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "DownloadManager.h"
#import "ECCategoryManager.h"
#import "HTTPDownloader.h"
#import "Db.h"

@implementation DownloadManager

+ (DownloadManager*)sharedInstance {
    static DownloadManager *sDownloadManager = nil;
    if (sDownloadManager == nil) {
        sDownloadManager = [DownloadManager new];
        [sDownloadManager initData];
        sDownloadManager.nStartedDownload = 0;
    }
    return sDownloadManager;
}
- (void) initData{
    _arrayFileNames = [[NSMutableArray alloc] init];
    
    NSString* query = [NSString stringWithFormat: @"SELECT * FROM Lessons;"];
    Cursor* cursor = [[Db db] prepareCursor: query];
    
    if(cursor == nil) return;
    
    while ([cursor next]) {
        NSString* strFileName = [cursor getString:@"ChannelAll"];
        [_arrayFileNames addObject:strFileName];
        NSString* strFileNameA = [cursor getString:@"ChannelA"];
        [_arrayFileNames addObject:strFileNameA];
        NSString* strFileNameB = [cursor getString:@"ChannelB"];
        [_arrayFileNames addObject:strFileNameB];
    }
    [cursor close];
    
    _nTotalCount = _arrayFileNames.count;
}

- (void) downloadAll:(NSInteger) index {
    self.nStartedDownload = 1;
    if (index == 0) {
        self.nDownloadCount = 0;
    }
    for (NSInteger i = index; i < _arrayFileNames.count; i ++) {
        NSString* strFileName = _arrayFileNames[i];
        if([self isExistFile:strFileName]) {
            _nDownloadCount += 1;
//            float fProgress = (float)((double)_nDownloadCount / (double)_nTotalCount);
//            //            _hud.progress = fProgress;
            NSLog(@"download count %ld", _nDownloadCount);
        } else {
            [self downloadFile:strFileName];
            return;
        }
    }
    
    [ECCategoryManager sharedInstance].isOfflineMode = 1;
    [[NSUserDefaults standardUserDefaults] setValue:@([ECCategoryManager sharedInstance].isOfflineMode) forKey:@"isOfflineMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.nStartedDownload = 0;
    //    [_hud hideAnimated:YES];
    if (self.vc != nil) {
        [self.vc updateUI];
        [self.vc hideProgressBar];
    }
    return;
}

- (BOOL) isExistFile:(NSString*)strFileName{
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:strFileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:targetPath];
    NSInteger nExisted = [[NSUserDefaults standardUserDefaults] integerForKey:strFileName];
    return fileExists && (nExisted == 1);
}

- (void) downloadFile:(NSString*)strFileName {
    NSString* strAudioBaseUrl = AUDIO_URL;
    NSString* strAudioFileUrl = [strAudioBaseUrl stringByAppendingString:strFileName];
    NSURL* urlAudioFile = [NSURL URLWithString:strAudioFileUrl];
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    HTTPDownloader* downloader = [[HTTPDownloader alloc] initWithUrl:urlAudioFile targetPath:[documentsDirectory stringByAppendingPathComponent:strFileName] userAgent:nil];
    [downloader startWithProgressBlock:^(int64_t totalSize, int64_t downloadedSize) {
        NSLog(@"downloading count %d %d", totalSize, downloadedSize);
    } completionBlock:^(BOOL success, int64_t totalSize, int64_t downloadedSize) {
        if (totalSize != 0 && totalSize == downloadedSize) {
            [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:strFileName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _nDownloadCount += 1;
            float fProgress = (float)((double)_nDownloadCount / (double)_nTotalCount);
            if (self.vc != nil) {
                [self.vc setProgress:fProgress];
            }
            [self downloadAll:_nDownloadCount];
        }else{
            if (self.vc != nil) {
                [self.vc hideProgressBar];
                [self.vc changeButtonTitle:YES];
            }
            [self downloadAll:0];
        }
    }];
}
@end
