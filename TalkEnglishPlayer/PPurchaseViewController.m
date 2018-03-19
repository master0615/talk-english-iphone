//
//  PPurchaseViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/19/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PPurchaseViewController.h"
#import "PInAppPurchaseController.h"
#import "InAppPurchaseController.h"
#import "PPurchaseInfo.h"
#import "PAnalytics.h"
#import "UIViewController+SlideMenu.h"


@interface PPurchaseViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblPurchase;

@end

@implementation PPurchaseViewController

- (void)successInAppPurchase:(NSNotification*)ntf {
    NSString* productId = [ntf.userInfo objectForKey:IAPHelperProductPurchasedNotification];
    if (productId.length > 0) {
        if ([productId isEqualToString:kIAPItemOffline]) {
            [[PPurchaseInfo sharedInfo] setUpdateForOffline];
        }else if ([productId isEqualToString:kIAPItemRemoveAds2]) {
            [[PPurchaseInfo sharedInfo] setUpdateRemoveAds:0];
        }else if ([productId isEqualToString:kIAPItemDonate2]) {
            [[PPurchaseInfo sharedInfo] setUpdateRemoveAds:1];
        }
        [self.tblPurchase reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [PAnalytics sendScreenName:@"Purchase Screen"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successInAppPurchase:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [PAnalytics sendScreenName:@"Purchase Screen"];
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
        NSInteger kPurchaseItemIndex = indexPath.row;
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
    }else{
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
        lbTitle.text = @"Remove distractions and focus on your studies.";
        return cell;
    }else if (indexPath.row == 4) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellDesc"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = @"Thank you very much for your generosity and support!";
        return cell;
    }else if (indexPath.row == 1) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = @"Purchase:\nRemove ads";
        UILabel* lbPrice = [cell viewWithTag:1251];
        UIView* viewButton = [cell viewWithTag:1255];
        UIButton* btnPurchase = [cell viewWithTag:1253];
        NSInteger isPurchased = [[PPurchaseInfo sharedInfo].purchasedRemoveAds[0] integerValue];
        if (isPurchased > 0){
            lbPrice.text = @"Purchased";
            viewButton.backgroundColor = [UIColor lightGrayColor];
            btnPurchase.enabled = NO;
        } else {
            lbPrice.text = @"$1.99";
            viewButton.backgroundColor = [UIColor colorWithRed:96.0f/255.0f green:70.0f/255.0f blue:9.0f/255.0f alpha:1.0f];
            btnPurchase.enabled = YES;
        }
        
        return cell;
    }else if (indexPath.row == 2) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = @"Purchase:\nRemove Ads & Donate $2";
        UILabel* lbPrice = [cell viewWithTag:1251];
        UIView* viewButton = [cell viewWithTag:1255];
        UIButton* btnPurchase = [cell viewWithTag:1253];
        NSInteger isPurchased = [[PPurchaseInfo sharedInfo].purchasedRemoveAds[1] integerValue];
        if (isPurchased > 0){
            lbPrice.text = @"Purchased";
            viewButton.backgroundColor = [UIColor lightGrayColor];
            btnPurchase.enabled = NO;
        } else {
            lbPrice.text = @"$3.99";
            viewButton.backgroundColor = [UIColor colorWithRed:96.0f/255.0f green:70.0f/255.0f blue:9.0f/255.0f alpha:1.0f];
            btnPurchase.enabled = YES;
        }
        return cell;
    }else if (indexPath.row == 3) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = @"Restore Purchase";
        UILabel* lbPrice = [cell viewWithTag:1251];
        UIView* viewButton = [cell viewWithTag:1255];
        lbPrice.text = @"Restore";
        viewButton.backgroundColor = [UIColor colorWithRed:96.0f/255.0f green:70.0f/255.0f blue:9.0f/255.0f alpha:1.0f];
        return cell;
    }
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    return cell;
}


@end
