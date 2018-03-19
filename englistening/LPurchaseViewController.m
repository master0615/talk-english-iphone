//
//  LPurchaseViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/19/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "LPurchaseViewController.h"
#import "InAppPurchaseController.h"
#import "LInAppPurchaseController.h"
#import "LHomeViewController.h"
#import "LUIUtils.h"
#import "LEnv.h"
#import "LAnalytics.h"
#import "LSharedPref.h"


@interface LPurchaseViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblPurchase;

@end

@implementation LPurchaseViewController

- (void)successInAppPurchase:(NSNotification*)ntf {
    NSString* productId = [ntf.userInfo objectForKey:IAPHelperProductPurchasedNotification];
    int isPurchased = [LSharedPref intForKey: @"isPurchased" default: 0];
    if (productId.length > 0) {
        if ([productId isEqualToString:kIAPItemProductId199]) {
            isPurchased |= 1;
            [LSharedPref setInt: isPurchased forKey: @"isPurchased"];
            [self.tblPurchase reloadData];
            return;
        }else if ([productId isEqualToString:kIAPItemProductId299]) {
            isPurchased |= 2;
            [LSharedPref setInt: isPurchased forKey: @"isPurchased"];
            [self.tblPurchase reloadData];
        }else if ([productId isEqualToString:kIAPItemProductId499]) {
            isPurchased |= 4;
            [LSharedPref setInt: isPurchased forKey: @"isPurchased"];
            [self.tblPurchase reloadData];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"English Listening";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"ic_back"] style: UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
// Remove share button 2018-01-27 by GoldRabbit
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_share"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickShare)];
}
- (void) onClickBack {
    [self.navigationController popViewControllerAnimated: YES];
}
- (void) onClickShare {
    
    [LAnalytics sendEvent: @"onClickShare"
                   label: @"Share"];
    
    NSMutableArray * objectToShare = [[NSMutableArray alloc] init];
    [objectToShare addObject: @SHARE_CONTENT];
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
    NSString* url = [NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [LEnv currentAppId]];
    [objectToShare addObject:url];
    
    UIActivityViewController* controller = [[UIActivityViewController alloc] initWithActivityItems:objectToShare applicationActivities:nil];
    
    // Exclude all activities except AirDrop.
    NSArray *excludedActivities = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        //excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,                                    UIActivityTypePostToWeibo, UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    }
    
    [controller setValue:@SHARE_CONTENT forKey:@"subject"];
    controller.excludedActivityTypes = excludedActivities;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)
        controller.popoverPresentationController.sourceView = self.view;
    [self presentViewController:controller animated:YES completion:nil];
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
    [LAnalytics sendScreenName:@"Purchase Screen"];
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
    if (indexPath.row != 4) {
        NSInteger kPurchaseItemIndex = indexPath.row - 1;
        int isPurchased = [LSharedPref intForKey: @"isPurchased" default: 0];
        isPurchased = isPurchased & ( 1 << kPurchaseItemIndex);
        if (isPurchased > 0) {
            return;
        }
        if (![LInAppPurchaseController canPurchaseItems]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"You couldn't purchase items in your device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        
        
        LInAppPurchaseController* iap = [LInAppPurchaseController sharedController];
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
        if (![LInAppPurchaseController canPurchaseItems]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"You couldn't purchase items in your device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        LInAppPurchaseController* iap = [LInAppPurchaseController sharedController];
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
    return 6;
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
    }else if (indexPath.row == 5) {
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
        NSInteger kPurchaseItemIndex = indexPath.row - 1;
        int isPurchased = [LSharedPref intForKey: @"isPurchased" default: 0];
        isPurchased = isPurchased & ( 1 << kPurchaseItemIndex);
        if (isPurchased > 0){
            lbPrice.text = @"Purchased";
            viewButton.backgroundColor = [UIColor lightGrayColor];
        } else {
            lbPrice.text = @"$1.99";
            viewButton.backgroundColor = [UIColor colorWithRed: 157.0/255.0 green: 172.0/255.0 blue: 105.0/255.0 alpha: 1.0];
        }
        
        return cell;
    }else if (indexPath.row == 2) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = @"Purchase:\nRemove ads & Donate $1.00";
        UILabel* lbPrice = [cell viewWithTag:1251];
        UIView* viewButton = [cell viewWithTag:1255];
        NSInteger kPurchaseItemIndex = indexPath.row - 1;
        int isPurchased = [LSharedPref intForKey: @"isPurchased" default: 0];
        isPurchased = isPurchased & ( 1 << kPurchaseItemIndex);
        if (isPurchased > 0){
            lbPrice.text = @"Purchased";
            viewButton.backgroundColor = [UIColor lightGrayColor];
        } else {
            lbPrice.text = @"$2.99";
            viewButton.backgroundColor = [UIColor colorWithRed: 157.0/255.0 green: 172.0/255.0 blue: 105.0/255.0 alpha: 1.0];
        }
        return cell;
    }else if (indexPath.row == 3) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = @"Purchase:\nRemove ads & Donate $3.00";
        UILabel* lbPrice = [cell viewWithTag:1251];
        UIView* viewButton = [cell viewWithTag:1255];
        NSInteger kPurchaseItemIndex = indexPath.row - 1;
        int isPurchased = [LSharedPref intForKey: @"isPurchased" default: 0];
        isPurchased = isPurchased & ( 1 << kPurchaseItemIndex);
        if (isPurchased > 0){
            lbPrice.text = @"Purchased";
            viewButton.backgroundColor = [UIColor lightGrayColor];
        } else {
            lbPrice.text = @"$4.99";
            viewButton.backgroundColor = [UIColor colorWithRed: 157.0/255.0 green: 172.0/255.0 blue: 105.0/255.0 alpha: 1.0];
        }
        return cell;
    }else if (indexPath.row == 4) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = @"Restore Purchase";
        UILabel* lbPrice = [cell viewWithTag:1251];
        UIView* viewButton = [cell viewWithTag:1255];
        int isPurchased = [LSharedPref intForKey: @"isPurchased" default: 0];
        if (isPurchased > 100){
            lbPrice.text = @"Purchased";
            viewButton.backgroundColor = [UIColor lightGrayColor];
        } else {
            lbPrice.text = @"Restore";
            viewButton.backgroundColor = [UIColor colorWithRed: 157.0/255.0 green: 172.0/255.0 blue: 105.0/255.0 alpha: 1.0];
        }
        return cell;
    }
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    return cell;
}


@end
