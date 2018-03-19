//
//  DownloadManager.h
//  EnglishConversation
//
//  Created by SongJiang on 6/29/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POfflineModeViewController.h"
#import "PPurchaseInfo.h"
@interface PDownloadManager : NSObject
@property(nonatomic, assign) NSInteger nTotalCount;
@property(nonatomic, assign) NSInteger nDownloadCount;
@property(nonatomic, assign) NSInteger nCurrentDownloadAlbum;
@property(nonatomic, strong) NSMutableArray* arrayAudioFileItem;
@property(nonatomic, assign) NSInteger nStartedDownload;
@property(nonatomic, strong) NSMutableArray* downloadAlbumArray;
+ (PDownloadManager*)sharedInstance;
- (void) startDownload;
- (float) getCurrentProgress;
- (NSInteger) albumStatus:(NSInteger)nAlbumNumber;
@end
