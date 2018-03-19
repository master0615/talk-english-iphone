//
//  PurchaseViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/19/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PurchaseViewController.h"
#import "InAppPurchaseController.h"
#import "ECCategoryManager.h"
#import "Analytics.h"
#import "UIViewController+SlideMenu.h"


@interface PurchaseViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblPurchase;

@end

@implementation PurchaseViewController

- (void)successInAppPurchase:(NSNotification*)ntf {
    NSString* productId = [ntf.userInfo objectForKey:IAPHelperProductPurchasedNotification];
    if (productId.length > 0) {
        if ([productId isEqualToString:kIAPItemProductId1499]) {
            [ECCategoryManager sharedInstance].isPurchased |= 1;
            [[NSUserDefaults standardUserDefaults] setValue:@([ECCategoryManager sharedInstance].isPurchased) forKey:@"isPurchased"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tblPurchase reloadData];
            return;
//        }else if ([productId isEqualToString:kIAPItemProductId299]) {
//            [ECCategoryManager sharedInstance].isPurchased |= 2;
//            [[NSUserDefaults standardUserDefaults] setValue:@([ECCategoryManager sharedInstance].isPurchased) forKey:@"isPurchased"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [self.tblPurchase reloadData];
        }else if ([productId isEqualToString:kIAPItemProductId3999]) {
            [ECCategoryManager sharedInstance].isPurchased |= 4;
            [[NSUserDefaults standardUserDefaults] setValue:@([ECCategoryManager sharedInstance].isPurchased) forKey:@"isPurchased"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tblPurchase reloadData];
        }else if ([productId isEqualToString:kIAPItemProductId_offline]) {
            [ECCategoryManager sharedInstance].isPurchasedOffline = 1;
            [[NSUserDefaults standardUserDefaults] setValue:@([ECCategoryManager sharedInstance].isPurchasedOffline) forKey:@"isPurchasedOffline"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tblPurchase reloadData];
        }      
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarItem];
    
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(-130,0,200,32)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 180, 32)];
    lb.textAlignment = NSTextAlignmentCenter;
    [iv addSubview:lb];
    lb.text = @"English Speaking Practice";
    lb.textColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 13, 24)];
    [btn setBackgroundImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [btn addTarget:self
            action:@selector(myAction)
  forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnBig = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 60, 34)];
    [btnBig addTarget:self
               action:@selector(myAction)
     forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:btnBig];
    
    [iv addSubview:lb];
    [iv addSubview:btn];
    self.navigationItem.titleView = iv;
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
    [Analytics sendScreenName:@"Purchase Screen"];
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
        int isPurchased = [ECCategoryManager sharedInstance].isPurchased;
        isPurchased = isPurchased & ( 1 << kPurchaseItemIndex);
        if (isPurchased > 0) {
            return;
        }
        if (![InAppPurchaseController canPurchaseItems]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"You couldn't purchase items in your device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        
        
        InAppPurchaseController* iap = [InAppPurchaseController sharedController];
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
        if (![InAppPurchaseController canPurchaseItems]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"You couldn't purchase items in your device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        InAppPurchaseController* iap = [InAppPurchaseController sharedController];
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
        int isPurchased = [ECCategoryManager sharedInstance].isPurchased;
        isPurchased = isPurchased & ( 1 << kPurchaseItemIndex);
        if (isPurchased > 0){
            lbPrice.text = @"Purchased";
            viewButton.backgroundColor = [UIColor lightGrayColor];
        } else {
            lbPrice.text = @"$4.99";
            viewButton.backgroundColor = [UIColor colorWithRed:103.0f/255.0f green:191.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
        }
        
        return cell;
//    }else if (indexPath.row == 2) {
//        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
//        UILabel* lbTitle = [cell viewWithTag:1250];
//        lbTitle.text = @"Purchase:\nRemove ads & Donate $1.00";
//        UILabel* lbPrice = [cell viewWithTag:1251];
//        UIView* viewButton = [cell viewWithTag:1255];
//        NSInteger kPurchaseItemIndex = indexPath.row - 1;
//        int isPurchased = [ECCategoryManager sharedInstance].isPurchased;
//        isPurchased = isPurchased & ( 1 << kPurchaseItemIndex);
//        if (isPurchased > 0){
//            lbPrice.text = @"Purchased";
//            viewButton.backgroundColor = [UIColor lightGrayColor];
//        } else {
//            lbPrice.text = @"$2.99";
//            viewButton.backgroundColor = [UIColor colorWithRed:103.0f/255.0f green:191.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
//        }
//        return cell;
    }else if (indexPath.row == 3) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = @"Purchase:\nRemove ads & Donate $5.00";
        UILabel* lbPrice = [cell viewWithTag:1251];
        UIView* viewButton = [cell viewWithTag:1255];
        NSInteger kPurchaseItemIndex = indexPath.row - 1;
        int isPurchased = [ECCategoryManager sharedInstance].isPurchased;
        isPurchased = isPurchased & ( 1 << kPurchaseItemIndex);
        if (isPurchased > 0){
            lbPrice.text = @"Purchased";
            viewButton.backgroundColor = [UIColor lightGrayColor];
        } else {
            lbPrice.text = @"$9.99";
            viewButton.backgroundColor = [UIColor colorWithRed:103.0f/255.0f green:191.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
        }
        return cell;
    }else if (indexPath.row == 4) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = @"Restore Purchase";
        UILabel* lbPrice = [cell viewWithTag:1251];
        UIView* viewButton = [cell viewWithTag:1255];
        if ([ECCategoryManager sharedInstance].isPurchased > 100){
            lbPrice.text = @"Purchased";
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
