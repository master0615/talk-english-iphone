//
//  POfflineModeViewController.m
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/22/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "POfflineModeViewController.h"
#import "InAppPurchaseController.h"
#import "PInAppPurchaseController.h"
#import "PPurchaseInfo.h"
#import "PAnalytics.h"

@interface POfflineModeViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewForPurchased;
@property (weak, nonatomic) IBOutlet UIView *viewForPurchase;

@end

@implementation POfflineModeViewController

- (void)successInAppPurchase:(NSNotification*)ntf {
    NSString* productId = [ntf.userInfo objectForKey:IAPHelperProductPurchasedNotification];
    if (productId.length > 0) {
        if ([productId isEqualToString:kIAPItemOffline]) {
            [[PPurchaseInfo sharedInfo] setUpdateForOffline];
        }else if ([productId isEqualToString:kIAPItemRemoveAds2]) {
            [[PPurchaseInfo sharedInfo] setUpdateRemoveAds:0];
        }else if ([productId isEqualToString:kIAPItemDonate2]) {
            [[PPurchaseInfo sharedInfo] setUpdateRemoveAds:0];
        }
        [self updateUI];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successInAppPurchase:) name:IAPHelperProductPurchasedNotification object:nil];
    [PAnalytics sendScreenName:@"Offline Screen"];
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onPurchase:(id)sender {
    NSInteger kPurchaseItemIndex = 0;
    if (![PInAppPurchaseController canPurchaseItems]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"You couldn't purchase items in your device."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    
    PInAppPurchaseController* iap = [PInAppPurchaseController sharedController];
    [iap requestProductsAtDoneIndex:kPurchaseItemIndex withCompletionHandler:^(BOOL success, NSArray *products) {
        if (success && products.count > 0) {
            [iap buyProductAtIndex:kPurchaseItemIndex];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Something went wrong to connect iTunes."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }];
    
}
- (IBAction)onRestore:(id)sender {
    //[[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:@"isPurchased"];
    if (![PInAppPurchaseController canPurchaseItems]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"You couldn't purchase items in your device."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    PInAppPurchaseController* iap = [PInAppPurchaseController sharedController];
    [iap restoreCompletedProducts];
}

- (void) updateUI {
//    if ([PPurchaseInfo sharedInfo].purchasedOffline > 0) {
        self.viewForPurchase.hidden = YES;
        self.viewForPurchased.hidden = NO;
//    } else {
//        self.viewForPurchase.hidden = NO;
//        self.viewForPurchased.hidden = YES;
//    }
}

@end
