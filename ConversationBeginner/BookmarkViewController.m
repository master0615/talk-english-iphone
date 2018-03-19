//
//  BookmarkViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/16/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "BookmarkViewController.h"
#import "UIViewController+SlideMenu.h"
#import "ECCategoryManager.h"
#import "LessonViewController.h"
#import "CurrentLessonManager.h"
#import "Database.h"
#import "Db.h"

@interface BookmarkViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *lbNoItem;
@property (nonatomic, assign) NSInteger nWidth;
@property (nonatomic, assign) NSInteger nHeight;
@property (nonatomic, strong) NSMutableArray* arrLessons;
@end

@implementation BookmarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarItem];

    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(-130,0,200,32)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 180, 32)];
    lb.textAlignment = NSTextAlignmentCenter;
    [iv addSubview:lb];
    lb.text = @"English Speaking Practice";
    lb.textColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 13, 24)];
    [btn setBackgroundImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [btn addTarget:self
            action:@selector(myAction)
  forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnBig = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 60, 34)];
    [btnBig addTarget:self
               action:@selector(myAction)
     forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:btnBig];
    
    [iv addSubview:lb];
    [iv addSubview:btn];
    self.navigationItem.titleView = iv;
    
    self.nHeight = MAX(self.view.bounds.size.width, self.view.bounds.size.height);
    self.nWidth = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
    //self.navigationItem.title = @"English Converstaion";
    self.arrLessons = [NSMutableArray new];
}



- (void) myAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeOrientation:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [self.arrLessons removeAllObjects];
    NSArray* array = [[Database sharedInstance] getBookmark];
    if (array.count > 0) {
        for (NSDictionary* item in array) {
            NSString* strMain = [item valueForKey:@"MAIN"];
            NSString* strSub = [item valueForKey:@"SUB"];
            NSString* strTitle = [item valueForKey:@"TITLE"];
            
            NSString* query = [NSString stringWithFormat: @"SELECT * FROM Lessons Where category='%@';", strMain];
            Cursor* cursor = [[Db db] prepareCursor: query];
            
            if(cursor == nil) continue;
            
            while ([cursor next]) {
                
                NSString* strSubCategory = [cursor getString:@"SubCategory"];
                NSString* strLessonTitle = [cursor getString:@"Title"];
                if ([strSubCategory isEqualToString:strSub] && [strLessonTitle isEqualToString:strTitle]) {
                    
                    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
                    
                    values[@"SubCategory"] = [cursor getString:@"SubCategory"];
                    values[@"LessonImage"] = [cursor getString:@"Image"];
                    values[@"LessonTitle"] = [cursor getString:@"Title"];
                    
                    values[@"LessonFirstImage"] = [cursor getString:@"First"];
                    values[@"LessonSecondImage"] = [cursor getString:@"Second"];
                    values[@"LessonAudioFileName"] = [cursor getString:@"ChannelAll"];
                    values[@"LessonAudioAFileName"] = [cursor getString:@"ChannelA"];
                    values[@"LessonAudioBFileName"] = [cursor getString:@"ChannelB"];
                    values[@"LessonDialog"] = [cursor getString:@"Dialogue"];
                    values[@"MainCategory"] = strMain;
                    
                    [self.arrLessons addObject:values];
                    break;
                }
                
            }
            [cursor close];
            
            NSMutableArray* mode3lessons = (NSMutableArray*)[[[ECCategoryManager sharedInstance] getLessonDictionary] valueForKey:strMain];
            
            for (NSDictionary* lesson in mode3lessons) {
                NSString* strSubCategory = lesson[@"SubCategory"];
                NSString* strLessonTitle = lesson[@"LessonTitle"];
                if ([strSubCategory isEqualToString:strSub] && [strLessonTitle isEqualToString:strTitle]) {
                    [self.arrLessons addObject:lesson];
                }
            }
            
        }
        self.collectionView.hidden = NO;
        self.lbNoItem.hidden = YES;
    } else {
        self.collectionView.hidden = YES;
        self.lbNoItem.hidden = NO;
    }
    [self.collectionView reloadData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [Analytics sendScreenName:@"Bookmark Screen"];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (void)didChangeOrientation:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        NSLog(@"Landscape");
    }
    else {
        NSLog(@"Portrait");
    }
    [self.collectionView reloadData];
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.arrLessons count];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookmarkCell" forIndexPath:indexPath];
    UIView* view = [cell viewWithTag:1249];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)){
        if (indexPath.row % 2 == 0) {
            view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:217.0f/255.0f blue:218.0f/255.0f alpha:1.0f];
        }else{
            view.backgroundColor = [UIColor whiteColor];
        }
    }else{
        if (indexPath.row % 4 == 0 || indexPath.row % 4 == 3) {
            view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:217.0f/255.0f blue:218.0f/255.0f alpha:1.0f];
        }else{
            view.backgroundColor = [UIColor whiteColor];
        }
    }
    UIImageView* img = [cell viewWithTag:1250];
    NSString* strImage = [self.arrLessons[indexPath.row] valueForKey:@"LessonImage"];
    img.image = [UIImage imageNamed:strImage];
    UILabel *labelSubCategoryTitle= [cell viewWithTag:1251];
    UILabel *labelLessonTitle = [cell viewWithTag:1252];
    labelLessonTitle.text = [self.arrLessons[indexPath.row] valueForKey:@"LessonTitle"];
    labelSubCategoryTitle.text = [self.arrLessons[indexPath.row] valueForKey:@"SubCategory"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize sizeCell = CGSizeMake(0, 0);
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        sizeCell.width = self.nHeight / 2.0f;
    }
    else {
        sizeCell.width = self.nWidth;
    }
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        sizeCell.height = 150;
    }else{
        sizeCell.height = 100;
    }
    return sizeCell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dictCurrentLesson = self.arrLessons[indexPath.row];
    NSString* strLessonTitle = [dictCurrentLesson valueForKey:@"LessonTitle"];
    LessonData* data = [[LessonData alloc] init];
    data.strMainCategory = [dictCurrentLesson valueForKey:@"MainCategory"];
    data.strSubCategory = [dictCurrentLesson valueForKey:@"SubCategory"];
    data.strLessonFirstImage = [dictCurrentLesson valueForKey:@"LessonFirstImage"];
    data.strLessonSecondImage = [dictCurrentLesson valueForKey:@"LessonSecondImage"];
    data.strLessonAudioFileName = [dictCurrentLesson valueForKey:@"LessonAudioFileName"];
    data.strLessonAudioAFileName = [dictCurrentLesson valueForKey:@"LessonAudioAFileName"];
    data.strLessonAudioBFileName = [dictCurrentLesson valueForKey:@"LessonAudioBFileName"];
    data.strLessonTitle = [dictCurrentLesson valueForKey:@"LessonTitle"];
    data.strLessonDialog = [dictCurrentLesson valueForKey:@"LessonDialog"];
    data.strLessonImage = [dictCurrentLesson valueForKey:@"LessonImage"];
    [CurrentLessonManager sharedInstance].lessonData = data;
    
    NSMutableArray* quizArray = [[NSMutableArray alloc] init];
    NSString* query = [NSString stringWithFormat: @"SELECT * FROM quizz Where Title='Quiz - %@';", strLessonTitle];
    Cursor* cursor = [[Db db] prepareCursor: query];
    
    if(cursor == nil) return;
    
    while ([cursor next]) {
        QuizData* quizData = [[QuizData alloc] init];
        
        NSString* questionA =  [cursor getString:@"QuestionA"];
        if (questionA != nil) {
            quizData.strQuestion = questionA;
            quizData.strAnswer1 = [cursor getString:@"AnswerAA"];
            quizData.strAnswer2 = [cursor getString:@"AnswerAB"];
            quizData.strAnswer3 = [cursor getString:@"AnswerAC"];
            quizData.strAnswer4 = [cursor getString:@"AnswerAD"];
            NSString* canswer = [NSString stringWithFormat:@"%c", [[cursor getString:@"CorrectAnswer"] characterAtIndex:0]];
            quizData.nCorrectAnswer = [@"abcd" rangeOfString:canswer].location;
            [quizArray addObject:quizData];
        }
        
        QuizData* quizData2 = [[QuizData alloc] init];
        NSString* questionB =  [cursor getString:@"QuestionB"];
        if (questionB != nil) {
            quizData2.strQuestion = questionB;
            quizData2.strAnswer1 = [cursor getString:@"AnswerBA"];
            quizData2.strAnswer2 = [cursor getString:@"AnswerBB"];
            quizData2.strAnswer3 = [cursor getString:@"AnswerBC"];
            quizData2.strAnswer4 = [cursor getString:@"AnswerBD"];
            NSString* canswer = [NSString stringWithFormat:@"%c", [[cursor getString:@"CorrectAnswer"] characterAtIndex:1]];
            quizData2.nCorrectAnswer = [@"abcd" rangeOfString:canswer].location;
            [quizArray addObject:quizData2];
        }
        
        QuizData* quizData3 = [[QuizData alloc] init];
        NSString* questionC =  [cursor getString:@"QuestionC"];
        if (questionC != nil) {
            quizData3.strQuestion = questionC;
            quizData3.strAnswer1 = [cursor getString:@"AnswerCA"];
            quizData3.strAnswer2 = [cursor getString:@"AnswerCB"];
            quizData3.strAnswer3 = [cursor getString:@"AnswerCC"];
            quizData3.strAnswer4 = [cursor getString:@"AnswerCD"];
            NSString* canswer = [NSString stringWithFormat:@"%c", [[cursor getString:@"CorrectAnswer"] characterAtIndex:2]];
            quizData3.nCorrectAnswer = [@"abcd" rangeOfString:canswer].location;
            [quizArray addObject:quizData3];
        }
        
        QuizData* quizData4 = [[QuizData alloc] init];
        NSString* questionD =  [cursor getString:@"QuestionD"];
        if (questionD != nil) {
            quizData4.strQuestion = questionD;
            quizData4.strAnswer1 = [cursor getString:@"AnswerDA"];
            quizData4.strAnswer2 = [cursor getString:@"AnswerDB"];
            quizData4.strAnswer3 = [cursor getString:@"AnswerDC"];
            quizData4.strAnswer4 = [cursor getString:@"AnswerDD"];
            NSString* canswer = [NSString stringWithFormat:@"%c", [[cursor getString:@"CorrectAnswer"] characterAtIndex:3]];
            quizData4.nCorrectAnswer = [@"abcd" rangeOfString:canswer].location;
            [quizArray addObject:quizData4];
        }
        
        break;
    }
    [cursor close];
    
    
    [self performSegueWithIdentifier:@"show" sender:nil];
    [Analytics sendEvent:@"Bookmark"
                   label:[CurrentLessonManager sharedInstance].lessonData.strLessonTitle];
}


@end
