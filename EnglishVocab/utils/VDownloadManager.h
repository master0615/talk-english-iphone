//
//  DownloadManager.h
//  EnglishConversation
//
//  Created by SongJiang on 6/29/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VOfflineModeViewController.h"
#import "VAudioFileItem.h"
#import "VPurchaseInfo.h"
@interface VDownloadManager : NSObject
@property(nonatomic, assign) NSInteger nTotalCount;
@property(nonatomic, assign) NSInteger nDownloadCount;
@property(nonatomic, assign) NSInteger nCurrentBook;
@property(nonatomic, strong) NSMutableArray* arrayAudioFileItem;
@property(nonatomic, strong) VOfflineModeViewController* vc;
@property(nonatomic, assign) NSInteger nStartedDownload;
@property(nonatomic, strong) NSMutableArray* downloadBookArray;
+ (VDownloadManager*)sharedInstance;
- (void) startDownload;
@end
