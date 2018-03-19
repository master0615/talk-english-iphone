//
//  DownloadManager.m
//  EnglishConversation
//
//  Created by SongJiang on 6/29/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PDownloadManager.h"
#import "PHTTPDownloader.h"
#import "PDBManager.h"
#import "PTrackItem.h"
#import "PConstant.h"
#import "PConstants.h"

@implementation PDownloadManager

+ (PDownloadManager*)sharedInstance {
    static PDownloadManager *sDownloadManager = nil;
    if (sDownloadManager == nil) {
        sDownloadManager = [PDownloadManager new];
        [sDownloadManager initData];
        sDownloadManager.nStartedDownload = 0;
    }
    return sDownloadManager;
}
- (void) initData{
    self.downloadAlbumArray = [[NSMutableArray alloc] init];
    _arrayAudioFileItem = nil;
}

- (void) startDownload{
    if (self.nStartedDownload == 0) {
        [self downloadBooks];
    }
}

- (float) getCurrentProgress {
    if (_nTotalCount <= 0) {
        return 0.0f;
    }
    float fProgress = (float)((double)_nDownloadCount / (double)_nTotalCount);
    return fProgress;
}
- (NSInteger) albumStatus:(NSInteger)nAlbumNumber {
    if ([[PPurchaseInfo sharedInfo] isDownloadAlbum:nAlbumNumber] == 1) {
        return 1;
    }
    if (self.nCurrentDownloadAlbum == nAlbumNumber) {
        return 2;
    }
    for (int i = 0; i < self.downloadAlbumArray.count; i ++) {
        if([self.downloadAlbumArray[i] integerValue] == nAlbumNumber){
            return 3;
        }
    }
    
    return 0;
}

- (void) downloadBooks{
    self.nStartedDownload = 1;
    if(self.downloadAlbumArray.count > 0) {
        _nCurrentDownloadAlbum = [self.downloadAlbumArray[0] integerValue];
        _arrayAudioFileItem = [PDBManager loadTrackList:_nCurrentDownloadAlbum nGenderMode:0];
        _nTotalCount = _arrayAudioFileItem.count * 3;
        [self downloadOneBook:0];
        return;
    }
    self.nStartedDownload = 0;
}

- (void) downloadOneBook:(NSInteger) index {
    if (index == 0) {
        self.nDownloadCount = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_ALBUM_START object:nil];
    }
    for (NSInteger i = index; i < _arrayAudioFileItem.count * 3; i ++) {
        NSInteger nItemIndex = i / 3;
        NSInteger nMode = i % 3;
        PTrackItem* item = _arrayAudioFileItem[nItemIndex];
        NSString* strFileName;
        switch (nMode) {
            case 0:
                strFileName = item.strAudioNormal;
                break;
            case 1:
                strFileName = item.strAudioSlow;
                break;
            case 2:
                strFileName = item.strAudioVerySlow;
                break;
            default:
                strFileName = item.strAudioNormal;
                break;
        }
        
        if([PConstant checkExistFile:strFileName]) {
            _nDownloadCount += 1;
            NSLog(@"download count %ld", _nDownloadCount);
            float fProgress = (float)((double)_nDownloadCount / (double)_nTotalCount);
            NSLog(@"%ld / %ld", _nDownloadCount, _nTotalCount);
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_ALBUM_STATE object:nil];
        } else {
            [self downloadFile:strFileName];
            return;
        }
    }
    
    [[PPurchaseInfo sharedInfo] setDownloadAlbum:self.nCurrentDownloadAlbum on:1];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_ALBUM_COMPLETE object:nil];
    [self.downloadAlbumArray removeObjectAtIndex:0];
    [self downloadBooks];
    return;
}

- (void) downloadFile:(NSString*)strFileName {
    NSURL* url = [NSURL URLWithString:[PConstant getAudioDownloadPath:strFileName]];
    PHTTPDownloader* downloader = [[PHTTPDownloader alloc] initWithUrl:url targetPath:[PConstant getAudioFilePath:strFileName] userAgent:nil];
    [downloader startWithProgressBlock:^(int64_t totalSize, int64_t downloadedSize) {
        NSLog(@"downloading count %lld %ld", totalSize, downloadedSize);
    } completionBlock:^(BOOL success, int64_t totalSize, int64_t downloadedSize) {
        if (totalSize != 0 && totalSize == downloadedSize) {
            [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:strFileName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _nDownloadCount += 1;
            float fProgress = (float)((double)_nDownloadCount / (double)_nTotalCount);
            NSLog(@"complete %d / %d", _nDownloadCount, _nTotalCount);
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_ALBUM_STATE object:nil];
            [self downloadOneBook:_nDownloadCount];
        }else{
            [self downloadOneBook:0];
        }
    }];
}
@end
