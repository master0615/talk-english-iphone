//
//  BPurchaseViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/19/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "BPurchaseViewController.h"
#import "UIViewController+SlideMenu.h"
#import "BInAppPurchaseController.h"
#import "InAppPurchaseController.h"
#import "BHomeViewController.h"
#import "UIUtils.h"
#import "BEnv.h"
#import "BAnalytics.h"
#import "SharedPref.h"


@interface BPurchaseViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblPurchase;

@end

@implementation BPurchaseViewController

- (void)successInAppPurchase:(NSNotification*)ntf {
    NSString* productId = [ntf.userInfo objectForKey:IAPHelperProductPurchasedNotification];
//    int isPurchased = [SharedPref intForKey: @"isPurchased" default: 0];
//    if (productId.length > 0) {
//        if ([productId isEqualToString:kIAPItemProductId199]) {
//            isPurchased |= 1;
//            [SharedPref setInt: isPurchased forKey: @"isPurchased"];
//            [self.tblPurchase reloadData];
//            return;
//        } else if ([productId isEqualToString:kIAPItemProductId299]) {
//            isPurchased |= 2;
//            [SharedPref setInt: isPurchased forKey: @"isPurchased"];
//            [self.tblPurchase reloadData];
//        } else if ([productId isEqualToString:kIAPItemProductId499]) {
//            isPurchased |= 4;
//            [SharedPref setInt: isPurchased forKey: @"isPurchased"];
//            [self.tblPurchase reloadData];
//        }
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Remove Ads";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [[UIImage imageNamed: @"nav_back"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(onClickGoBack)];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [[UIImage imageNamed: @"ic_hamburger"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(onClickHamburger)];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    self.tblPurchase.rowHeight = UITableViewAutomaticDimension;
    self.tblPurchase.estimatedRowHeight = 70;
}

- (void) onClickBack {
    [self.navigationController popViewControllerAnimated: YES];
}
- (void) myAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successInAppPurchase:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [BAnalytics sendScreenName:@"Purchase Screen"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductPurchasedNotification object:nil];
}
- (void) viewWillLayoutSubviews {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        
        
    } else if (UIInterfaceOrientationIsPortrait(orientation)) {
        
    }
    [_tblPurchase reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) onClickHamburger {
    [self toggleRight];
    [BAnalytics sendEvent: @"Menu pressed" label: @"Remove Ads"];
}
- (void) onClickGoBack {
    [self.navigationController popViewControllerAnimated: YES];
    [BAnalytics sendEvent: @"Back pressed" label: @"Remove Ads"];
}
- (void) setTitle:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.bounds.size.width-90, self.navigationController.view.bounds.size.height)];
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName: @"NanumBarunGothicOTFBold" size: 20];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.minimumScaleFactor = 0.75;
    titleLabel.adjustsFontSizeToFitWidth = NO;
    self.navigationItem.titleView = titleLabel;
}
- (IBAction)onPurchase:(id)sender {
    UIView* view = sender;
    CGPoint center= view.center;
    CGPoint rootViewPoint = [view convertPoint:center toView:self.tblPurchase];
    NSIndexPath *indexPath = [self.tblPurchase indexPathForRowAtPoint:rootViewPoint];
    NSLog(@"%@",indexPath);
    if (indexPath.row != 5) {
        NSInteger kPurchaseItemIndex = indexPath.row - 2;
        if (indexPath.row == 1) {
            kPurchaseItemIndex = indexPath.row - 1;
        }
        int isPurchased = [SharedPref intForKey: @"isPurchased" default: 0];
        isPurchased = isPurchased & ( 1 << kPurchaseItemIndex);
        if (isPurchased > 0 && kPurchaseItemIndex != 1) {
            return;
        }
        if (![BInAppPurchaseController canPurchaseItems]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"You couldn't purchase items in your device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        
        
        BInAppPurchaseController* iap = [BInAppPurchaseController sharedController];
        [iap requestProductsAtDoneIndex:kPurchaseItemIndex withCompletionHandler:^(BOOL success, NSArray *products) {
            if (success && products.count > 0) {
                [iap buyProductAtIndex: kPurchaseItemIndex];
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
        if (![BInAppPurchaseController canPurchaseItems]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"You couldn't purchase items in your device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        BInAppPurchaseController* iap = [BInAppPurchaseController sharedController];
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
    return 7;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0 || indexPath.row == 5) {
//        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
//            return 80;
//        }else{
//            return 60;
//        }
//    }
//    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
//        return 90;
//    }else{
//        return 70;
//    }
    return UITableViewAutomaticDimension;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellDesc0"];
        return cell;
    }/* else if (indexPath.row == 1) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellDesc1"];
        return cell;
    }*/ else if (indexPath.row == 1) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = @"Remove all ads permanently";
        UILabel* lbPrice = [cell viewWithTag:1251];
        UIView* viewButton = [cell viewWithTag:1255];
        NSInteger kPurchaseItemIndex = indexPath.row - 1;
        int isPurchased = [SharedPref intForKey: @"isPurchased" default: 0];
        isPurchased = isPurchased & ( 1 << kPurchaseItemIndex);
        if (isPurchased > 0){
            lbPrice.text = @"Purchased";
            viewButton.backgroundColor = [UIColor lightGrayColor];
        } else {
            lbPrice.text = @"$3.99";
            viewButton.backgroundColor = RGB(0x22, 0x8b, 0xd4);
        }
        return cell;
    } else if (indexPath.row == 2) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellDesc2"];
        return cell;
    } else if (indexPath.row == 3) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = @"Donate";
        UILabel* lbPrice = [cell viewWithTag:1251];
        UIView* viewButton = [cell viewWithTag:1255];
        NSInteger kPurchaseItemIndex = indexPath.row - 2;
        int isPurchased = [SharedPref intForKey: @"isPurchased" default: 0];
        isPurchased = isPurchased & ( 1 << kPurchaseItemIndex);
//        if (isPurchased > 0){
//            lbPrice.text = @"Purchased";
//            viewButton.backgroundColor = [UIColor lightGrayColor];
//        } else {
            lbPrice.text = @"$4.99";
            viewButton.backgroundColor = RGB(0x22, 0x8b, 0xd4);
//        }
        return cell;
    } else if (indexPath.row == 4) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = @"Remove all ads + Donate";
        UILabel* lbPrice = [cell viewWithTag:1251];
        UIView* viewButton = [cell viewWithTag:1255];
        NSInteger kPurchaseItemIndex = indexPath.row - 2;
        int isPurchased = [SharedPref intForKey: @"isPurchased" default: 0];
        isPurchased = isPurchased & ( 1 << kPurchaseItemIndex);
        if (isPurchased > 0){
            lbPrice.text = @"Purchased";
            viewButton.backgroundColor = [UIColor lightGrayColor];
        } else {
            lbPrice.text = @"$8.99";
            viewButton.backgroundColor = RGB(0x22, 0x8b, 0xd4);
        }
        return cell;
    } else if (indexPath.row == 5) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = @"Restore Purchase";
        UILabel* lbPrice = [cell viewWithTag:1251];
        UIView* viewButton = [cell viewWithTag:1255];
        int isPurchased = [SharedPref intForKey: @"isPurchased" default: 0];
        if (isPurchased > 100){
            lbPrice.text = @"Purchased";
            viewButton.backgroundColor = [UIColor lightGrayColor];
        } else {
            lbPrice.text = @"Restore";
            viewButton.backgroundColor = RGB(0x22, 0x8b, 0xd4);
        }
        return cell;
    } else if (indexPath.row == 6) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellDesc3"];
        return cell;
    }
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    return cell;
}


@end
