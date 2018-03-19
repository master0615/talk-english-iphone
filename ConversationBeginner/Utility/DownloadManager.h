//
//  DownloadManager.h
//  EnglishConversation
//
//  Created by SongJiang on 6/29/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OfflineModeViewController.h"

@interface DownloadManager : NSObject
@property(nonatomic, assign) NSInteger nTotalCount;
@property(nonatomic, assign) NSInteger nDownloadCount;
@property(nonatomic, strong) NSMutableArray* arrayFileNames;
@property(nonatomic, strong) OfflineModeViewController* vc;
@property(nonatomic, assign) NSInteger nStartedDownload;
+ (DownloadManager*)sharedInstance;
- (void) downloadAll:(NSInteger) index;
@end
