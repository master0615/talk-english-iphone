//
//  QuizLevelListViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 4/1/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VQuizLevelListViewController.h"
#import "VLevel.h"
#import "VAppInfo.h"
#import "VPurchaseInfo.h"
#import "VQuizViewController.h"
#import "VAnalytics.h"
#import "VEnv.h"

#define MIN_INTERVAL 60
#define MIN_RETRY_INTERVAL 120

@interface VQuizLevelListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    VLevel *_currentLevel;
    NSTimeInterval _lastTimeAdShown;
    NSTimeInterval _lastTimeLoadTried;
    NSInteger _section;
    NSInteger _level;
    NSMutableArray* _arrayExpanded;
    NSMutableArray* _SECTION_TITLE_RES;
    NSMutableArray* _LEVEL_TITLE_RES;
    NSMutableArray* _LEVEL_DESCR_RES;
    NSMutableArray* _SECTION_GROUP_NAME_RES;
    NSMutableArray* _SECTION_GROUP_TITLE_RES;
}
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UITableView *tblQuizLevel;

@end

@implementation VQuizLevelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _SECTION_TITLE_RES = [[NSMutableArray alloc] init];
    [_SECTION_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_01"]];
    [_SECTION_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_02"]];
    [_SECTION_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_03"]];
    [_SECTION_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_04"]];
    [_SECTION_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_05"]];
    [_SECTION_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_06"]];
    [_SECTION_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_07"]];
    [_SECTION_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_08"]];
    [_SECTION_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_09"]];
    [_SECTION_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_10"]];
    [_SECTION_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_11"]];
    _SECTION_GROUP_NAME_RES = _SECTION_TITLE_RES;
    
    _LEVEL_TITLE_RES = [[NSMutableArray alloc] init];
    [_LEVEL_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_27"]];
    [_LEVEL_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_28"]];
    [_LEVEL_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_29"]];
    [_LEVEL_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_30"]];
    [_LEVEL_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_31"]];
    [_LEVEL_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_32"]];
    [_LEVEL_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_33"]];
    [_LEVEL_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_34"]];
    [_LEVEL_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_35"]];
    [_LEVEL_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_36"]];
    
    
    _LEVEL_DESCR_RES = [[NSMutableArray alloc] init];
    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_17"]];
    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_18"]];
    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_19"]];
    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_20"]];
    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_21"]];
    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_22"]];
    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_23"]];
    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_24"]];
    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_25"]];
    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_26"]];
    
    
    _SECTION_GROUP_TITLE_RES = [[NSMutableArray alloc] init];
    [_SECTION_GROUP_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_06"]];
    [_SECTION_GROUP_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_07"]];
    [_SECTION_GROUP_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_08"]];
    [_SECTION_GROUP_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_09"]];
    [_SECTION_GROUP_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_10"]];
    [_SECTION_GROUP_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_11"]];
    [_SECTION_GROUP_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_12"]];
    [_SECTION_GROUP_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_13"]];
    [_SECTION_GROUP_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_14"]];
    [_SECTION_GROUP_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_15"]];
    [_SECTION_GROUP_TITLE_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_16"]];
                           
    
    [self.navigationItem setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_01"]];
    
    [VAnalytics sendScreenName:@"Quiz List Screen"];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _currentLevel = [VLevel getCurrentLevel];
    _lbTitle.text = [NSString stringWithFormat:@"%@: %@ %@", [[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_02"], _SECTION_TITLE_RES[_currentLevel.section - 1], _LEVEL_TITLE_RES[_currentLevel.level - 1]];
    _arrayExpanded = [[NSMutableArray alloc] init];
    for (int i = 0; i < 11; i++) {
        [_arrayExpanded addObject:@(0)];
    }
    _arrayExpanded[_currentLevel.section - 1] = @(1);
    [self.tblQuizLevel reloadData];
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
- (IBAction)onBookItem:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblQuizLevel];
    NSIndexPath *indexPath = [self.tblQuizLevel indexPathForRowAtPoint:buttonPosition];
    NSInteger isExpanded = [_arrayExpanded[indexPath.section / 2] integerValue];
    if (isExpanded == 0) {
        _arrayExpanded[indexPath.section / 2] = @(1);
        NSMutableArray* cells = [[NSMutableArray alloc] init];
        for (int i = 1; i < 11; i++) {
            [cells addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
        }
        [self.tblQuizLevel beginUpdates];
        [self.tblQuizLevel insertRowsAtIndexPaths:cells withRowAnimation:UITableViewRowAnimationNone];
        [self.tblQuizLevel endUpdates];
        [self.tblQuizLevel scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        _arrayExpanded[indexPath.section / 2] = @(0);
        NSMutableArray* cells = [[NSMutableArray alloc] init];
        for (int i = 1; i < 11; i++) {
            [cells addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
        }
        [self.tblQuizLevel beginUpdates];
        [self.tblQuizLevel deleteRowsAtIndexPaths:cells withRowAnimation:UITableViewRowAnimationNone];
        [self.tblQuizLevel endUpdates];
    }
    UITableViewCell * cell = [self.tblQuizLevel cellForRowAtIndexPath:indexPath];
    UIImageView * accesory = [cell viewWithTag:1252];
    NSInteger index = indexPath.section / 2;
    isExpanded = [_arrayExpanded[index] integerValue];
    if(isExpanded == 0){
        accesory.image = [UIImage imageNamed:@"ic_arrowforward"];
    }else{
        accesory.image = [UIImage imageNamed:@"ic_arrowdown"];
    }
    
}
- (IBAction)onTakeLevel:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblQuizLevel];
    NSIndexPath *indexPath = [self.tblQuizLevel indexPathForRowAtPoint:buttonPosition];
    NSInteger groupPostion = indexPath.section / 2;
    NSInteger childPostion = indexPath.row - 1;
    BOOL shouldUnlocked = groupPostion == 0 && childPostion == 0;
    VLevel* level = [VLevel getInstance:groupPostion + 1 level:childPostion + 1];
//    NSInteger isPurchased = [[VPurchaseInfo sharedInfo].purchased[level.section] integerValue];
//    if([[VPurchaseInfo sharedInfo].purchased[0] integerValue] == 1){
//        isPurchased = 1;
//    }
//    if(!shouldUnlocked && isPurchased == 0)
//    {
//        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:[[VAppInfo sharedInfo] localizedStringForKey:@"quiz_page_12"] preferredStyle:UIAlertControllerStyleAlert];
//        
//        [actionSheet addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            
//            // OK button tapped.
//            
//            [self dismissViewControllerAnimated:YES completion:^{
//            }];
//        }]];
//        
//        // Present action sheet.
//        [self presentViewController:actionSheet animated:YES completion:nil];
//        return;
//    }
    [self showQuiz:level.section level:level.level];
}

- (void)showQuiz:(NSInteger)section level:(NSInteger)level{
    [VAnalytics sendEvent:@"Quiz Page" label:[NSString stringWithFormat:@"%d-%d", section, level]];
    _section = section;
    _level = level;
    
    VQuizViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VQuizViewController"];
    vc.sectionNum = _section;
    vc.levelNum = _level;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 23;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section % 2 == 0){
        return 1;
    }else{
        NSInteger isExpanded = [_arrayExpanded[section / 2] integerValue];
        if(isExpanded == 1){
            return 11;
        }
    }
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section % 2 == 0){
        return 10;
    }
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        return 60;
    return 46;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section % 2 == 0){
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"blank" forIndexPath:indexPath];
        return cell;
    }
    if(indexPath.row == 0){
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"quiz" forIndexPath:indexPath];
        UIImageView * accesory = [cell viewWithTag:1252];
        UILabel * sectionName = [cell viewWithTag:1250];
        UILabel * sectionTitle = [cell viewWithTag:1251];
        NSInteger index = indexPath.section / 2;
        NSInteger isExpanded = [_arrayExpanded[index] integerValue];
        if(isExpanded == 0){
            accesory.image = [UIImage imageNamed:@"ic_arrowforward"];
        }else{
            accesory.image = [UIImage imageNamed:@"ic_arrowdown"];
        }
        sectionName.text = _SECTION_GROUP_NAME_RES[index];
        sectionTitle.text = _SECTION_GROUP_TITLE_RES[index];
        return cell;
    }
    NSInteger groupPostion = indexPath.section / 2;
    NSInteger childPostion = indexPath.row - 1;
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"level" forIndexPath:indexPath];
    UILabel* title = [cell viewWithTag:1250];
    UILabel* desc = [cell viewWithTag:1251];
    UIButton* btn = [cell viewWithTag:1252];
    BOOL shouldUnlocked = groupPostion ==0 && childPostion == 0;
    VLevel* level = [VLevel getInstance:groupPostion + 1 level:childPostion + 1];
    title.text = _LEVEL_TITLE_RES[level.level - 1];
    desc.text = [NSString stringWithFormat:@"(%@)", _LEVEL_DESCR_RES[level.level - 1]];

    if([level isTaken]){
        [btn setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_03"] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:194.0f/255.0f green:194.0f/255.0f blue:194.0f/255.0f alpha:1.0f];
    }else{
        [btn setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_04"] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:126.0f/255.0f green:126.0f/255.0f blue:126.0f/255.0f alpha:1.0f];
    }

    btn.layer.cornerRadius = 4.0f;
    btn.layer.masksToBounds = YES;
    return cell;
}


@end
