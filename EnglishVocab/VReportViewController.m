//
//  ReportViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 4/6/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VReportViewController.h"
#import "VLevel.h"
#import "VAppInfo.h"
#import "VAnalytics.h"

@interface VReportViewController () <UITableViewDelegate, UITableViewDataSource>
{
    VLevel *_currentLevel;
    NSMutableArray* _arrayExpanded;
    NSMutableArray* _SECTION_GROUP_NAME_RES;
    NSMutableArray* _SECTION_GROUP_TITLE_RES;
    NSMutableArray* _SECTION_AVERAGE_TITLE;
    NSMutableArray* _LEVEL_TITLE_RES;
    NSMutableArray* _sectionAvgScores;
}
@property (weak, nonatomic) IBOutlet UILabel *lbTotalGradeAverage;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalGradeAverageScore;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalScoreAverage;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalScoreAverageScore;
@property (weak, nonatomic) IBOutlet UITableView *tblReport;

@end

@implementation VReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _SECTION_GROUP_NAME_RES = [[NSMutableArray alloc] init];
    [_SECTION_GROUP_NAME_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_01"]];
    [_SECTION_GROUP_NAME_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_02"]];
    [_SECTION_GROUP_NAME_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_03"]];
    [_SECTION_GROUP_NAME_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_04"]];
    [_SECTION_GROUP_NAME_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_05"]];
    [_SECTION_GROUP_NAME_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_06"]];
    [_SECTION_GROUP_NAME_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_07"]];
    [_SECTION_GROUP_NAME_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_08"]];
    [_SECTION_GROUP_NAME_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_09"]];
    [_SECTION_GROUP_NAME_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_10"]];
    [_SECTION_GROUP_NAME_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"section_11"]];
    
    _SECTION_AVERAGE_TITLE = [[NSMutableArray alloc] init];
    [_SECTION_AVERAGE_TITLE addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"report_card_04"]];
    [_SECTION_AVERAGE_TITLE addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"report_card_05"]];
    [_SECTION_AVERAGE_TITLE addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"report_card_06"]];
    [_SECTION_AVERAGE_TITLE addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"report_card_07"]];
    [_SECTION_AVERAGE_TITLE addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"report_card_08"]];
    [_SECTION_AVERAGE_TITLE addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"report_card_09"]];
    [_SECTION_AVERAGE_TITLE addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"report_card_10"]];
    [_SECTION_AVERAGE_TITLE addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"report_card_11"]];
    [_SECTION_AVERAGE_TITLE addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"report_card_12"]];
    [_SECTION_AVERAGE_TITLE addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"report_card_13"]];
    [_SECTION_AVERAGE_TITLE addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"report_card_14"]];
    
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
//
//    
//    _LEVEL_DESCR_RES = [[NSMutableArray alloc] init];
//    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_17"]];
//    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_18"]];
//    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_19"]];
//    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_20"]];
//    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_21"]];
//    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_22"]];
//    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_23"]];
//    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_24"]];
//    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_25"]];
//    [_LEVEL_DESCR_RES addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_26"]];
    
    
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
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"main_page_05"]];
    self.lbTotalGradeAverage.text = [[VAppInfo sharedInfo] localizedStringForKey:@"report_card_01"];
    self.lbTotalScoreAverage.text = [[VAppInfo sharedInfo] localizedStringForKey:@"report_card_02"];
    [self loadData];
    
    self.tblReport.rowHeight = UITableViewAutomaticDimension;
    self.tblReport.estimatedRowHeight = 10.0;
    
    [VAnalytics sendScreenName:@"Report Card Screen"];
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

- (void) loadData{
    _sectionAvgScores = [[NSMutableArray alloc] initWithCapacity:11];
    NSInteger count = 0;
    NSInteger total = 0;
    for (int section = 1; section <= 11; section ++) {
        NSInteger countInSection = 0;
        NSInteger totalInSection = 0;
        for (int level = 1; level <= 10; level ++) {
            VLevel* l = [VLevel getInstance:section level:level];
            if([l isTaken]){
                countInSection++;
                totalInSection += l.score;
            }
        }
        _sectionAvgScores[section - 1] = countInSection == 0 ? [NSNumber numberWithInt:-1] : [NSNumber numberWithFloat:(totalInSection / countInSection)];
        count += countInSection;
        total += totalInSection;
    }
    NSInteger score = count == 0 ? 0 : total / count;
    NSString* grade = count == 0 ? @"" : [VLevel getGradeString:score];
    
    _lbTotalScoreAverageScore.text = [NSString stringWithFormat:@"%d %%", score];
    _lbTotalGradeAverageScore.text = grade;
    
    _currentLevel = [VLevel getCurrentLevel];
    _arrayExpanded = [[NSMutableArray alloc] init];
    for (int i = 0; i < 11; i++) {
        [_arrayExpanded addObject:@(0)];
    }
    _arrayExpanded[_currentLevel.section - 1] = @(1);
}


- (IBAction)onBookItem:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblReport];
    NSIndexPath *indexPath = [self.tblReport indexPathForRowAtPoint:buttonPosition];
    NSInteger isExpanded = [_arrayExpanded[indexPath.section / 2] integerValue];
    if (isExpanded == 0) {
        _arrayExpanded[indexPath.section / 2] = @(1);
        NSMutableArray* cells = [[NSMutableArray alloc] init];
        for (int i = 1; i < 12; i++) {
            [cells addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
        }
        [self.tblReport beginUpdates];
        [self.tblReport insertRowsAtIndexPaths:cells withRowAnimation:UITableViewRowAnimationNone];
        [self.tblReport endUpdates];
        [self.tblReport scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }else{
        _arrayExpanded[indexPath.section / 2] = @(0);
        NSMutableArray* cells = [[NSMutableArray alloc] init];
        for (int i = 1; i < 12; i++) {
            [cells addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
        }
        [self.tblReport beginUpdates];
        [self.tblReport deleteRowsAtIndexPaths:cells withRowAnimation:UITableViewRowAnimationNone];
        [self.tblReport endUpdates];
    }
    UITableViewCell * cell = [self.tblReport cellForRowAtIndexPath:indexPath];
    UIImageView * accesory = [cell viewWithTag:1252];
    NSInteger index = indexPath.section / 2;
    isExpanded = [_arrayExpanded[index] integerValue];
    if(isExpanded == 0){
        accesory.image = [UIImage imageNamed:@"ic_arrowforward"];
    }else{
        accesory.image = [UIImage imageNamed:@"ic_arrowdown"];
    }
    
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
            return 12;
        }
    }
    return 1;
}
//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section % 2 == 0){
//        return 10;
//    }
//    return 46;
//}

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
    if(indexPath.row <= 10){
        NSInteger groupPostion = indexPath.section / 2;
        NSInteger childPostion = indexPath.row - 1;
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"level" forIndexPath:indexPath];
        UILabel* title = [cell viewWithTag:1250];
        UILabel* score = [cell viewWithTag:1251];
        UILabel* grade = [cell viewWithTag:1252];
        VLevel* level = [VLevel getInstance:groupPostion + 1 level:childPostion + 1];
        title.text = _LEVEL_TITLE_RES[level.level - 1];
        if([level isTaken]){
            score.text = [NSString stringWithFormat:@"%d%%", level.score];
            grade.text = [level getGrade];
        }else{
            score.text = [[VAppInfo sharedInfo] localizedStringForKey:@"report_card_03"];
            grade.text = @"";
        }
        return cell;
    }
    NSInteger groupPostion = indexPath.section / 2;
    NSInteger childPostion = indexPath.row - 1;
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"level" forIndexPath:indexPath];
    UILabel* title = [cell viewWithTag:1250];
    UILabel* score = [cell viewWithTag:1251];
    UILabel* grade = [cell viewWithTag:1252];
    title.text = _SECTION_AVERAGE_TITLE[groupPostion];
    NSInteger avgScore = [_sectionAvgScores[groupPostion] integerValue];
    if(avgScore >= 0){
        score.text = [NSString stringWithFormat:@"%d%%", avgScore];
        grade.text = [VLevel getGradeString:avgScore];
    } else{
        score.text = @"";
        grade.text = @"";
    }
    return cell;
}

@end
