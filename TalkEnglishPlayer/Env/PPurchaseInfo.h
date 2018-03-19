//
//  PPurchaseInfo.h
//  EnglishVocab
//
//  Created by SongJiang on 4/5/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPurchaseInfo : NSObject
@property(nonatomic, assign) NSInteger purchasedOffline;
@property(nonatomic, strong) NSMutableArray* purchasedRemoveAds;
@property(nonatomic, assign) NSTimeInterval lastTimeAdShown;
@property(nonatomic, assign) NSTimeInterval lastTimeLoadTried;
+ (PPurchaseInfo*)sharedInfo;
- (void)updateInfo;
- (void)setUpdateForOffline;
- (void)setUpdateRemoveAds:(NSInteger)nIndex;
- (BOOL)isPurchasedForRemove;
- (void)setDownloadAlbum:(NSInteger)nAlbumNumber on:(NSInteger)nOn;
- (NSInteger)isDownloadAlbum:(NSInteger)nAlbumNumber;
@end
