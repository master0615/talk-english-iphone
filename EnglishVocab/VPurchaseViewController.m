//
//  VPurchaseViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 4/14/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VPurchaseViewController.h"
#import "VInAppPurchaseController.h"
#import "InAppPurchaseController.h"
#import "VPurchaseInfo.h"
#import "VAppInfo.h"
#import "VAnalytics.h"
@interface VPurchaseViewController (){
    NSMutableArray* _BOOK_NUMBER_RES_ID;
    NSMutableArray* _BOOK_RANGE_RES_ID;
    NSMutableArray* _BOOK_BG_RES_ID;
}
@property (weak, nonatomic) IBOutlet UILabel *lbOfflineDesc;
@property (weak, nonatomic) IBOutlet UITableView *tblPurchase;
@end

@implementation VPurchaseViewController

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
    
    [self.navigationItem setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"purchase_offline"]];
    // Do any additional setup after loading the view.
    _BOOK_NUMBER_RES_ID = [[NSMutableArray alloc] init];
    [_BOOK_NUMBER_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_01"]];
    [_BOOK_NUMBER_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_02"]];
    [_BOOK_NUMBER_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_03"]];
    [_BOOK_NUMBER_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_04"]];
    [_BOOK_NUMBER_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_05"]];
    [_BOOK_NUMBER_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_06"]];
    [_BOOK_NUMBER_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_07"]];
    [_BOOK_NUMBER_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_08"]];
    [_BOOK_NUMBER_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_09"]];
    [_BOOK_NUMBER_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_10"]];
    [_BOOK_NUMBER_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_11"]];
    
    _BOOK_RANGE_RES_ID = [[NSMutableArray alloc] init];
    [_BOOK_RANGE_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_lesson_01"]];
    [_BOOK_RANGE_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_lesson_02"]];
    [_BOOK_RANGE_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_lesson_03"]];
    [_BOOK_RANGE_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_lesson_04"]];
    [_BOOK_RANGE_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_lesson_05"]];
    [_BOOK_RANGE_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_lesson_06"]];
    [_BOOK_RANGE_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_lesson_07"]];
    [_BOOK_RANGE_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_lesson_08"]];
    [_BOOK_RANGE_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_lesson_09"]];
    [_BOOK_RANGE_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_lesson_10"]];
    [_BOOK_RANGE_RES_ID addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_lesson_11"]];
    
    
    _BOOK_BG_RES_ID = [[NSMutableArray alloc] init];
    [_BOOK_BG_RES_ID addObject:@"bg_section01"];
    [_BOOK_BG_RES_ID addObject:@"bg_section02"];
    [_BOOK_BG_RES_ID addObject:@"bg_section03"];
    [_BOOK_BG_RES_ID addObject:@"bg_section04"];
    [_BOOK_BG_RES_ID addObject:@"bg_section05"];
    [_BOOK_BG_RES_ID addObject:@"bg_section06"];
    [_BOOK_BG_RES_ID addObject:@"bg_section07"];
    [_BOOK_BG_RES_ID addObject:@"bg_section08"];
    [_BOOK_BG_RES_ID addObject:@"bg_section09"];
    [_BOOK_BG_RES_ID addObject:@"bg_section10"];
    [_BOOK_BG_RES_ID addObject:@"bg_section11"];
    
    self.lbOfflineDesc.text = [[VAppInfo sharedInfo] localizedStringForKey:@"purchase_desc"];
    if(_section == 0){
        [VAnalytics sendScreenName:@"Pruchase All Screen"];
    }else{
        [VAnalytics sendScreenName:[NSString stringWithFormat:@"Purchase %d Screen", _section]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successInAppPurchase:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductPurchasedNotification object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onCart:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblPurchase];
    NSIndexPath *indexPath = [self.tblPurchase indexPathForRowAtPoint:buttonPosition];
    if (_section == 0){
        if (indexPath.row == 0) {
            if (![VInAppPurchaseController canPurchaseItems]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"You couldn't purchase items in your device."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            NSInteger kPurchaseItemIndex = 0;
            
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
        }else if(indexPath.row == 1){
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
        }else{
            if (![VInAppPurchaseController canPurchaseItems]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"You couldn't purchase items in your device."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            NSInteger kPurchaseItemIndex = indexPath.row - 1;
            
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
        }
    }else{
        if (indexPath.row == 0) {
            if (![VInAppPurchaseController canPurchaseItems]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"You couldn't purchase items in your device."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            NSInteger kPurchaseItemIndex = _section;
            
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
        }else if(indexPath.row == 2){
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
        }else{
            if (![VInAppPurchaseController canPurchaseItems]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"You couldn't purchase items in your device."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            NSInteger kPurchaseItemIndex = 0;
            
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
        }
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_section == 0) {
        return 13;
    }
    return 3;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        return 220;
    return 120;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_section == 0) {
        if(indexPath.row == 0){
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"allcell" forIndexPath:indexPath];
            
            UILabel* lbBuy = [cell viewWithTag:1250];
            lbBuy.text = [[VAppInfo sharedInfo] localizedStringForKey:@"purchase_offline"];
            
            UILabel* lbItemName = [cell viewWithTag:1251];
            lbItemName.text = [[VAppInfo sharedInfo] localizedStringForKey:@"purchase_02"];
            
            UIImageView* imgBook = [cell viewWithTag:1253];
            imgBook.image = [UIImage imageNamed:@"all_books"];
            
            UILabel* lbPrice = [cell viewWithTag:1255];
            UIButton* btnPurchase = [cell viewWithTag:1256];
            
            NSInteger isPurchased = [[VPurchaseInfo sharedInfo].purchased[0] integerValue];
            UIView* viewBg = [cell viewWithTag:2000];
            if(isPurchased == 0){
                lbPrice.text = @"$6.99";
                btnPurchase.enabled = YES;
                viewBg.backgroundColor = [UIColor colorWithRed:103.0f/255.0f green:191.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
            }else{
                lbPrice.text = [[VAppInfo sharedInfo] localizedStringForKey:@"purchase_03"];
                btnPurchase.enabled = NO;
                viewBg.backgroundColor = [UIColor lightGrayColor];
            }
           
            return cell;
        }else if (indexPath.row == 1){
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"restore" forIndexPath:indexPath];
            UILabel *lb = [cell viewWithTag:1251];
            lb.text = [[VAppInfo sharedInfo] localizedStringForKey:@"restore_purchase"];
            return cell;
        }else{
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            
            
            
            UILabel* lbBuy = [cell viewWithTag:1250];
            lbBuy.text = [[VAppInfo sharedInfo] localizedStringForKey:@"purchase_offline"];
            
            UILabel* lbItemName = [cell viewWithTag:1251];
            lbItemName.text = _BOOK_NUMBER_RES_ID[indexPath.row - 2];
            
            UIImageView* imgBook = [cell viewWithTag:1253];
            imgBook.image = [UIImage imageNamed:_BOOK_BG_RES_ID[indexPath.row - 2]];
            
            UILabel* lbPrice = [cell viewWithTag:1255];
            UIButton* btnPurchase = [cell viewWithTag:1256];
            
            NSInteger isPurchased = [[VPurchaseInfo sharedInfo].purchased[indexPath.row - 1] integerValue];
            if([[VPurchaseInfo sharedInfo].purchased[0] integerValue] == 1){
                isPurchased = 1;
            }
            
            UIView* viewBg = [cell viewWithTag:2000];
            if(isPurchased == 0){
                lbPrice.text = @"$0.99";
                btnPurchase.enabled = YES;
                viewBg.backgroundColor = [UIColor colorWithRed:103.0f/255.0f green:191.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
            }else{
                lbPrice.text = [[VAppInfo sharedInfo] localizedStringForKey:@"purchase_03"];
                btnPurchase.enabled = NO;
                viewBg.backgroundColor = [UIColor lightGrayColor];
            }
            
            UILabel* lbTitleRange = [cell viewWithTag:1260];
            UILabel* lbTitleNumber = [cell viewWithTag:1261];
            
            lbTitleRange.text = _BOOK_RANGE_RES_ID[indexPath.row - 2];
            lbTitleNumber.text = _BOOK_NUMBER_RES_ID[indexPath.row - 2];
            return cell;
        }
    }else{
        if(indexPath.row == 0){
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            
            
            
            UILabel* lbBuy = [cell viewWithTag:1250];
            lbBuy.text = [[VAppInfo sharedInfo] localizedStringForKey:@"purchase_offline"];
            
            UILabel* lbItemName = [cell viewWithTag:1251];
            lbItemName.text = _BOOK_NUMBER_RES_ID[_section - 1];
            
            UIImageView* imgBook = [cell viewWithTag:1253];
            imgBook.image = [UIImage imageNamed:_BOOK_BG_RES_ID[_section- 1]];
            
            UILabel* lbPrice = [cell viewWithTag:1255];
            UIButton* btnPurchase = [cell viewWithTag:1256];
            
            NSInteger isPurchased = [[VPurchaseInfo sharedInfo].purchased[_section] integerValue];
            if([[VPurchaseInfo sharedInfo].purchased[0] integerValue] == 1){
                isPurchased = 1;
            }
            
            UIView* viewBg = [cell viewWithTag:2000];
            if(isPurchased == 0){
                lbPrice.text = @"$0.99";
                btnPurchase.enabled = YES;
                viewBg.backgroundColor = [UIColor colorWithRed:103.0f/255.0f green:191.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
            }else{
                lbPrice.text = [[VAppInfo sharedInfo] localizedStringForKey:@"purchase_03"];
                btnPurchase.enabled = NO;
                viewBg.backgroundColor = [UIColor lightGrayColor];
            }
            
            UILabel* lbTitleRange = [cell viewWithTag:1260];
            UILabel* lbTitleNumber = [cell viewWithTag:1261];
            
            lbTitleRange.text = _BOOK_RANGE_RES_ID[_section - 1];
            lbTitleNumber.text = _BOOK_NUMBER_RES_ID[_section - 1];
            return cell;
        }else if(indexPath.row == 1){
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"allcell" forIndexPath:indexPath];
            
            UILabel* lbBuy = [cell viewWithTag:1250];
            lbBuy.text = [[VAppInfo sharedInfo] localizedStringForKey:@"purchase_offline"];
            
            UILabel* lbItemName = [cell viewWithTag:1251];
            lbItemName.text = [[VAppInfo sharedInfo] localizedStringForKey:@"purchase_02"];
            
            UIImageView* imgBook = [cell viewWithTag:1253];
            imgBook.image = [UIImage imageNamed:@"all_books"];
            
            UILabel* lbPrice = [cell viewWithTag:1255];
            UIButton* btnPurchase = [cell viewWithTag:1256];
            
            NSInteger isPurchased = [[VPurchaseInfo sharedInfo].purchased[0] integerValue];
            UIView* viewBg = [cell viewWithTag:2000];
            if(isPurchased == 0){
                lbPrice.text = @"$6.99";
                btnPurchase.enabled = YES;
                viewBg.backgroundColor = [UIColor colorWithRed:103.0f/255.0f green:191.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
            }else{
                lbPrice.text = [[VAppInfo sharedInfo] localizedStringForKey:@"purchase_03"];
                btnPurchase.enabled = NO;
                viewBg.backgroundColor = [UIColor lightGrayColor];
            }
            
            return cell;
        }else{
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"restore" forIndexPath:indexPath];
            return cell;
        }
    }
}

@end
