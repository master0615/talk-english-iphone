//
//  VWordSearchViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 4/11/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VWordSearchViewController.h"
#import "VAppInfo.h"
#import "VWordSummary.h"
#import "VPurchaseInfo.h"
#import "VLessonViewController.h"
#import "VAnalytics.h"
#import "VEnv.h"

#define MIN_INTERVAL 60
#define MIN_RETRY_INTERVAL 120

@interface VWordSearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSTimeInterval _lastTimeAdShown;
    NSTimeInterval _lastTimeLoadTried;
    VWordSummary* _w;
    NSMutableArray* _words;
    NSInteger _SelectedIndex;
}
@property (weak, nonatomic) IBOutlet UITextField *txtSeach;
@property (weak, nonatomic) IBOutlet UITableView *tblWords;

@end

@implementation VWordSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _txtSeach.text = _strSearchText;
    _SelectedIndex = -1;
    [self.navigationItem setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"main_page_01"]];
    [self loadData];
    [self search:self.strSearchText];
    [VAnalytics sendScreenName:@"Search Screen"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onChanged:(id)sender {
    [self search:self.txtSeach.text];
}

- (void)search:(NSString*)keyword{
    NSInteger index = [self setSelected:keyword];
    if (index >= 0) {
        NSIndexPath* path = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tblWords scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
- (NSInteger) setSelected:(NSString*)keyword{
    if (keyword.length == 0) {
        _SelectedIndex = -1;
    }else{
        _SelectedIndex = [self findFirst:keyword];
        if (_SelectedIndex >= 0 && _SelectedIndex < _words.count) {
            VWordSummary* w = _words[_SelectedIndex];
            if(![w.wordText hasPrefix:keyword]){
                _SelectedIndex = -1;
            }
        }
    }
    [self.tblWords reloadData];
    return _SelectedIndex;
}

- (NSInteger) findFirst:(NSString*)prefix{
    NSInteger low = 0;
    NSInteger high = _words.count - 1;
    while (low <= high) {
        NSInteger mid = (low + high) / 2;
        VWordSummary* w = _words[mid];
        if ([w.wordText hasPrefix:prefix]) {
            VWordSummary* w1;
            if(mid != 0)
                w1 = _words[mid - 1];
            if (mid == 0 || ![w1.wordText hasPrefix:prefix]) {
                return mid;
            }else{
                high = mid - 1;
            }
        }else if([prefix compare:w.wordText] > 0){
            low = mid + 1;
        }else{
            high = mid - 1;
        }
    }
    return low;
}
- (IBAction)onTapCell:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblWords];
    NSIndexPath *indexPath = [self.tblWords indexPathForRowAtPoint:buttonPosition];
    _w = _words[indexPath.row];

    VLessonViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VLessonViewController"];
    vc.word = _w.wordText;
    vc.list_type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) loadData{
    _words = [VWordSummary loadList];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _words.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"word" forIndexPath:indexPath];
    VWordSummary* w = _words[indexPath.row];
    NSInteger isPurchased = [[VPurchaseInfo sharedInfo].purchased[[w section]] integerValue];
    if([[VPurchaseInfo sharedInfo].purchased[0] integerValue] == 1){
        isPurchased = 1;
    }
    BOOL enabled = YES;//[w isUnlockedByDefault] || isPurchased;
    UILabel *lbWord = [cell viewWithTag:1250];
    UILabel *lbPart = [cell viewWithTag:1251];
    UIButton* btnCell = [cell viewWithTag:1252];
    lbWord.text = w.wordText;
    lbPart.text = [w partListString];
    
    //lbWord.enabled = enabled;
    //lbPart.enabled = enabled;
    btnCell.enabled = enabled;
    if(enabled){
        lbWord.textColor = [UIColor colorWithRed:63.0f/255.0f green:134.0f/255.0f blue:186.0f/255.0f alpha:1.0f];
        lbPart.textColor = [UIColor colorWithRed:126.0f/255.0f green:126.0f/255.0f blue:126.0f/255.0f alpha:1.0f];
    }else{
        lbWord.textColor = [UIColor colorWithRed:126.0f/255.0f green:126.0f/255.0f blue:126.0f/255.0f alpha:1.0f];
        lbPart.textColor = [UIColor colorWithRed:126.0f/255.0f green:126.0f/255.0f blue:126.0f/255.0f alpha:1.0f];
    }
    
    if (_SelectedIndex == indexPath.row) {
        cell.backgroundColor = [UIColor colorWithRed:105.0f/255.0f green:163.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    }else if (indexPath.row % 2 == 0){
        cell.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    }else{
        cell.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:231.0f/255.0f blue:231.0f/255.0f alpha:1.0f];
    }
    //NSLog(@"%@ %@", w.wordText, [w partListString]);
    return cell;
}


@end
