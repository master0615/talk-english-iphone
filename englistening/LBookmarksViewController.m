//
//  LessonsListViewController.m
//  englistening
//
//  Created by alex on 5/4/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LBookmarksViewController.h"
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

@interface LBookmarksViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *descriptionWebView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *lessonsListTableView;
@property (nonatomic, strong) NSArray* lessonsList;
@end

@implementation LBookmarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [LAnalytics sendScreenName:@"Bookmarks Screen"];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    NSMutableArray* lessons0 = [[NSMutableArray alloc] init];
    [lessons0 addObjectsFromArray: [Lesson1 loadAll]];
    [lessons0 addObjectsFromArray: [Lesson2 loadAll]];
    [lessons0 addObjectsFromArray: [Lesson3 loadAll]];
    [lessons0 addObjectsFromArray: [Lesson4 loadAll]];
    [lessons0 addObjectsFromArray: [Lesson5 loadAll]];
    [lessons0 addObjectsFromArray: [Lesson6 loadAll]];
    NSMutableArray* lessons = [[NSMutableArray alloc] init];
    for (Lesson* lesson in lessons0) {
        if (lesson.bookmark) {
            [lessons addObject: lesson];
        }
    }
    self.lessonsList = [[NSArray alloc] initWithArray: lessons];
    if ([lessons count] <= 0) {
        self.lessonsListTableView.hidden = YES;
        self.descriptionWebView.hidden = NO;
    } else {
        self.lessonsListTableView.hidden = NO;
        self.descriptionWebView.hidden = YES;
     
    }
    NSString* htmlFile = [[NSBundle mainBundle] pathForResource: @"bookmark_comment" ofType: @"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile: htmlFile encoding: NSUTF8StringEncoding error: nil];
    [self.descriptionWebView loadHTMLString: htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
    [self.lessonsListTableView reloadData];
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
    NSString* htmlFile = [[NSBundle mainBundle] pathForResource: @"bookmark_comment" ofType: @"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile: htmlFile encoding: NSUTF8StringEncoding error: nil];
    [self.descriptionWebView loadHTMLString: htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
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
    UILabel* sectionLabel = (UILabel*) [cell viewWithTag: 5065];
    UILabel* titleLabel = (UILabel*) [cell viewWithTag: 5062];
    UILabel* descriptionLabel = (UILabel*) [cell viewWithTag: 5063];
    LPointBadgeView* pbView = (LPointBadgeView*) [cell viewWithTag: 5241];
    Lesson* lesson = (Lesson*) [self.lessonsList objectAtIndex: indexPath.row];
    image.image = [UIImage imageNamed: lesson.image];
    [sectionLabel setText: [lesson.sectionTitle uppercaseString]];
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
    int position = [lesson.number intValue] - 1;
    if ([lesson isKindOfClass: [Lesson1 class]]) {
        LLessonContainerViewController* lessonVC = (LLessonContainerViewController*) [LUtils newViewControllerWithId: @"LLessonContainerViewController"  ];
        lessonVC.position = position;
        lessonVC.prefix = [Lesson1 prefix];
        [self.navigationController pushViewController: lessonVC animated: YES];        
    } else if ([lesson isKindOfClass: [Lesson2 class]]) {
        LLessonContainerViewController* lessonVC = (LLessonContainerViewController*) [LUtils newViewControllerWithId: @"LLessonContainerViewController"  ];
        lessonVC.position = position;
        lessonVC.prefix = [Lesson2 prefix];
        [self.navigationController pushViewController: lessonVC animated: YES];
    } else if ([lesson isKindOfClass: [Lesson3 class]]) {
        LLessonContainerViewController* lessonVC = (LLessonContainerViewController*) [LUtils newViewControllerWithId: @"LLessonContainerViewController"  ];
        lessonVC.position = position;
        lessonVC.prefix = [Lesson3 prefix];
        [self.navigationController pushViewController: lessonVC animated: YES];
    } else if ([lesson isKindOfClass: [Lesson4 class]]) {
        LLessonContainerViewController* lessonVC = (LLessonContainerViewController*) [LUtils newViewControllerWithId: @"LLessonContainerViewController"  ];
        lessonVC.position = position;
        lessonVC.prefix = [Lesson4 prefix];
        [self.navigationController pushViewController: lessonVC animated: YES];
    } else if ([lesson isKindOfClass: [Lesson5 class]]) {
        LLessonContainerViewController* lessonVC = (LLessonContainerViewController*) [LUtils newViewControllerWithId: @"LLessonContainerViewController"  ];
        lessonVC.position = position;
        lessonVC.prefix = [Lesson5 prefix];
        [self.navigationController pushViewController: lessonVC animated: YES];
    } else if ([lesson isKindOfClass: [Lesson6 class]]) {
        LLessonContainerViewController* lessonVC = (LLessonContainerViewController*) [LUtils newViewControllerWithId: @"LLessonContainerViewController"  ];
        lessonVC.position = position;
        lessonVC.prefix = [Lesson6 prefix];
        [self.navigationController pushViewController: lessonVC animated: YES];
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

@end
