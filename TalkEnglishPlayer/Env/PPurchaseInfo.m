//
//  PPurchaseInfo.m
//  EnglishVocab
//
//  Created by SongJiang on 4/5/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PPurchaseInfo.h"

@implementation PPurchaseInfo
+ (PPurchaseInfo*)sharedInfo {
    static PPurchaseInfo* sPurchaseInfo = nil;
    if (sPurchaseInfo == nil)
        sPurchaseInfo = [PPurchaseInfo new];
    return sPurchaseInfo;
}

- (id)init {
    self = [super init];
    if (self)
    {
        self.purchasedOffline = 0;
        self.purchasedRemoveAds = [[NSMutableArray alloc] init];
        [self updateInfo];
    }
    return self;
}

- (void)updateInfo{
    self.purchasedOffline = [[[NSUserDefaults standardUserDefaults] objectForKey:@"OfflineMode"] integerValue];
    [self.purchasedRemoveAds removeAllObjects];
    for (int i =0; i < 2; i++) {
        [_purchasedRemoveAds addObject:@(0)];
    }
    NSInteger isPurchased = 0;
    isPurchased = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RemoveAds199"] integerValue];
    _purchasedRemoveAds[0] = @(isPurchased);
    isPurchased = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RemoveAds399"] integerValue];
    _purchasedRemoveAds[1] = @(isPurchased);
}


- (void)setUpdateForOffline{
    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"OfflineMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateInfo];
}

- (void)setUpdateRemoveAds:(NSInteger)nIndex{
    if (nIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"RemoveAds199"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"RemoveAds399"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self updateInfo];
}

- (BOOL)isPurchasedForRemove{
    BOOL isPurchased = NO;
    if([_purchasedRemoveAds[0] integerValue] == 1){
        isPurchased = YES;
    }
    if([_purchasedRemoveAds[1] integerValue] == 1){
        isPurchased = YES;
    }
    return isPurchased;
}

- (void)setDownloadAlbum:(NSInteger)nAlbumNumber on:(NSInteger)nOn{
    [[NSUserDefaults standardUserDefaults] setObject:@(nOn) forKey:[NSString stringWithFormat:@"AlbumNumberDownload_%ld", nAlbumNumber]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateInfo];
}

- (NSInteger)isDownloadAlbum:(NSInteger)nAlbumNumber{
    NSInteger isDownloaded = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"AlbumNumberDownload_%ld", nAlbumNumber]] integerValue];
    return isDownloaded;
}

@end
