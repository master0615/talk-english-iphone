//
//  PurchaseViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/19/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "SPurchaseViewController.h"
#import "SInAppPurchaseController.h"
#import "InAppPurchaseController.h"
#import "SAnalytics.h"
#import "UIColor+TalkEnglish.h"


@interface SPurchaseViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblPurchase;

@end

@implementation SPurchaseViewController

- (void)successInAppPurchase:(NSNotification*)ntf {
    NSString* productId = [ntf.userInfo objectForKey:IAPHelperProductPurchasedNotification];
    if (productId.length > 0) {
        if ([productId isEqualToString:kIAPItemProductId299]) {
            [SInAppPurchaseController sharedController].isPurchased |= 1;
            [[NSUserDefaults standardUserDefaults] setValue:@([SInAppPurchaseController sharedController].isPurchased) forKey:@"isPurchased"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tblPurchase reloadData];
            return;
        }else if ([productId isEqualToString:kIAPItemProductId499]) {
            [SInAppPurchaseController sharedController].isPurchased |= 2;
            [[NSUserDefaults standardUserDefaults] setValue:@([SInAppPurchaseController sharedController].isPurchased) forKey:@"isPurchased"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tblPurchase reloadData];
        }
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"TalkEnglish Offline";
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
    [SAnalytics sendScreenName:@"Purchase Screen"];
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
        NSInteger kPurchaseItemIndex = indexPath.row - 1;
        int isPurchased = [SInAppPurchaseController sharedController].isPurchased;
        isPurchased = isPurchased & ( 1 << kPurchaseItemIndex);
        if (isPurchased > 0) {
            return;
        }
        if (![SInAppPurchaseController canPurchaseItems]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"You couldn't purchase items in your device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        
        
        SInAppPurchaseController* iap = [SInAppPurchaseController sharedController];
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
        if (![SInAppPurchaseController canPurchaseItems]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"You couldn't purchase items in your device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        SInAppPurchaseController* iap = [SInAppPurchaseController sharedController];
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
        int isPurchased = [SInAppPurchaseController sharedController].isPurchased;
        isPurchased = isPurchased & ( 1 << kPurchaseItemIndex);
        if (isPurchased > 0){
            lbPrice.text = @"Purchased";
            viewButton.backgroundColor = [UIColor lightGrayColor];
        } else {
            lbPrice.text = @"$2.99";
            viewButton.backgroundColor = [UIColor talkEnglishNavigationBar];//[UIColor colorWithRed:103.0f/255.0f green:191.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
        }
        
        return cell;
    }else if (indexPath.row == 2) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = @"Purchase:\nRemove ads & Donate $2.00";
        UILabel* lbPrice = [cell viewWithTag:1251];
        UIView* viewButton = [cell viewWithTag:1255];
        NSInteger kPurchaseItemIndex = indexPath.row - 1;
        int isPurchased = [SInAppPurchaseController sharedController].isPurchased;
        isPurchased = isPurchased & ( 1 << kPurchaseItemIndex);
        if (isPurchased > 0){
            lbPrice.text = @"Purchased";
            viewButton.backgroundColor = [UIColor lightGrayColor];
        } else {
            lbPrice.text = @"$4.99";
            viewButton.backgroundColor = [UIColor talkEnglishNavigationBar];//[UIColor colorWithRed:103.0f/255.0f green:191.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
        }
        return cell;
    }else if (indexPath.row == 3) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellBuy"];
        UILabel* lbTitle = [cell viewWithTag:1250];
        lbTitle.text = @"Restore Purchase";
        UILabel* lbPrice = [cell viewWithTag:1251];
        UIView* viewButton = [cell viewWithTag:1255];
        if ([SInAppPurchaseController sharedController].isPurchased > 100){
            lbPrice.text = @"Purchased";
            viewButton.backgroundColor = [UIColor lightGrayColor];
        } else {
            lbPrice.text = @"Restore";
            viewButton.backgroundColor = [UIColor talkEnglishNavigationBar];//[UIColor colorWithRed:103.0f/255.0f green:191.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
        }
        return cell;
    }
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    return cell;
}


@end
