//
//  BLessonsListViewController.m
//  englearning-kids
//
//  Created by sworld on 8/21/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BLessonsListViewController.h"
#import "BLessonsListContainerViewController.h"
#import "BLessonStartContainerViewController.h"
#import "BQuizContainerViewController.h"
#import "BStudyingViewCell.h"
#import "BLesson.h"
#import "UIUtils.h"
#import "LUtils.h"
#import "BAnalytics.h"

@interface BLessonsListViewController()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *lessonsTableView;
@property (weak, nonatomic) IBOutlet BStudyingViewCell *expandedLessonView;


@end

@implementation BLessonsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void) scrollToPosition: (int) position {
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow: position inSection: 0];
    [_lessonsTableView scrollToRowAtIndexPath: indexPath atScrollPosition: UITableViewScrollPositionTop animated: YES];
}
- (void) refresh {
    self.lessons = [BLessonsListContainerViewController singleton].lessons;
    int activeNumber = [BLessonsListContainerViewController singleton].activeNumber;
    self.lessons = [BLessonsListContainerViewController singleton].lessons;
    [self.lessonsTableView reloadData];
    /*if (activeNumber == -1) {
        BOOL found = NO;
        for (int i = 0; i < [_lessons count]; i ++) {
            BLesson* entry = [_lessons objectAtIndex: i];
            if ([entry isLessonStudying]) {
                [self scrollToPosition: i+1];
                found = YES;
                break;
            }
        }
    } else {
        BOOL found = NO;
        for (int i = 0; i < [_lessons count]; i ++) {
            BLesson* entry = [_lessons objectAtIndex: i];
            if ([entry isLessonStudying] && entry.number == activeNumber) {
                [self scrollToPosition: i+1];
                found = YES;
                break;
            }
        }
        if (!found) {
            [BLessonsListContainerViewController singleton].activeNumber = -1;
        }
    }*/
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews {
//    [self.lessonsTableView reloadData];
    //[self updateLessonView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
static int anim_count = 0;
- (void) startAnimation: (UIButton*) button {
    button.hidden = NO;
    button.alpha = 0;
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         button.alpha = 1.0;
                     }
                     completion: ^(BOOL finished) {
                         
                         
                     }];
    [UIView animateWithDuration:0.3
                          delay:0.3
                        options: UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         button.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         anim_count ++;
                         if (anim_count < 15) {
                             [self startAnimation: button];
                         } else {
                             anim_count = 0;
                             [BLessonsListContainerViewController singleton].activeNumber = -1;
                             [BLessonsListContainerViewController singleton].activeSession = 0;
                             button.hidden = YES;
                         }
                     }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.lessons count] + 1;
}
- (void)updateLessonView {
    for(long i = 0; i < _lessons.count; i ++) {
        BLesson *entry = _lessons[i];
        if (entry.isExpanded) {
            [_expandedLessonView setHidden:NO];
            //[self updateExpandedView:_expandedLessonView entry:entry tag:i + 1];
            return;
        }
    }
    [_expandedLessonView setHidden:YES];
}
- (void)updateExpandedView:(BStudyingViewCell*)cell entry:(BLesson*)entry tag:(NSInteger)tag{
    BStudyingViewCell *cellExp = cell;
    cellExp.activeSection = [entry wasLessonCompleted] ? 5 : [entry section];
    
    UILabel* numberLabel = cell.numberLabel;//(UILabel*) [cell viewWithTag: 82201];
    UILabel* titleLabel = cell.titleLabel;//(UILabel*) [cell viewWithTag: 82202];
    UIButton* startLessonButton = cell.btnLessonStart;//(UIButton*) [cell viewWithTag: 82203];
    UIButton* session1Button = cell.session1Button;//(UIButton*) [cell viewWithTag: 82204];
    UIButton* session2Button = cell.session2Button;//(UIButton*) [cell viewWithTag: 82205];
    UIButton* quizButton = cell.quizButton;//(UIButton*) [cell viewWithTag: 82206];
    UIButton* finalButton = cell.finalButton;//(UIButton*) [cell viewWithTag: 82207];
    UIButton* contractButton = cell.contractButton;//(UIButton*) [cell viewWithTag:82208];
    UIButton* session1Button0 = cell.session1Button0;//(UIButton*) [cell viewWithTag: 90804];
    UIButton* session2Button0 = cell.session2Button0;//(UIButton*) [cell viewWithTag: 90805];
    UIButton* quizButton0 = cell.quizButton0;//(UIButton*) [cell viewWithTag: 90806];
    UIButton* finalButton0 = cell.finalButton0;//(UIButton*) [cell viewWithTag: 90807];
    UIImageView* star1 = cell.star1;//(UIImageView*) [cell viewWithTag: 90601];
    UIImageView* star2 = cell.star2;//(UIImageView*) [cell viewWithTag: 90602];
    UIImageView* star3 = cell.star3;//(UIImageView*) [cell viewWithTag: 90603];
    
    UIView *separator12View = cell.separator12View;
    UIView *separator23View = cell.separator23View;
    UIView *separator34View = cell.separator34View;
    
    startLessonButton.tag = tag;
    session1Button.tag = tag;
    session2Button.tag = tag;
    quizButton.tag = tag;
    finalButton.tag = tag;
    session1Button0.tag = tag;
    session2Button0.tag = tag;
    quizButton0.tag = tag;
    finalButton0.tag = tag;
    contractButton.tag = tag;
    
    star1.hidden = YES;
    star2.hidden = YES;
    star3.hidden = YES;
    if ([LUtils isIPhone4_or_less]) {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            ((BStudyingViewCell*)cell).sectionButtonBottom.constant = 10;
            [cell.contentView updateConstraintsIfNeeded];
        }
    }
    
    // disable flashing animation - commented on 2016.10.14
    //        if ([BLessonsListContainerViewController singleton].activeNumber == entry.number) {
    //            anim_count = 0;
    //            if ([BLessonsListContainerViewController singleton].activeSession == 0x10) {
    //                [self startAnimation: session1Button0];
    //            } else if ([BLessonsListContainerViewController singleton].activeSession == 0x20) {
    //                [self startAnimation: session2Button0];
    //            } else if ([BLessonsListContainerViewController singleton].activeSession == 0x30) {
    //                [self startAnimation: quizButton0];
    //            } else if ([BLessonsListContainerViewController singleton].activeSession == 0x40) {
    //                [self startAnimation: finalButton0];
    //            }
    //        }
    numberLabel.text = [NSString stringWithFormat: @"%d", entry.number];
    titleLabel.text = entry.title;
    if ([entry wasLessonCompleted]) {
        [startLessonButton setTitle: [NSString stringWithFormat: @"Completed! - %03d/500", [entry points]] forState: UIControlStateNormal];
        session1Button.enabled = YES;
        session2Button.enabled = YES;
        quizButton.enabled = YES;
        finalButton.enabled = YES;
        
        if ([entry stars] == 1) {
            star1.hidden = YES;
            star2.hidden = YES;
            star3.hidden = NO;
        } else if ([entry stars] == 2) {
            star1.hidden = YES;
            star2.hidden = NO;
            star3.hidden = NO;
        } else if ([entry stars] == 3) {
            star1.hidden = NO;
            star2.hidden = NO;
            star3.hidden = NO;
        }
    } else if (entry.section == 1) {
        [startLessonButton setTitle: @"Studying..." forState: UIControlStateNormal];
        session1Button.enabled = YES;
        session2Button.enabled = NO;
        quizButton.enabled = NO;
        finalButton.enabled = NO;
    } else if (entry.section == 2) {
        [startLessonButton setTitle: @"Studying..." forState: UIControlStateNormal];
        session1Button.enabled = YES;
        session2Button.enabled = YES;
        quizButton.enabled = NO;
        finalButton.enabled = NO;
    } else if (entry.section == 3) {
        [startLessonButton setTitle: @"Studying..." forState: UIControlStateNormal];
        session1Button.enabled = YES;
        session2Button.enabled = YES;
        quizButton.enabled = YES;
        finalButton.enabled = NO;
    } else if (entry.section == 4) {
        [startLessonButton setTitle: @"Studying..." forState: UIControlStateNormal];
        session1Button.enabled = YES;
        session2Button.enabled = YES;
        quizButton.enabled = YES;
        finalButton.enabled = YES;
    } else {
        [startLessonButton setTitle: @"Start Lesson!" forState: UIControlStateNormal];
        session1Button.enabled = NO;
        session2Button.enabled = NO;
        quizButton.enabled = NO;
        finalButton.enabled = NO;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell;
    cell = [tableView dequeueReusableCellWithIdentifier: @"EmptyCell"];
    if (indexPath.row == 0 || indexPath.row == [_lessons count]+1) {
        cell = [tableView dequeueReusableCellWithIdentifier: @"EmptyCell"];
        return cell;
    }
    NSLog(@"indexpath row is %ld.", indexPath.row);
    BLesson* entry = [_lessons objectAtIndex: indexPath.row - 1];
    [entry loadSection];
    [entry loadScore];
    if ([entry isExpanded]) {
        cell = [tableView dequeueReusableCellWithIdentifier: @"StudyingCell"];
        [self updateExpandedView:cell entry:entry tag:indexPath.row];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier: @"NormalCell"];
        UILabel* numberLabel = (UILabel*) [cell viewWithTag: 8221];
        UILabel* titleLabel = (UILabel*) [cell viewWithTag: 8222];
        UIImageView* numberBg = (UIImageView*) [cell viewWithTag: 8223];
        UIButton* button = (UIButton*) [cell viewWithTag: 18224];
        UIImageView* star1 = (UIImageView*) [cell viewWithTag: 9061];
        UIImageView* star2 = (UIImageView*) [cell viewWithTag: 9062];
        UIImageView* star3 = (UIImageView*) [cell viewWithTag: 9063];
        
        button.tag = indexPath.row;
        star1.hidden = YES;
        star2.hidden = YES;
        star3.hidden = YES;
        if ([entry stars] == 1) {
            star1.hidden = YES;
            star2.hidden = YES;
            star3.hidden = NO;
        } else if ([entry stars] == 2) {
            star1.hidden = YES;
            star2.hidden = NO;
            star3.hidden = NO;
        } else if ([entry stars] == 3) {
            star1.hidden = NO;
            star2.hidden = NO;
            star3.hidden = NO;
        }
        numberLabel.text = [NSString stringWithFormat: @"%d", entry.number];
        titleLabel.text = entry.title;
        //if ([entry canStudy]) {
            numberLabel.textColor = RGB(0xFF, 0xFF, 0xFF);
            titleLabel.textColor = RGB(0x33, 0x33, 0x33);
            numberBg.image = [UIImage imageNamed: @"lesson_item_number_bg_normal"];
            button.enabled = YES;
        //} else {
        //    numberLabel.textColor = RGB(0x99, 0x99, 0x99);
        //    titleLabel.textColor = RGB(0x77, 0x77, 0x77);
        //    numberBg.image = [UIImage imageNamed: @"lesson_item_number_bg_disabled"];
        //    button.enabled = NO;
        //
        //}
    }
//    if ([entry isLessonStudying]) {
//        CGPoint center = [tableView contentOffset];
//        center.y += tableView.frame.size.height/2;
//        [tableView setContentOffset: CGPointMake(0, cell.center.y-65) animated: YES];
//        [tableView reloadData];
//    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == [_lessons count]+1) {
        return 4;
    }
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    BLesson* entry = [_lessons objectAtIndex: indexPath.row - 1];
    if ([entry isExpanded]) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            CGFloat edge_w = 56.0 * 46 / 180.0;
            return 62+60 * 3+edge_w*1.478*75.0/68.0+4;
            return 62+56+110+110+edge_w*1.478*75.0/68.0+4;
        } else {
            CGFloat edge_w = 64.0 * 46 / 180.0;
            return 70+68 * 3+edge_w*1.478*75.0/68.0+4;
            return 70+64+170+170+edge_w*1.478*75.0/68.0+4;
        }
    } else {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            return 62;
        } else {
            return 70;
        }
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (NSInteger)getSelectedIndex:(id)sender {
    UIButton *button = sender;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.lessonsTableView];
    NSIndexPath *indexPath = [self.lessonsTableView indexPathForRowAtPoint:buttonPosition];
    NSInteger selectedRow = indexPath.row;
    
    if (selectedRow <= 0 || selectedRow > _lessons.count) {
        selectedRow = button.tag;
    }
    if (selectedRow <= 0 || selectedRow > _lessons.count) {
        selectedRow = 1;
        NSLog(@"Couldn't find selected row index.");
    }
    return selectedRow;
}
- (IBAction)expandButtonClicked:(id)sender {
    NSInteger selectedRow = [self getSelectedIndex:sender];
    NSLog(@"selected index %ld", selectedRow);
    /*for (long i = 0; i < _lessons.count; i ++) {
        if (i != selectedRow - 1) {
            [_lessons[i] contract];
        }
    }*/
    BLesson* entry = [_lessons objectAtIndex: selectedRow - 1];
    [entry expand];
    [entry setStudying];
    [self.lessonsTableView reloadData];
    [BAnalytics sendEvent: @"Expand pressed" label: entry.title];
    //[self updateLessonView];
}
- (IBAction)contractButtonClicked:(id)sender {
    NSInteger selectedRow = [self getSelectedIndex:sender];
    NSLog(@"selected index %ld", selectedRow);
    BLesson* entry = [_lessons objectAtIndex: selectedRow - 1];
    [entry contract];
    [self.lessonsTableView reloadData];
    [BAnalytics sendEvent: @"Contract pressed" label: entry.title];
    //[self updateLessonView];
}
- (IBAction)startLessonButtonClicked:(id)sender {
    NSInteger selectedRow = [self getSelectedIndex:sender];
    NSLog(@"selected index %ld", selectedRow);
    BLesson* entry = [_lessons objectAtIndex: selectedRow - 1];
    [entry setStudying];
    [[BLessonsListContainerViewController singleton] startLesson: entry];
    
    [BAnalytics sendEvent: @"Start Lesson pressed" label: entry.title];
}
- (IBAction)session1ButtonClicked:(id)sender {
    NSInteger selectedRow = [self getSelectedIndex:sender];
    NSLog(@"selected index %ld", selectedRow);
    BLesson* entry = [_lessons objectAtIndex: selectedRow - 1];
    [entry setStudying];
    [[BLessonsListContainerViewController singleton] gotoSession: 0x10 forLesson: entry];
    [BAnalytics sendEvent: @"Study Session 1/2 pressed" label: entry.title];
}
- (IBAction)session2ButtonClicked:(id)sender {
    NSInteger selectedRow = [self getSelectedIndex:sender];
    NSLog(@"selected index %ld", selectedRow);
    BLesson* entry = [_lessons objectAtIndex: selectedRow - 1];
    [entry setStudying];
    [[BLessonsListContainerViewController singleton] gotoSession: 0x20 forLesson: entry];
    [BAnalytics sendEvent: @"Study Session 2/2 pressed" label: entry.title];
}
- (IBAction)quizButtonClicked:(id)sender {
    NSInteger selectedRow = [self getSelectedIndex:sender];
    NSLog(@"selected index %ld", selectedRow);
    BLesson* entry = [_lessons objectAtIndex: selectedRow - 1];
    [entry setStudying];
    [[BLessonsListContainerViewController singleton] gotoQuiz: 0x30 forLesson: entry];
    [BAnalytics sendEvent: @"Quiz pressed" label: entry.title];
}
- (IBAction)finalButtonClicked:(id)sender {
    NSInteger selectedRow = [self getSelectedIndex:sender];
    NSLog(@"selected index %ld", selectedRow);
    BLesson* entry = [_lessons objectAtIndex: selectedRow - 1];
    [entry setStudying];
    BLessonStartContainerViewController* vc = (BLessonStartContainerViewController*)[LUtils newViewControllerWithIdForBegin: @"BLessonStartContainerViewController"];
    vc.lesson = entry;
    vc.session = 0x40;
    vc.screen = STARTING;
    vc.showProgress = NO;
    vc.backToVC = [BLessonsListContainerViewController singleton];
    [[BLessonsListContainerViewController singleton].navigationController pushViewController: vc animated: YES];
    [BAnalytics sendEvent: @"Final Check pressed" label: entry.title];
}

@end
