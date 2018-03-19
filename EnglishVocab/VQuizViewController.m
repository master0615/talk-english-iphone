//
//  VQuizViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 4/8/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VQuizViewController.h"
#import "VPurchaseInfo.h"
#import "VLevel.h"
#import "VQuizGenerator.h"
#import "VAppInfo.h"
#import "VReportViewController.h"
#import "VQuiz.h"
#import "VAnalytics.h"

@interface VQuizViewController (){
    VLevel* _level;
    NSMutableArray* _QuizList;
    NSInteger _CurrentQuizIndex;
    NSMutableArray* _SECTION_TITLE_RES;
    NSMutableArray* _LEVEL_TITLE_RES;
    NSInteger _CorrectCount;
    VQuiz* _currentQuiz;
}
@property (weak, nonatomic) IBOutlet UILabel *lbQuizSection;
@property (weak, nonatomic) IBOutlet UILabel *lbDescription;
@property (weak, nonatomic) IBOutlet UILabel *lbQuestionNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbQuestionText;
@property (weak, nonatomic) IBOutlet UIButton *chkQuestion1;
@property (weak, nonatomic) IBOutlet UILabel *lbQuestion1;
@property (weak, nonatomic) IBOutlet UIButton *chkQuestion2;
@property (weak, nonatomic) IBOutlet UILabel *lbQuestion2;
@property (weak, nonatomic) IBOutlet UIButton *chkQuestion3;
@property (weak, nonatomic) IBOutlet UILabel *lbQuestion3;
@property (weak, nonatomic) IBOutlet UIButton *chkQuestion4;
@property (weak, nonatomic) IBOutlet UILabel *lbQuestion4;
@property (weak, nonatomic) IBOutlet UIButton *chkQuestion5;
@property (weak, nonatomic) IBOutlet UILabel *lbQuestion5;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UIView *viewResult;
@property (weak, nonatomic) IBOutlet UILabel *lbResult;
@property (weak, nonatomic) IBOutlet UIButton *btnOption1;
@property (weak, nonatomic) IBOutlet UIButton *btnOption2;
@property (weak, nonatomic) IBOutlet UIButton *btnOption3;
@property (weak, nonatomic) IBOutlet UIButton *btnOption4;
@property (weak, nonatomic) IBOutlet UIButton *btnOption5;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UILabel *lbReportTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbReportCorrectCount;
@property (weak, nonatomic) IBOutlet UILabel *lbReportCorrectCountTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbReportIncorrectCount;
@property (weak, nonatomic) IBOutlet UILabel *lbReportIncorrectCountTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbReportScore;
@property (weak, nonatomic) IBOutlet UILabel *lbReportGrade;
@property (weak, nonatomic) IBOutlet UIButton *btnReportCard;
@property (weak, nonatomic) IBOutlet UIButton *btnNextQuiz;
@property (weak, nonatomic) IBOutlet UIScrollView *viewReport;
@property (weak, nonatomic) IBOutlet UIScrollView *viewQuiz;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;

@end

@implementation VQuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_quiz_01"]];
    
    _btnCheck.enabled = NO;
    _viewQuiz.hidden = YES;
    _viewResult.hidden = YES;
    _viewReport.hidden = YES;
    
    _lbReportTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"quiz_page_09"];
    _lbReportCorrectCountTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"quiz_page_06"];
    _lbReportIncorrectCountTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"quiz_page_07"];
    [_btnReportCard setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"quiz_page_10"] forState:UIControlStateNormal];
    [_btnNextQuiz setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"quiz_page_11"] forState:UIControlStateNormal];
    
    [_btnCheck setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"quiz_page_05"] forState:UIControlStateNormal];
    [_btnNext setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"quiz_page_08"] forState:UIControlStateNormal];
    
    [self loadData:_sectionNum level:_levelNum];
    
    [VAnalytics sendScreenName:@"Quiz Screen"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onQuestion1:(id)sender {
    _chkQuestion1.selected = YES;
    _chkQuestion2.selected = NO;
    _chkQuestion3.selected = NO;
    _chkQuestion4.selected = NO;
    _chkQuestion5.selected = NO;
    _btnCheck.enabled = YES;
}
- (IBAction)onQuestion2:(id)sender {
    _chkQuestion1.selected = NO;
    _chkQuestion2.selected = YES;
    _chkQuestion3.selected = NO;
    _chkQuestion4.selected = NO;
    _chkQuestion5.selected = NO;
    _btnCheck.enabled = YES;
}
- (IBAction)onQuestion3:(id)sender {
    _chkQuestion1.selected = NO;
    _chkQuestion2.selected = NO;
    _chkQuestion3.selected = YES;
    _chkQuestion4.selected = NO;
    _chkQuestion5.selected = NO;
    _btnCheck.enabled = YES;
}
- (IBAction)onQuestion4:(id)sender {
    _chkQuestion1.selected = NO;
    _chkQuestion2.selected = NO;
    _chkQuestion3.selected = NO;
    _chkQuestion4.selected = YES;
    _chkQuestion5.selected = NO;
    _btnCheck.enabled = YES;
}
- (IBAction)onQuestion5:(id)sender {
    _chkQuestion1.selected = NO;
    _chkQuestion2.selected = NO;
    _chkQuestion3.selected = NO;
    _chkQuestion4.selected = NO;
    _chkQuestion5.selected = YES;
    _btnCheck.enabled = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)loadData:(NSInteger)section level:(NSInteger)level{
//    NSInteger isPurchased = [[VPurchaseInfo sharedInfo].purchased[section] integerValue];
//    if([[VPurchaseInfo sharedInfo].purchased[0] integerValue] == 1){
//        isPurchased = 1;
//    }
    NSInteger limit = -1;//isPurchased ? -1 : 20;
    _level = [VLevel getInstance:section level:level];
    _QuizList = [VQuizGenerator generate:_level limit:limit ];
    _CurrentQuizIndex = 0;
    
    _lbQuizSection.text = [NSString stringWithFormat:@"%@: %@", _SECTION_TITLE_RES[section - 1], _LEVEL_TITLE_RES[level - 1]];
    
    _CorrectCount = 0;
    [self showQuiz:0];
    
}

- (void) showReport{
    NSInteger score = (_CorrectCount * 100.0f / _QuizList.count);
    [_level setScore:score];
    
    _viewResult.hidden = YES;
    
    _viewHeader.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:235.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
    _viewQuiz.hidden = YES;
    _viewReport.hidden = NO;
    
    _lbReportCorrectCount.text = [NSString stringWithFormat:@"%d", _CorrectCount];
    _lbReportIncorrectCount.text = [NSString stringWithFormat:@"%d", _QuizList.count - _CorrectCount];
    _lbReportScore.text = [NSString stringWithFormat:@"%d %%", score];
    _lbReportGrade.text = [VLevel getGradeString:score];
    
//    NSInteger isPurchased = [[VPurchaseInfo sharedInfo].purchased[[_level getNextSection]] integerValue];
//    if([[VPurchaseInfo sharedInfo].purchased[0] integerValue] == 1){
//        isPurchased = 1;
//    }
    
    BOOL showNext = ![_level isLast];// && isPurchased;
    _btnNextQuiz.hidden = !showNext;
    [VAnalytics sendEvent:@"Quiz End" label:[NSString stringWithFormat:@"%d-%d", _level.section, _level.level]];
}

- (void) showResult:(VQuiz*)quiz selectedIndex:(NSInteger)selectedIndex{
    if( quiz.correctChoiceIndex == selectedIndex){
        _lbResult.text = [[VAppInfo sharedInfo] localizedStringForKey:@"quiz_page_06"];
        _lbResult.textColor = [UIColor colorWithRed:0.0f green:208.0f/255.0f blue:0.0f alpha:1.0f];
        _CorrectCount ++;
    }else{
        _lbResult.text = [[VAppInfo sharedInfo] localizedStringForKey:@"quiz_page_07"];
        _lbResult.textColor = [UIColor colorWithRed:216.0f/255.0f green:0.0f blue:0.0f alpha:1.0f];
        switch (selectedIndex) {
            case 0:
                _lbQuestion1.textColor = [UIColor colorWithRed:216.0f/255.0f green:0.0f blue:0.0f alpha:1.0f];
                break;
            case 1:
                _lbQuestion2.textColor = [UIColor colorWithRed:216.0f/255.0f green:0.0f blue:0.0f alpha:1.0f];
                break;
            case 2:
                _lbQuestion3.textColor = [UIColor colorWithRed:216.0f/255.0f green:0.0f blue:0.0f alpha:1.0f];
                break;
            case 3:
                _lbQuestion4.textColor = [UIColor colorWithRed:216.0f/255.0f green:0.0f blue:0.0f alpha:1.0f];
                break;
            case 4:
                _lbQuestion5.textColor = [UIColor colorWithRed:216.0f/255.0f green:0.0f blue:0.0f alpha:1.0f];
                break;
            default:
                break;
        }
    }
    switch (quiz.correctChoiceIndex) {
        case 0:
            _lbQuestion1.textColor = [UIColor colorWithRed:0.0f green:208.0f/255.0f blue:0.0f alpha:1.0f];
            break;
        case 1:
            _lbQuestion2.textColor = [UIColor colorWithRed:0.0f green:208.0f/255.0f blue:0.0f alpha:1.0f];
            break;
        case 2:
            _lbQuestion3.textColor = [UIColor colorWithRed:0.0f green:208.0f/255.0f blue:0.0f alpha:1.0f];
            break;
        case 3:
            _lbQuestion4.textColor = [UIColor colorWithRed:0.0f green:208.0f/255.0f blue:0.0f alpha:1.0f];
            break;
        case 4:
            _lbQuestion5.textColor = [UIColor colorWithRed:0.0f green:208.0f/255.0f blue:0.0f alpha:1.0f];;
            break;
        default:
            break;
    }
    _viewResult.hidden = NO;
}
- (void) showQuiz:(NSInteger)index{
    if( index >= _QuizList.count){
        [self showReport];
        return;
    }
    _viewHeader.backgroundColor = [UIColor colorWithRed:241.0f/255.0f green:241.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
    _viewQuiz.hidden = NO;
    _viewReport.hidden = YES;
    
    _CurrentQuizIndex = index;
    
    _currentQuiz = _QuizList[index];
    NSString* strDescText;
    NSString* strTypeText;
    if(_currentQuiz.type == DEFINITION_TO_WORD){
        strDescText = [[VAppInfo sharedInfo] localizedStringForKey:@"quiz_page_01"];
        strTypeText = [[VAppInfo sharedInfo] localizedStringForKey:@"quiz_page_03"];
        UIFontDescriptor * fontD = [_lbQuestionText.font.fontDescriptor
                                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        _lbQuestionText.font = [UIFont fontWithDescriptor:fontD size:0];
    }else{
        strDescText = [[VAppInfo sharedInfo] localizedStringForKey:@"quiz_page_02"];
        strTypeText = [[VAppInfo sharedInfo] localizedStringForKey:@"quiz_page_04"];
        UIFontDescriptor * fontD = [_lbQuestionText.font.fontDescriptor
                                    fontDescriptorWithSymbolicTraits:0];
        _lbQuestionText.font = [UIFont fontWithDescriptor:fontD size:0];
    }
    
    _lbDescription.text = strDescText;
    _lbQuestionNumber.text = [NSString stringWithFormat:@"%d/%d  %@", (index + 1), _QuizList.count, strTypeText];
    _lbQuestionText.text = _currentQuiz.question;
    
    _chkQuestion1.selected = NO;
    _chkQuestion2.selected = NO;
    _chkQuestion3.selected = NO;
    _chkQuestion4.selected = NO;
    _chkQuestion5.selected = NO;
    
    _lbQuestion1.text = _currentQuiz.choiceList[0];
    _lbQuestion1.textColor = [UIColor colorWithRed:72.0f/255.0f green:74.0f/255.0f blue:79.0f/255.0f alpha:1.0f];
    _lbQuestion2.text = _currentQuiz.choiceList[1];
    _lbQuestion2.textColor = [UIColor colorWithRed:72.0f/255.0f green:74.0f/255.0f blue:79.0f/255.0f alpha:1.0f];
    _lbQuestion3.text = _currentQuiz.choiceList[2];
    _lbQuestion3.textColor = [UIColor colorWithRed:72.0f/255.0f green:74.0f/255.0f blue:79.0f/255.0f alpha:1.0f];
    _lbQuestion4.text = _currentQuiz.choiceList[3];
    _lbQuestion4.textColor = [UIColor colorWithRed:72.0f/255.0f green:74.0f/255.0f blue:79.0f/255.0f alpha:1.0f];
    _lbQuestion5.text = _currentQuiz.choiceList[4];
    _lbQuestion5.textColor = [UIColor colorWithRed:72.0f/255.0f green:74.0f/255.0f blue:79.0f/255.0f alpha:1.0f];
    
    _btnOption1.enabled = YES;
    _btnOption2.enabled = YES;
    _btnOption3.enabled = YES;
    _btnOption4.enabled = YES;
    _btnOption5.enabled = YES;
    
    _btnCheck.enabled = NO;
    _viewResult.hidden = YES;
}
- (IBAction)onNextQuiz:(id)sender {
    NSInteger section = _level.section;
    NSInteger level = _level.level + 1;
    if (level > 10){
        section ++;
        level = 1;
    }
    [self loadData:section level:level];
}
- (IBAction)onReportCard:(id)sender {
    VReportViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReportViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    [VAnalytics sendEvent:@"Report Page" label:@""];
}
- (IBAction)onCheck:(id)sender {
    NSInteger index = 0;
    if (_chkQuestion1.selected) index = 0;
    else if (_chkQuestion2.selected) index = 1;
    else if (_chkQuestion3.selected) index = 2;
    else if (_chkQuestion4.selected) index = 3;
    else if (_chkQuestion5.selected) index = 4;
    [self showResult:_currentQuiz selectedIndex:index];
    _btnCheck.enabled = NO;
    _btnOption1.enabled = NO;
    _btnOption2.enabled = NO;
    _btnOption3.enabled = NO;
    _btnOption4.enabled = NO;
    _btnOption5.enabled = NO;
}
- (IBAction)onNext:(id)sender {
    [self showQuiz:_CurrentQuizIndex + 1];
    [VAnalytics sendEvent:@"Quiz Begin" label:[NSString stringWithFormat:@"%d-%d", _level.section, _level.level]];
}
@end
