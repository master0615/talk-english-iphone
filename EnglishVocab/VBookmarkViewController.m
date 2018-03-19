//
//  BookmarkViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 4/8/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VBookmarkViewController.h"
#import "VAppInfo.h"
#import "VWordSummary.h"
#import "VLessonViewController.h"
#import "VPurchaseInfo.h"
#import "VAnalytics.h"
#import "VEnv.h"

#define MIN_INTERVAL 60
#define MIN_RETRY_INTERVAL 120

@interface VBookmarkViewController () <UITableViewDelegate, UITableViewDataSource>{
    NSTimeInterval _lastTimeAdShown;
    NSTimeInterval _lastTimeLoadTried;
    VWordSummary* _w;
    NSMutableArray* _words;
}
@property (weak, nonatomic) IBOutlet UITableView *tblBookmark;
@property (weak, nonatomic) IBOutlet UILabel *lbBookmark1;
@property (weak, nonatomic) IBOutlet UILabel *lbBookmark2;

@end

@implementation VBookmarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lbBookmark1.text = [[VAppInfo sharedInfo] localizedStringForKey:@"bookmark_03"];
    _lbBookmark2.text = [[VAppInfo sharedInfo] localizedStringForKey:@"bookmark_04"];
    [VAnalytics sendScreenName:@"Bookmark Screen"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) loadData{
    _words = [VWordSummary loadBookmarkList];
    if(_words.count > 0){
        self.tblBookmark.hidden = NO;
        [self.tblBookmark reloadData];
        self.lbBookmark1.hidden = YES;
        self.lbBookmark2.hidden = YES;
    }else{
        self.tblBookmark.hidden = YES;
        self.lbBookmark1.hidden = NO;
        self.lbBookmark2.hidden = NO;
    }
}
- (IBAction)onTapCell:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblBookmark];
    NSIndexPath *indexPath = [self.tblBookmark indexPathForRowAtPoint:buttonPosition];
    _w = _words[indexPath.row];

    VLessonViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VLessonViewController"];
    vc.word = _w.wordText;
    vc.list_type = 2;
    [self.navigationController pushViewController:vc animated:YES];
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
    
    btnCell.enabled = enabled;
    
    if(enabled){
        lbWord.textColor = [UIColor colorWithRed:63.0f/255.0f green:134.0f/255.0f blue:186.0f/255.0f alpha:1.0f];
        lbPart.textColor = [UIColor colorWithRed:126.0f/255.0f green:126.0f/255.0f blue:126.0f/255.0f alpha:1.0f];
    }else{
        lbWord.textColor = [UIColor colorWithRed:126.0f/255.0f green:126.0f/255.0f blue:126.0f/255.0f alpha:1.0f];
        lbPart.textColor = [UIColor colorWithRed:126.0f/255.0f green:126.0f/255.0f blue:126.0f/255.0f alpha:1.0f];
    }
    
    if (indexPath.row % 2 == 0){
        cell.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    }else{
        cell.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:231.0f/255.0f blue:231.0f/255.0f alpha:1.0f];
    }
    //NSLog(@"%@ %@", w.wordText, [w partListString]);
    return cell;
}


@end
