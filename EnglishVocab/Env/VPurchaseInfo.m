//
//  VPurchaseInfo.m
//  EnglishVocab
//
//  Created by SongJiang on 4/5/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VPurchaseInfo.h"
#import "VLevel.h"

@implementation VPurchaseInfo
+ (VPurchaseInfo*)sharedInfo {
    static VPurchaseInfo* sVPurchaseInfo = nil;
    if (sVPurchaseInfo == nil)
        sVPurchaseInfo = [VPurchaseInfo new];
    return sVPurchaseInfo;
}

- (id)init {
    self = [super init];
    if (self)
    {
        self.purchased = [[NSMutableArray alloc] init];
        self.purchasedRemoveAds = [[NSMutableArray alloc] init];
        self.offlineModes = [[NSMutableArray alloc] init];
        [self updateInfo];
    }
    return self;
}

- (void)updateInfo{
    [self.purchased removeAllObjects];
    for (int i =0; i <= 11; i++) {
        [_purchased addObject:@(0)];
    }
    [self.purchasedRemoveAds removeAllObjects];
    for (int i =0; i < 2; i++) {
        [_purchasedRemoveAds addObject:@(0)];
    }
    [self.offlineModes removeAllObjects];
    for (int i = 0; i < 11; i++) {
        [_offlineModes addObject:@(0)];
    }
    NSInteger isPurchased = 0;
    isPurchased = [[[NSUserDefaults standardUserDefaults] objectForKey:@"All"] integerValue];
    _purchased[0] = @(isPurchased);
    for (int i = 1; i <= 11; i++) {
        isPurchased = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"Book%d", i]] integerValue];
        _purchased[i] = @(isPurchased);
    }
    
    isPurchased = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RemoveAds1"] integerValue];
    _purchasedRemoveAds[0] = @(isPurchased);
    isPurchased = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RemoveAdsDonate1"] integerValue];
    _purchasedRemoveAds[1] = @(isPurchased);
    
    for (int i = 0; i < 11; i++) {
        NSInteger offlineMode = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"OfflineBook%d", i]] integerValue];
        _offlineModes[i] = @(offlineMode);
    }
}

- (void)setUpdateOffline:(NSInteger)nBookNum on:(int)nOn{
    [[NSUserDefaults standardUserDefaults] setObject:@(nOn) forKey:[NSString stringWithFormat:@"OfflineBook%d", nBookNum - 1]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateInfo];
}

- (int)isOfflineMode:(NSInteger)nBookNum{
    NSInteger offlineMode =[_offlineModes[nBookNum - 1] integerValue];
    return offlineMode;
}

- (void)setUpdate:(NSInteger)index{
    if (index == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"All"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:[NSString stringWithFormat:@"Book%d", index]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self updateInfo];
}

- (void)setUpdateRemoveAds:(NSInteger)index{
    if (index == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"RemoveAds1"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"RemoveAdsDonate1"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self updateInfo];
}

- (BOOL)isPurchasedBook{
    BOOL isPurchased = NO;
    for (int i = 0; i <= 11; i ++) {
        if([_purchased[i] integerValue] == 1) {
            isPurchased = YES;
            break;
        }
    }
    return isPurchased;
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

- (BOOL)isAllPurchasedForRemove{
    BOOL isPurchased = YES;
    if([_purchasedRemoveAds[0] integerValue] == 0){
        isPurchased = NO;
    }
    if([_purchasedRemoveAds[1] integerValue] == 0){
        isPurchased = NO;
    }
    return isPurchased;
}

@end
