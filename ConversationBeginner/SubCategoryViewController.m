//
//  SubCategoryViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/7/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "SubCategoryViewController.h"
#import "ECCategoryManager.h"
#import "LessonViewController.h"
#import "CurrentLessonManager.h"
#import "UIViewController+SlideMenu.h"
#import "IntroViewController.h"
#import "HTTPDownloader.h"
#import "MBProgressHUD.h"
#import "Env.h"
#import "MainCategoryViewController.h"
#import "Db.h"

@interface SubCategoryViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *lbCategoryTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewCategory;
@property (nonatomic, assign) NSInteger nWidth;
@property (nonatomic, assign) NSInteger nHeight;
@property (nonatomic, strong) NSMutableArray* arrLessons;

@end

@implementation SubCategoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarItem];
    self.nHeight = MAX(self.view.bounds.size.width, self.view.bounds.size.height);
    self.nWidth = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
    
//    self.arrLessons = (NSArray*)[[[ECCategoryManager sharedInstance] getLessonDictionary] valueForKey:self.strCategoryTitle];
    if (self.mode == 3) {
        self.arrLessons = (NSMutableArray*)[[[ECCategoryManager sharedInstance] getLessonDictionary] valueForKey:self.strCategoryTitle];
    } else {
        self.arrLessons = [[NSMutableArray alloc] init];
        NSString* query = [NSString stringWithFormat: @"SELECT * FROM Lessons Where category='%@';", self.strCategoryTitle];
        Cursor* cursor = [[Db db] prepareCursor: query];
        
        if(cursor == nil) return;
        
        while ([cursor next]) {
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
            
            [self.arrLessons addObject:values];
        }
        [cursor close];
    }
    
    self.lbCategoryTitle.text = self.strCategoryTitle;
    
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
    
// Remove share button 2018-01-27 by GoldRabbit
//    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_toolbar_share"] style:UIBarButtonItemStylePlain target:self action:@selector(doShare)];
//    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void) doShare{
    [Analytics sendEvent:@"MenuClick"
                   label:@"Share"];
    NSMutableArray * objectToShare = [[NSMutableArray alloc] init];
    [objectToShare addObject:@SHARE_CONTENT];
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
    NSString* url = [NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [Env currentAppId]];
    [objectToShare addObject:url];
    
    UIActivityViewController* controller = [[UIActivityViewController alloc] initWithActivityItems:objectToShare applicationActivities:nil];
    
    // Exclude all activities except AirDrop.
    NSArray *excludedActivities = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        //excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,                                    UIActivityTypePostToWeibo, UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    }
    
    [controller setValue:@SHARE_CONTENT forKey:@"subject"];
    controller.excludedActivityTypes = excludedActivities;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)
        controller.popoverPresentationController.sourceView = self.view;
    [self presentViewController:controller animated:YES completion:nil];
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
    [self.collectionViewCategory reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [Analytics sendScreenName:@"Sub Category Screen"];
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
    if ([segue.identifier isEqualToString:@"show"]) {
        [Analytics sendEvent:@"Lesson"
                       label:[CurrentLessonManager sharedInstance].lessonData.strLessonTitle];
    }
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
    [self.collectionViewCategory reloadData];
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.arrLessons count];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
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
        sizeCell.height = 180;
    }else{
        sizeCell.height = 100;
    }
    return sizeCell;
}

- (BOOL) isExistFile:(NSString*)strFileName{
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:strFileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:targetPath];
    NSInteger nExisted = [[NSUserDefaults standardUserDefaults] integerForKey:strFileName];
    return fileExists && (nExisted == 1);
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dictCurrentLesson = self.arrLessons[indexPath.row];
    NSString* strLessonTitle = [dictCurrentLesson valueForKey:@"LessonTitle"];
    NSDictionary* dictQuiz = [[ECCategoryManager sharedInstance] getQuizDictionary];
    NSArray* arrayCurrentQuiz = [dictQuiz valueForKey:strLessonTitle];
    
    LessonData* data = [[LessonData alloc] init];
    data.strMainCategory = self.strCategoryTitle;
    data.strSubCategory = [dictCurrentLesson objectForKey:@"SubCategory"];
    data.strLessonFirstImage = [dictCurrentLesson objectForKey:@"LessonFirstImage"];
    data.strLessonSecondImage = [dictCurrentLesson objectForKey:@"LessonSecondImage"];
    data.strLessonAudioFileName = [dictCurrentLesson objectForKey:@"LessonAudioFileName"];
    data.strLessonAudioAFileName = [dictCurrentLesson objectForKey:@"LessonAudioAFileName"];
    data.strLessonAudioBFileName = [dictCurrentLesson objectForKey:@"LessonAudioBFileName"];
    data.strLessonTitle = [dictCurrentLesson objectForKey:@"LessonTitle"];
    data.strLessonDialog = [dictCurrentLesson objectForKey:@"LessonDialog"];
    data.strLessonImage = [dictCurrentLesson objectForKey:@"LessonImage"];
    [CurrentLessonManager sharedInstance].lessonData = data;

    if (self.mode == 3) {
        NSMutableArray* quizArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 4; i ++) {
            QuizData* quizData = [[QuizData alloc] init];
            quizData.strQuestion = [arrayCurrentQuiz[i] valueForKey:@"Question"];
            quizData.strAnswer1 = [arrayCurrentQuiz[i] valueForKey:@"Answer1"];
            quizData.strAnswer2 = [arrayCurrentQuiz[i] valueForKey:@"Answer2"];
            quizData.strAnswer3 = [arrayCurrentQuiz[i] valueForKey:@"Answer3"];
            quizData.strAnswer4 = [arrayCurrentQuiz[i] valueForKey:@"Answer4"];
            quizData.nCorrectAnswer = [[arrayCurrentQuiz[i] valueForKey:@"Correct"] integerValue];
            [quizArray addObject:quizData];
        }
        [CurrentLessonManager sharedInstance].arrayQuiz = quizArray;
    } else {
        NSMutableArray* quizArray = [[NSMutableArray alloc] init];
        //    NSDictionary* dictQuiz = [[ECCategoryManager sharedInstance] getQuizDictionary];
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
        [CurrentLessonManager sharedInstance].arrayQuiz = quizArray;
    }
    
    bool bExisted = YES;
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    if (![self isExistFile:data.strLessonAudioFileName]) {
        bExisted = NO;
    }
    if (![self isExistFile:data.strLessonAudioAFileName]) {
        bExisted = NO;
    }
    if (![self isExistFile:data.strLessonAudioBFileName]) {
        bExisted = NO;
    }
    
    if (!bExisted) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Set the determinate mode to show task progress.
        hud.mode = MBProgressHUDModeDeterminate;
        hud.label.text = @"Downloading files...";
        
        NSString* strAudioBaseUrl = AUDIO_URL;
        NSString* strAudioFileUrl = [strAudioBaseUrl stringByAppendingString:data.strLessonAudioFileName];
        NSURL* urlAudioFile = [NSURL URLWithString:strAudioFileUrl];
        NSString* strAudioFileUrlA = [strAudioBaseUrl stringByAppendingString:data.strLessonAudioAFileName];
        NSURL* urlAudioFileA = [NSURL URLWithString:strAudioFileUrlA];
        NSString* strAudioFileUrlB = [strAudioBaseUrl stringByAppendingString:data.strLessonAudioBFileName];
        NSURL* urlAudioFileB = [NSURL URLWithString:strAudioFileUrlB];
        HTTPDownloader* downloader = [[HTTPDownloader alloc] initWithUrl:urlAudioFile targetPath:[documentsDirectory stringByAppendingPathComponent:data.strLessonAudioFileName] userAgent:nil];
        [downloader startWithProgressBlock:^(int64_t totalSize, int64_t downloadedSize) {
            float fProgress = (float)((double)downloadedSize / (double)totalSize) / 3.0f;
            hud.progress = fProgress;
        } completionBlock:^(BOOL success, int64_t totalSize, int64_t downloadedSize) {
            if (totalSize == downloadedSize) {
                NSLog(@"Download complete");
                [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:data.strLessonAudioFileName];
                [[NSUserDefaults standardUserDefaults] synchronize];
                HTTPDownloader* downloaderA = [[HTTPDownloader alloc] initWithUrl:urlAudioFileA targetPath:[documentsDirectory stringByAppendingPathComponent:data.strLessonAudioAFileName] userAgent:nil];
                [downloaderA startWithProgressBlock:^(int64_t totalSize, int64_t downloadedSize) {
                    float fProgress = ((float)((double)downloadedSize / (double)totalSize) + 1.0f) / 3.0f;
                    hud.progress = fProgress;
                } completionBlock:^(BOOL success, int64_t totalSize, int64_t downloadedSize) {
                    if (totalSize == downloadedSize) {
                        NSLog(@"Download A complete");
                        [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:data.strLessonAudioAFileName];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        HTTPDownloader* downloaderB = [[HTTPDownloader alloc] initWithUrl:urlAudioFileB targetPath:[documentsDirectory stringByAppendingPathComponent:data.strLessonAudioBFileName] userAgent:nil];
                        [downloaderB startWithProgressBlock:^(int64_t totalSize, int64_t downloadedSize) {
                            float fProgress = ((float)((double)downloadedSize / (double)totalSize) + 2.0f) / 3.0f;
                            hud.progress = fProgress;
                        } completionBlock:^(BOOL success, int64_t totalSize, int64_t downloadedSize) {
                            if (totalSize == downloadedSize) {
                                NSLog(@"Download B complete");
                                [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:data.strLessonAudioBFileName];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                IntroViewController *mainVC = [self.navigationController.viewControllers objectAtIndex:0];
                                if (mainVC != nil) {
                                    [mainVC showLessonPage:self];
                                }
                                [hud hideAnimated:YES];
                            }else{
                                [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:data.strLessonAudioBFileName];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                                message:@"Failed to download audio files.\nPleas check your internet connection"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                                [hud hideAnimated:YES];
                            }
                        }];
                    }else{
                        [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:data.strLessonAudioAFileName];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:@"Failed to download audio files.\nPleas check your internet connection"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        [hud hideAnimated:YES];
                    }
                }];
            } else{
                [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:data.strLessonAudioFileName];
                [[NSUserDefaults standardUserDefaults] synchronize];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Failed to download audio files.\nPleas check your internet connection"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [hud hideAnimated:YES];
            }
        }];
    }else{
        IntroViewController *mainVC = [self.navigationController.viewControllers objectAtIndex:0];
        if (mainVC != nil) {
            [mainVC showLessonPage:self];
        }
    }
}


@end
