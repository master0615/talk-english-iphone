//
//  VPurchaseInfo.h
//  EnglishVocab
//
//  Created by SongJiang on 4/5/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPurchaseInfo : NSObject
@property(nonatomic, strong) NSMutableArray* purchased;
@property(nonatomic, strong) NSMutableArray* purchasedRemoveAds;
@property(nonatomic, strong) NSMutableArray* offlineModes;
+ (VPurchaseInfo*)sharedInfo;
- (void)updateInfo;
- (void)setUpdate:(NSInteger)index;
- (void)setUpdateRemoveAds:(NSInteger)index;
- (BOOL)isPurchasedForRemove;
- (BOOL)isAllPurchasedForRemove;
- (BOOL)isPurchasedBook;
- (void)setUpdateOffline:(NSInteger)nBookNum on:(int)nOn;
- (int)isOfflineMode:(NSInteger)nBookNum;

@end
