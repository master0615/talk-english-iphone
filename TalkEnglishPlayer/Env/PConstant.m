//
//  PConstant.m
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/12/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PConstant.h"
#define URL_PREFIX @"http://www.skesl.com/apps/listenlong/audio/"
@implementation PConstant

+ (NSInteger) getTotalSlowTime:(NSMutableArray*) playListDataItemList {
    NSInteger nTotalTime = 0;
    if (playListDataItemList != nil) {
        for (int i = 0; i < playListDataItemList.count; i ++) {
            PPlayListDataItem* item = playListDataItemList[i];
            nTotalTime += item.mNormalTime;
        }
    }
    return nTotalTime;
}

+ (NSString*) getDurationString:(NSInteger) nDuration {
    int nMin = nDuration / 60;
    int nSec = nDuration % 60;
    NSString* strDuration = [NSString stringWithFormat:@"%02d:%02d", nMin, nSec];
    return strDuration;
}

+ (BOOL) checkExistFile:(NSString*)filename {
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString* strPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, filename];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:strPath];
    NSInteger nExisted = [[NSUserDefaults standardUserDefaults] integerForKey:filename];
    if (fileExists && (nExisted == 1)) {
        return YES;
    }
    return NO;
}

+ (NSString*) getAudioFilePath:(NSString*)filename {
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString* strPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, filename];
    return strPath;
}

+ (NSString*) getAudioDownloadPath:(NSString*)filename {
    NSString* strPath = [NSString stringWithFormat:@"%@/%@", URL_PREFIX, filename];
    return strPath;
}
@end
