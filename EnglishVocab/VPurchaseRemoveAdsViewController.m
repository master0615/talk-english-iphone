//
//  PurchaseRemoveAdsViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/19/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VPurchaseRemoveAdsViewController.h"
#import "VInAppPurchaseController.h"
#import "InAppPurchaseController.h"
#import "VPurchaseInfo.h"
#import "VAnalytics.h"
#import "VAppInfo.h"


@interface VPurchaseRemoveAdsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblPurchase;

@end

@implementation VPurchaseRemoveAdsViewController

- (void)successInAppPurchase:(NSNotification*)ntf {
    NSString* productId = [ntf.userInfo objectForKey:IAPHelperProductPurchasedNotification];
    if (productId.length > 0) {
        if ([productId isEqualToString:kIAPItemProductIdAll]) {
            [[VPurchaseInfo sharedInfo] setUpdate:0];
        }else if ([productId isEqualToString:kIAPItemProductIdBook1]) {
            [[VPurchaseInfo sharedInfo] setUpdate:1];
        }else if ([productId isEqualToString:kIAPItemProductIdBook2]) {
            [[VPurchaseInfo sharedInfo] setUpdate:2];
        }else if ([productId isEqualToString:kIAPItemProductIdBook3]) {
            [[VPurchaseInfo sharedInfo] setUpdate:3];
        }else if ([productId isEqualToString:kIAPItemProductIdBook4]) {
            [[VPurchaseInfo sharedInfo] setUpdate:4];
        }else if ([productId isEqualToString:kIAPItemProductIdBook5]) {
            [[VPurchaseInfo sharedInfo] setUpdate:5];
        }else if ([productId isEqualToString:kIAPItemProductIdBook6]) {
            [[VPurchaseInfo sharedInfo] setUpdate:6];
        }else if ([productId isEqualToString:kIAPItemProductIdBook7]) {
            [[VPurchaseInfo sharedInfo] setUpdate:7];
        }else if ([productId isEqualToString:kIAPItemProductIdBook8]) {
            [[VPurchaseInfo sharedInfo] setUpdate:8];
        }else if ([productId isEqualToString:kIAPItemProductIdBook9]) {
            [[VPurchaseInfo sharedInfo] setUpdate:9];
        }else if ([productId isEqualToString:kIAPItemProductIdBook10]) {
            [[VPurchaseInfo sharedInfo] setUpdate:10];
        }else if ([productId isEqualToString:kIAPItemProductIdBook11]) {
            [[VPurchaseInfo sharedInfo] setUpdate:11];
        }else if ([productId isEqualToString:kIAPItemProductIdBookRemove3]) {
            [[VPurchaseInfo sharedInfo] setUpdateRemoveAds:0];
        }else if ([productId isEqualToString:kIAPItemProductIdBookRemove5]) {
            [[VPurchaseInfo sharedInfo] setUpdateRemoveAds:1];
        }
        [self.tblPurchase reloadData];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"title_purchase"]];
}

- (void) myAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successInAppPurchase:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [VAnalytics sendScreenName:@"Purchase Screen"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductPurchasedNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onPurchase:(id)sender {
    UIView* view = sender;
    CGPoint center= view.center;
    CGPoint rootViewPoint = [view convertPoint:center toView:self.tblPurchase];
    NSIndexPath *indexPath = [self.tblPurchase indexPathForRowAtPoint:rootViewPoint];
    NSLog(@"%@",indexPath);
    if (indexPath.row != 3) {
        NSInteger kPurchaseItemIndex = indexPath.row + 11;
        BOOL bPurchased = [[VPurchaseInfo sharedInfo] isPurchasedForRemove];
        if (bPurchased == YES) {
            return;
        }
        if (![VInAppPurchaseController canPurchaseItems]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"You couldn't purchase items in your device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        
        
        VInAppPurchaseController* iap = [VInAppPurchaseController sharedController];
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
    }else{
        //[[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:@"isPurchased"];
        if (![VInAppPurchaseController canPurchaseItems]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"You couldn't purchase items in your device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        VInAppPurchaseController* iap = [VInAppPurchaseController sharedController];
        [iap restoreCompletedProducts];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - TableView
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 5) {
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            return 80;
        }else{
            return 60;
        }
    }
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        return 90;
    }else{
        return 70;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellDesc"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"text_purchase1"];
        return cell;
    }else if (indexPath.row == 4) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellDesc"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"text_purchase2"];
        return cell;
    }else if (indexPath.row == 1) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = [NSString stringWithFormat:@"%@\n%@", [[VAppInfo sharedInfo] localizedStringForKey:@"app_info_36"], [[VAppInfo sharedInfo] localizedStringForKey:@"title_purchase"]];
        UILabel* lbPrice = [cell viewWithTag:1251];
        UIView* viewButton = [cell viewWithTag:1255];
        NSInteger isPurchased = [[VPurchaseInfo sharedInfo].purchasedRemoveAds[0] integerValue];
        if (isPurchased > 0){
            lbPrice.text = [[VAppInfo sharedInfo] localizedStringForKey:@"purchase_03"];
            viewButton.backgroundColor = [UIColor lightGrayColor];
        } else {
            lbPrice.text = @"$2.99";
            viewButton.backgroundColor = [UIColor colorWithRed:103.0f/255.0f green:191.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
        }
        
        return cell;
    }else if (indexPath.row == 2) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = [NSString stringWithFormat:@"%@\n%@", [[VAppInfo sharedInfo] localizedStringForKey:@"app_info_36"], [[VAppInfo sharedInfo] localizedStringForKey:@"text_puchase_item1"]];
        UILabel* lbPrice = [cell viewWithTag:1251];
        UIView* viewButton = [cell viewWithTag:1255];
        NSInteger isPurchased = [[VPurchaseInfo sharedInfo].purchasedRemoveAds[1] integerValue];
        if (isPurchased > 0){
            lbPrice.text = [[VAppInfo sharedInfo] localizedStringForKey:@"purchase_03"];
            viewButton.backgroundColor = [UIColor lightGrayColor];
        } else {
            lbPrice.text = @"$4.99";
            viewButton.backgroundColor = [UIColor colorWithRed:103.0f/255.0f green:191.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
        }
        return cell;
    }else if (indexPath.row == 3) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"restore_purchase"];
        
        UILabel* lbPrice = [cell viewWithTag:1251];
        UIView* viewButton = [cell viewWithTag:1255];
        
        if ([[VPurchaseInfo sharedInfo] isAllPurchasedForRemove] == YES){
            lbPrice.text = [[VAppInfo sharedInfo] localizedStringForKey:@"purchase_03"];
            viewButton.backgroundColor = [UIColor lightGrayColor];
        } else {
            lbPrice.text = @"Restore";
            viewButton.backgroundColor = [UIColor colorWithRed:103.0f/255.0f green:191.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
        }
        return cell;
    }
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    return cell;
}


@end
