//
//  LessonsListViewController.m
//  englistening
//
//  Created by alex on 5/4/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LLessonsListViewController.h"
#import "LHomeViewController.h"
#import "LLessonContainerViewController.h"
#import "LUtils.h"
#import "LEnv.h"
#import "Lesson1.h"
#import "Lesson2.h"
#import "Lesson3.h"
#import "Lesson4.h"
#import "Lesson5.h"
#import "Lesson6.h"
#import "LPointBadgeView.h"
#import "AdsTimeCounter.h"

@interface LLessonsListViewController () {
    
    LLessonContainerViewController* _lessonVC;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *lessonsListTableView;
@property (nonatomic, strong) NSArray* lessonsList;
@end

@implementation LLessonsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [LAnalytics sendScreenName:[NSString stringWithFormat: @"Lessons List Screen - %@", self.prefix]];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    if ([self.prefix isEqualToString: [Lesson1 prefix]]) {
        [self.titleLabel setText: [NSString stringWithFormat: @"Beginner I: Fill in the Blanks"]];
        self.lessonsList = [Lesson1 loadAll];
    } else if ([self.prefix isEqualToString: [Lesson2 prefix]]) {
        [self.titleLabel setText: @"Beginner II: What is in the Picture?"];
        self.lessonsList = [Lesson2 loadAll];
    } else if ([self.prefix isEqualToString: [Lesson3 prefix]]) {
        [self.titleLabel setText: @"Beginner III: Fomous Quotes"];
        self.lessonsList = [Lesson3 loadAll];
    } else if ([self.prefix isEqualToString: [Lesson4 prefix]]) {
        [self.titleLabel setText: @"Intermediate I: Short Passages"];
        self.lessonsList = [Lesson4 loadAll];
    } else if ([self.prefix isEqualToString: [Lesson5 prefix]]) {
        [self.titleLabel setText: @"Intermediate II: Sentence Dictation"];
        self.lessonsList = [Lesson5 loadAll];
    } else if ([self.prefix isEqualToString: [Lesson6 prefix]]) {
        [self.titleLabel setText: @"Advanced: Long Paragraphs"];
        self.lessonsList = [Lesson6 loadAll];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews
{
    [self.lessonsListTableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return [[UIScreen mainScreen] bounds].size.width / 6.0 * 5 / 4.0 + 16;
        } else {
            return [[UIScreen mainScreen] bounds].size.width / 5.0 * 5 / 4.0 + 16;        
        }
    } else {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return [[UIScreen mainScreen] bounds].size.width / 8.0 * 5 / 4.0 + 16;
        } else {
            return [[UIScreen mainScreen] bounds].size.width / 7.0 * 5 / 4.0 + 16;
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.lessonsList == nil) {
        return 0;
    }
    return [self.lessonsList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"LessonViewCell"];
    if (self.lessonsList == nil) {
        return cell;
    }
    UIImageView* image = (UIImageView*) [cell viewWithTag: 5061];
    UILabel* titleLabel = (UILabel*) [cell viewWithTag: 5062];
    UILabel* descriptionLabel = (UILabel*) [cell viewWithTag: 5063];
    LPointBadgeView* pbView = (LPointBadgeView*) [cell viewWithTag: 5241];
    Lesson* lesson = (Lesson*) [self.lessonsList objectAtIndex: indexPath.row];
    image.image = [UIImage imageNamed: lesson.image];
    [titleLabel setText: lesson.title];
    [descriptionLabel setText: [lesson description]];
    if ([lesson isCompleted]) {
        pbView.hidden = NO;
    } else {
        pbView.hidden = YES;
    }
    [pbView setPoint: [lesson point]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Lesson* lesson = (Lesson*) [self.lessonsList objectAtIndex: indexPath.row];
    [LAnalytics sendEvent: [NSString stringWithFormat: @"Enter lesson - %@", self.prefix]
                   label: lesson.number];
    if ([lesson isKindOfClass: [Lesson1 class]]) {
        LLessonContainerViewController* lessonVC = (LLessonContainerViewController*) [LUtils newViewControllerWithId: @"LLessonContainerViewController"  ];
        lessonVC.position = (int)indexPath.row;
        lessonVC.prefix = [Lesson1 prefix];
        [self gotoLesson: lessonVC];
    } else if ([lesson isKindOfClass: [Lesson2 class]]) {
        LLessonContainerViewController* lessonVC = (LLessonContainerViewController*) [LUtils newViewControllerWithId: @"LLessonContainerViewController"  ];
        lessonVC.position = (int)indexPath.row;
        lessonVC.prefix = [Lesson2 prefix];
        [self gotoLesson: lessonVC];
    } else if ([lesson isKindOfClass: [Lesson3 class]]) {
        LLessonContainerViewController* lessonVC = (LLessonContainerViewController*) [LUtils newViewControllerWithId: @"LLessonContainerViewController"  ];
        lessonVC.position = (int)indexPath.row;
        lessonVC.prefix = [Lesson3 prefix];
        [self gotoLesson: lessonVC];
    } else if ([lesson isKindOfClass: [Lesson4 class]]) {
        LLessonContainerViewController* lessonVC = (LLessonContainerViewController*) [LUtils newViewControllerWithId: @"LLessonContainerViewController"  ];
        lessonVC.position = (int)indexPath.row;
        lessonVC.prefix = [Lesson4 prefix];
        [self gotoLesson: lessonVC];
    } else if ([lesson isKindOfClass: [Lesson5 class]]) {
        LLessonContainerViewController* lessonVC = (LLessonContainerViewController*) [LUtils newViewControllerWithId: @"LLessonContainerViewController"  ];
        lessonVC.position = (int)indexPath.row;
        lessonVC.prefix = [Lesson5 prefix];
        [self gotoLesson: lessonVC];
    } else if ([lesson isKindOfClass: [Lesson6 class]]) {
        LLessonContainerViewController* lessonVC = (LLessonContainerViewController*) [LUtils newViewControllerWithId: @"LLessonContainerViewController"  ];
        lessonVC.position = (int)indexPath.row;
        lessonVC.prefix = [Lesson6 prefix];
        [self gotoLesson: lessonVC];
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

#pragma mark - AdMob
- (BOOL) gotoLesson: (LLessonContainerViewController*) lessonVC {
    [self.navigationController pushViewController: lessonVC animated: YES];
    return YES;
}

@end
