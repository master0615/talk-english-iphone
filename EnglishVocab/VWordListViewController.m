//
//  VWordListViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 4/1/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VWordListViewController.h"
#import "VWordSummary.h"
#import "VLessonViewController.h"
#import "VAppInfo.h"
#import "VPurchaseInfo.h"
#import "VPurchaseViewController.h"
#import "VAnalytics.h"
#import "VEnv.h"

#define MIN_INTERVAL 60
#define MIN_RETRY_INTERVAL 120

@interface VWordListViewController () <UITableViewDelegate, UITableViewDataSource>{
    NSTimeInterval _lastTimeAdShown;
    NSTimeInterval _lastTimeLoadTried;
    VWordSummary* _w;
}
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UITableView *tblWordList;
@property (nonatomic, strong) NSMutableArray* list;
@end

@implementation VWordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _list = [VWordSummary loadList:_mSection];
    [self.navigationItem setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"main_page_01"]];
    NSArray *titleArray = @[ @"Book 1 : 1 - 200",
                                    @"Book 2 : 201 - 400",
                                    @"Book 3 : 401 - 600",
                                    @"Book 4 : 601 - 800",
                                    @"Book 5 : 801 - 1000",
                                    @"Book 6 : 1001 - 1200",
                                    @"Book 7 : 1201 - 1400",
                                    @"Book 8 : 1401 - 1600",
                                    @"Book 9 : 1601 - 1800",
                                    @"Book 10 : 1801 - 2000",
                                    @"Book 11 : 2001 - 2248"];
    [_lbTitle setText:titleArray[_mSection - 1]];
    
    
    NSLog(@"%d", _list.count);
    [VAnalytics sendScreenName:@"Section Screen"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onPurchase:(id)sender {
    VPurchaseViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VPurchaseViewController"];
    vc.section = _mSection;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tblWordList reloadData];
//    NSInteger isPurchased = [[VPurchaseInfo sharedInfo].purchased[_mSection] integerValue];
//    if([[VPurchaseInfo sharedInfo].purchased[0] integerValue] == 1){
//        isPurchased = 1;
//    }
//    if (isPurchased == 1) {
//        _viewPurchase.hidden = YES;
//    }else{
//        _viewPurchase.hidden = NO;
//    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"show"]){
        VLessonViewController* vc = segue.destinationViewController;
        vc.word = sender;
        vc.mSection = _mSection;
        vc.list_type = 0;
    }
}

- (IBAction)onWord:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblWordList];
    NSIndexPath *indexPath = [self.tblWordList indexPathForRowAtPoint:buttonPosition];
    NSInteger index = (indexPath.row - 1) * 2 + [sender tag] - 1253;
    
    _w = _list[index];

    [self performSegueWithIdentifier:@"show" sender:_w.wordText];
    
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list.count / 2 + 2;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 || indexPath.row == _list.count / 2 + 1){
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            return 16;
        return 10;
    }
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        return 56;
    return 50;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 || indexPath.row == _list.count / 2 + 1){
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"blank" forIndexPath:indexPath];
        return cell;
    }
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"word" forIndexPath:indexPath];
    NSInteger index = indexPath.row - 1;
    VWordSummary* w1 = _list[index * 2];
    VWordSummary* w2 = _list[index * 2 + 1];
    UILabel* lb1 = [cell viewWithTag:1251];
    UILabel* lb2 = [cell viewWithTag:1252];
    NSString* strNumber1 = [NSString stringWithFormat:@"%d. ", (_mSection - 1) * 200 + index * 2 + 1];
    NSString* strNumber2 = [NSString stringWithFormat:@"%d. ", (_mSection - 1) * 200 + index * 2 + 2];
    NSString* strWord1 = [NSString stringWithFormat:@"%@%@ %@", strNumber1, w1.wordText, w1.partListString];
    NSString* strWord2 = [NSString stringWithFormat:@"%@%@ %@", strNumber2, w2.wordText, w2.partListString];
    [lb1 setText:strWord1];
    [lb2 setText:strWord2];
    
    UIButton* btn1 = [cell viewWithTag:1253];
    UIButton* btn2 = [cell viewWithTag:1254];
    
//    NSInteger isPurchased1 = [[VPurchaseInfo sharedInfo].purchased[[w1 section]] integerValue];
//    if([[VPurchaseInfo sharedInfo].purchased[0] integerValue] == 1){
//        isPurchased1 = 1;
//    }
//    
//    NSInteger isPurchased2 = [[VPurchaseInfo sharedInfo].purchased[[w2 section]] integerValue];
//    if([[VPurchaseInfo sharedInfo].purchased[0] integerValue] == 1){
//        isPurchased2 = 1;
//    }
    
    
    //if([w1 isUnlockedByDefault] || isPurchased1){
    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithAttributedString: lb1.attributedText];
    [text1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:63.0f/255.0f green:134.0f/255.0f blue:186.0f/255.0f alpha:1.0f] range:NSMakeRange(strNumber1.length, w1.wordText.length)];
    UIFont * fontD = [UIFont fontWithName:@"HelveticaNeue" size:lb1.font.pointSize + 2];
    [text1 addAttribute:NSFontAttributeName value:fontD range:NSMakeRange(strNumber1.length, w1.wordText.length)];
    [lb1 setAttributedText: text1];
    btn1.enabled = YES;
//    }else{
//        lb1.textColor = [UIColor colorWithRed:126.0f/255.0f green:126.0f/255.0f blue:126.0f/255.0f alpha:1.0f];
//        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithAttributedString: lb1.attributedText];
//        UIFont * fontD = [UIFont fontWithName:@"HelveticaNeue" size:lb1.font.pointSize + 2];
//        [text1 addAttribute:NSFontAttributeName value:fontD range:NSMakeRange(strNumber1.length, w1.wordText.length)];
//        [lb1 setAttributedText: text1];
//        btn1.enabled = NO;
//    }
    
    //if([w2 isUnlockedByDefault] || isPurchased2){
        NSMutableAttributedString *text2 = [[NSMutableAttributedString alloc] initWithAttributedString: lb2.attributedText];
        [text2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:63.0f/255.0f green:134.0f/255.0f blue:186.0f/255.0f alpha:1.0f] range:NSMakeRange(strNumber2.length, w2.wordText.length)];
        //UIFont * fontD = [UIFont fontWithName:@"HelveticaNeue" size:lb2.font.pointSize + 2];
        [text2 addAttribute:NSFontAttributeName value:fontD range:NSMakeRange(strNumber2.length, w2.wordText.length)];
        [lb2 setAttributedText: text2];
        btn2.enabled = YES;
//    }else{
//        NSMutableAttributedString *text2 = [[NSMutableAttributedString alloc] initWithAttributedString: lb2.attributedText];
//        lb2.textColor = [UIColor colorWithRed:126.0f/255.0f green:126.0f/255.0f blue:126.0f/255.0f alpha:1.0f];
//        UIFont * fontD = [UIFont fontWithName:@"HelveticaNeue" size:lb2.font.pointSize + 2];
//        [text2 addAttribute:NSFontAttributeName value:fontD range:NSMakeRange(strNumber2.length, w2.wordText.length)];
//        [lb2 setAttributedText: text2];
//        btn2.enabled = NO;
//    }
    
    
    //NSLog(@"%@ %@", w.wordText, [w partListString]);
    return cell;
}


@end
