//
//  PurchaseViewController.h
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import "GPurchaseViewController.h"

#import "GInAppPurchaseController.h"
#import "InAppPurchaseController.h"
#import "GSharedPref.h"
#import "GAnalytics.h"

@interface GPurchaseViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *svMain;
@property (weak, nonatomic) IBOutlet UIView *viewPurchases;

@property (weak, nonatomic) IBOutlet UIView *viewRemoveAds;
@property (weak, nonatomic) IBOutlet UILabel *lblRemoveAds;

@property (weak, nonatomic) IBOutlet UIView *viewDonate;
@property (weak, nonatomic) IBOutlet UILabel *lblDonate;

@property (weak, nonatomic) IBOutlet UIView *viewRemoveAdsDonate;
@property (weak, nonatomic) IBOutlet UILabel *lblRemoveAdsDonate;

@property (weak, nonatomic) IBOutlet UIView *viewRestore;
@property (weak, nonatomic) IBOutlet UILabel *lblRestore;

@end

@implementation GPurchaseViewController

- (void)successInAppPurchase:(NSNotification*)ntf
{
    NSString* productId = [ntf.userInfo objectForKey:IAPHelperProductPurchasedNotification];
    int isPurchased = [GSharedPref intForKey: @"isPurchased" default: 0];
    if (productId.length > 0) {
        if ([productId isEqualToString:kIAPItemRemoveAds]) {
            isPurchased |= 1;
            [GSharedPref setInt: isPurchased forKey: @"isPurchased"];
        } else if ([productId isEqualToString:kIAPItemDonate]) {
            isPurchased |= 2;
            [GSharedPref setInt: isPurchased forKey: @"isPurchased"];
        } else if ([productId isEqualToString:kIAPItemRemoveAdsAndDonate]) {
            isPurchased |= 4;
            [GSharedPref setInt: isPurchased forKey: @"isPurchased"];
        }
        
        [self updatePurchaseViews];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Remove ads";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [GAnalytics sendScreenName:@"Purchase Screen"];
}

- (void)onClickBack {
    [super onClickBack];
    [GAnalytics sendEvent: @"Back pressed" label: @"Remove Ads"];
}

- (void)onClickShare {
    [super onClickShare];
    [GAnalytics sendEvent: @"Share pressed" label: @"Remove Ads"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successInAppPurchase:) name:IAPHelperProductPurchasedNotification object:nil];
    
    [self updatePurchaseViews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductPurchasedNotification object:nil];
}

- (void) repositionView
{
    [super repositionView];
    
    self.viewPurchases.frame = CGRectMake(0, 0, self.svMain.frame.size.width, 480);
    self.svMain.contentSize = CGSizeMake(self.viewPurchases.frame.size.width, self.viewPurchases.frame.size.height);
//    
//    if(self.bannerView.isHidden) {
        self.svMain.frame = CGRectMake(self.svMain.frame.origin.x, self.svMain.frame.origin.y, self.svMain.frame.size.width, self.view.frame.size.height - self.svMain.frame.origin.y);
//    } else {
//        self.svMain.frame = CGRectMake(self.svMain.frame.origin.x, self.svMain.frame.origin.y, self.svMain.frame.size.width, self.view.frame.size.height - self.svMain.frame.origin.y - self.bannerView.frame.size.height);
//        self.bannerView.frame = CGRectMake(0, self.view.frame.size.height - self.bannerView.frame.size.height, self.view.frame.size.width, self.bannerView.frame.size.height);
//    }
}

- (IBAction)onPurchase:(id)sender
{
    NSInteger purchaseItemIndex = ((UIButton *)sender).tag;
    
    if (purchaseItemIndex != 3)
    {
        int isPurchased = [GSharedPref intForKey: @"isPurchased" default: 0];
        isPurchased = isPurchased & ( 1 << purchaseItemIndex);
        if (isPurchased > 0 && purchaseItemIndex != 1) {
            return;
        }
        if (![GInAppPurchaseController canPurchaseItems]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"You couldn't purchase items in your device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        GInAppPurchaseController* iap = [GInAppPurchaseController sharedController];
        [iap requestProductsAtDoneIndex:purchaseItemIndex withCompletionHandler:^(BOOL success, NSArray *products) {
            if (success && products.count > 0) {
                [iap buyProductAtIndex: purchaseItemIndex];
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
    } else {
        //[[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:@"isPurchased"];
        if (![GInAppPurchaseController canPurchaseItems]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"You couldn't purchase items in your device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        GInAppPurchaseController* iap = [GInAppPurchaseController sharedController];
        [iap restoreCompletedProducts];
    }
    
}

- (void) updatePurchaseViews
{
        int isRemoveAdsPurchased = [GSharedPref intForKey: @"isPurchased" default: 0];
        isRemoveAdsPurchased = isRemoveAdsPurchased & ( 1 << 0);
        if (isRemoveAdsPurchased > 0){
            self.lblRemoveAds.text = @"Purchased";
            self.viewRemoveAds.backgroundColor = [UIColor lightGrayColor];
        } else {
            self.lblRemoveAds.text = @"$2.99";
            self.viewRemoveAds.backgroundColor = [UIColor colorWithRed:61.0f / 255.0f green:62.0f / 255.0f blue:64.0f / 255.0f alpha:1.0f];
        }


        int isDonatePurchased = [GSharedPref intForKey: @"isPurchased" default: 0];
        isDonatePurchased = isDonatePurchased & ( 1 << 1);
//        if (isDonatePurchased > 0){
//            self.lblDonate.text = @"Purchased";
//            self.viewDonate.backgroundColor = [UIColor lightGrayColor];
//        } else {
                self.lblDonate.text = @"$2.99";
                self.viewDonate.backgroundColor = [UIColor colorWithRed:61.0f / 255.0f green:62.0f / 255.0f blue:64.0f / 255.0f alpha:1.0f];
//        }

        int isAdsDonatePurchased = [GSharedPref intForKey: @"isPurchased" default: 0];
        isAdsDonatePurchased = isAdsDonatePurchased & ( 1 << 2);
        if (isAdsDonatePurchased > 0){
            self.lblRemoveAdsDonate.text = @"Purchased";
            self.viewRemoveAdsDonate.backgroundColor = [UIColor lightGrayColor];
        } else {
            self.lblRemoveAdsDonate.text = @"$5.99";
            self.viewRemoveAdsDonate.backgroundColor = [UIColor colorWithRed:61.0f / 255.0f green:62.0f / 255.0f blue:64.0f / 255.0f alpha:1.0f];
        }
        
        int isRestored = [GSharedPref intForKey: @"isPurchased" default: 0];
        if (isRestored > 100){
            self.lblRestore.text = @"Restored";
            self.viewRestore.backgroundColor = [UIColor lightGrayColor];
        } else {
            self.lblRestore.text = @"Restore";
            self.viewRestore.backgroundColor = [UIColor colorWithRed:61.0f / 255.0f green:62.0f / 255.0f blue:64.0f / 255.0f alpha:1.0f];
        }
}


@end
