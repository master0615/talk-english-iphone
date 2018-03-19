//
//  ViewController.m
//  englearning-kids
//
//  Created by alex on 8/13/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BLessonStartContainerViewController.h"
#import "BLessonStartViewController.h"
#import "BUnderstoodViewController.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "NSTimer+Block.h"
#import "BLessonDataManager.h"

#import "AppDelegate.h"
#import "UIUtils.h"
#import "LUtils.h"
#import "BLesson.h"
#import "BDownloadProgressViewController.h"

@interface BLessonStartContainerViewController () <AVAudioPlayerDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource, BDownloadingProgressDelegate>
@property (nonatomic, strong) UIPageViewController* pageVC;
@property (nonatomic, strong) UIViewController* currentVC;
@property (nonatomic, strong) UIViewController* portraitVC;
@property (nonatomic, strong) UIViewController* landscapeVC;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioPlayer *resultPlayer;
@property (nonatomic, strong) NSTimer *progressMonitor;
@property (weak, nonatomic) IBOutlet UIImageView *starImage0;
@property (weak, nonatomic) IBOutlet UIImageView *starImage1;
@property (weak, nonatomic) IBOutlet UIImageView *starImage2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starHeight0;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starHeight1;
@property (weak, nonatomic) IBOutlet UIView *resultView;

@property (nonatomic, strong) NSString* gotoWhere;
@property (nonatomic, strong) NSObject* tempMeta1;
@end

@implementation BLessonStartContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [[UIImage imageNamed: @"nav_back"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(onClickGoBack)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"nav_back"] style: UIBarButtonItemStylePlain target:self action:@selector(onClickGoBack)];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    
    [self setTitleBar];
    [self setRightBarButton];
}
- (void) downloadCompletedFor: (int) lessonNumber {
    BLessonStartContainerViewController* vc = (BLessonStartContainerViewController*)[LUtils newViewControllerWithIdForBegin: @"BLessonStartContainerViewController"];
    BLesson* entry = nil;
    NSArray *lessons = [BLesson loadAll:_lesson.level];
    for (BLesson* lesson in lessons) {
        if (lesson.number == lessonNumber) {
            entry = lesson;
            break;
        }
    }
    if (entry != nil) {
        self.lesson = entry;
        vc.session = 0x00;
        vc.screen = STARTING;
        vc.showProgress = NO;
        vc.backToVC = [BLessonsListContainerViewController singleton];
        
        [self setScreen];
    }
}
- (void) downloadFailedFor: (int) lessonNumber {
    [self onClickGoBack];
}
- (void) callDownloadProgress {
    if (![[BLessonDataManager sharedInstance] wasLessonPrepared: _lesson.number]) {
        BDownloadProgressViewController *_downloadVC = (BDownloadProgressViewController*)[LUtils newViewControllerWithIdForBegin: @"DownloadProgressViewController"];
        _downloadVC.view.backgroundColor = [UIColor clearColor];
        _downloadVC.delegate = self;
        _downloadVC.lessonNumber = _lesson.number;
        
        [_downloadVC setModalPresentationStyle: UIModalPresentationCustom];
        [self presentViewController: _downloadVC animated: NO completion:^{
            [BLessonDataManager sharedInstance].delegate = _downloadVC;
            [[BLessonDataManager sharedInstance] downloadForLesson:_lesson.number first:YES];
        }];
        
        return;
    }
    NSArray *lessons = [BLesson loadAll:_lesson.level];
    BLesson *lastLesson = [lessons objectAtIndex:lessons.count - 1];
    if (_lesson != lastLesson && ![[BLessonDataManager sharedInstance] wasLessonPrepared: _lesson.number + 1]) {
        [[BLessonDataManager sharedInstance] downloadForLesson:_lesson.number + 1 first:NO];
    }
}
- (void) setTitleBar {
    if (_session == 0x00) {
        self.title =  self.lesson.title;
    } else if ((_session&0x40) != 0) {
        self.title = @"Final Check";
    }
}
- (void) setRightBarButton {
    int type = STUDY_SESSION1;
    if (_session == 0x00) {
        /*self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [[UIImage imageNamed: @"ic_toolbar_empty"] imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate] style: UIBarButtonItemStylePlain target:self action: nil];
        self.navigationItem.rightBarButtonItem.tintColor = self.navigationController.navigationBar.barTintColor;
        return;*/
        type = START_LESSON;
    } else if ((_session&0x40) != 0) {
        type = FINAL_CHECK;
    }
    
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;
    
    BOOL bookmark = [_lesson bookmark: type];
    NSString* image = bookmark ? @"ic_toolbar_bookmark_on" : @"ic_toolbar_bookmark_off";
    UIBarButtonItem *bookmarkButton = [[UIBarButtonItem alloc] initWithImage: [[UIImage imageNamed: image] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(onClickBookmark)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, bookmarkButton, nil];
}
- (void) setScreen {
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

    if (self.screen == STARTING) {
        if (self.portraitVC == nil || ![_portraitVC isKindOfClass: [BLessonStartViewController class]]) {
            self.portraitVC = [LUtils newViewControllerWithIdForBegin:@"BLessonStartViewController"];
        }
        if (self.landscapeVC == nil || ![_landscapeVC isKindOfClass: [BLessonStartViewController class]]) {
            self.landscapeVC = [LUtils newViewControllerWithIdForBegin:@"BLessonStartViewController0"];
        }
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            [self.pageVC setViewControllers:@[self.landscapeVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            self.currentVC = self.landscapeVC;
            ((BLessonStartViewController*)_currentVC).containerVC = self;
        } else if (UIInterfaceOrientationIsPortrait(orientation)) {
            self.currentVC = self.portraitVC;
            ((BLessonStartViewController*)_currentVC).containerVC = self;
            [self.pageVC setViewControllers:@[self.portraitVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
        }
    } else if (self.screen == UNDERSTOOD) {
        if (self.portraitVC == nil || ![_portraitVC isKindOfClass: [BUnderstoodViewController class]]) {
            self.portraitVC = [LUtils newViewControllerWithIdForBegin:@"BUnderstoodViewController"];
        }
        if (self.landscapeVC == nil || ![_landscapeVC isKindOfClass: [BUnderstoodViewController class]]) {
            self.landscapeVC = [LUtils newViewControllerWithIdForBegin:@"BUnderstoodViewController"];
        }
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            [self.pageVC setViewControllers:@[self.landscapeVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            self.currentVC = self.landscapeVC;
            ((BUnderstoodViewController*)_currentVC).containerVC = self;
        } else if (UIInterfaceOrientationIsPortrait(orientation)) {
            [self.pageVC setViewControllers:@[self.portraitVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            self.currentVC = self.portraitVC;
            ((BUnderstoodViewController*)_currentVC).containerVC = self;
        }
    }
}
- (void) adsDismissed {
    [self gotoScreen: self.gotoWhere meta: self.tempMeta1];
}
- (void) gotoScreen: (NSString*) screen meta: (NSObject*) meta {
    if (screen == nil) {
        return;
    }
    if ([screen isEqualToString: @"understood"]) {
        BLessonStartContainerViewController* vc = (BLessonStartContainerViewController*) [LUtils newViewControllerWithIdForBegin: @"BLessonStartContainerViewController"];
        vc.screen = UNDERSTOOD;
        vc.session = _session;
        vc.backToVC = _backToVC;
        vc.lesson = _lesson;
        vc.checkedLevel = -1;
        [self.navigationController pushViewController: vc animated: YES];
    } else if ([screen isEqualToString: @"goback"]) {
        if (self.backToVC != nil) {
            [self.navigationController popToViewController: _backToVC animated: NO];
            if (meta != nil && _backToVC != nil && [_backToVC isKindOfClass: [BLessonsListContainerViewController class]]) {
                int index = _lesson.number;
                int level = _lesson.level;
                if (index/10 + 1 > level) {
                    [(BLessonsListContainerViewController*)(_backToVC) gotoLevel: level+1];
                }
            }
        } else {
            [self.navigationController popViewControllerAnimated: YES];
        }
    } else if ([screen isEqualToString: @"gotoSession"]) {
        if (_session == 0x00 || _session == 0x40) {
            _lesson.section = 1;
            if (_backToVC != nil) {
                [self.navigationController popToViewController: _backToVC animated: NO];
                if ([_backToVC isKindOfClass: [BLessonsListContainerViewController class]]) {
                    ((BLessonsListContainerViewController*)(_backToVC)).activeNumber = _lesson.number;
                    ((BLessonsListContainerViewController*)(_backToVC)).activeSession = 0x10;
                    [(BLessonsListContainerViewController*)(_backToVC) gotoSession: 0x10 forLesson: _lesson];
                }
            } else {
                [self.navigationController popViewControllerAnimated: YES];
            }
        }
    } else if ([screen isEqualToString: @"gotoQuiz"]) {
        if (_backToVC != nil) {
            [self.navigationController popToViewController: _backToVC animated: NO];
            if ([_backToVC isKindOfClass: [BLessonsListContainerViewController class]]) {
                ((BLessonsListContainerViewController*)(_backToVC)).activeNumber = _lesson.number;
                ((BLessonsListContainerViewController*)(_backToVC)).activeSession = 0x30;
                [(BLessonsListContainerViewController*)(_backToVC) gotoQuiz: 0x30 forLesson: _lesson];
            }
        } else {
            [self.navigationController popViewControllerAnimated: YES];
        }
    }
}
- (void) gotoNext {
    [self stopLessonAudio];
//    int isPurchased = [SharedPref intForKey: @"isPurchased" default: 0];
//    if ((isPurchased&0x5) == 0) {
//        NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
//        if ([APPDELEGATE isNull_InterstitialAd] || ![APPDELEGATE isReady_InterstitialAd] || timestamp <= [BAdsTimeCounter lastTimeAdShown] + MIN_INTERVAL) {
//            if(![APPDELEGATE isReady_InterstitialAd] && timestamp > [BAdsTimeCounter lastTimeLoadTried] + MIN_RETRY_INTERVAL) {
//                [APPDELEGATE loadAd];
//            }
//        } else {
//            APPDELEGATE.delegate = self;
//            [APPDELEGATE showInterstitialAd: self];
//            [BAdsTimeCounter setLastTimeAdShown: timestamp];
//            if (self.screen == STARTING) {
//                self.gotoWhere = @"understood";
//            } else if (self.screen == UNDERSTOOD) {
//                self.gotoWhere = @"gotoSession";
//            }
//            self.tempMeta1 = nil;
//            return;
//        }
//    } else {
//        
//    }
    if (self.screen == STARTING) {
        [self gotoScreen: @"understood" meta: nil];
    } else if (self.screen == UNDERSTOOD) {
        [self gotoScreen: @"gotoSession" meta: nil];
    }
}
- (void) gotoQuiz {
    [self stopLessonAudio];
    _lesson.section = 3;
    [_lesson takeSession1];
    [_lesson takeSession2];
//    int isPurchased = [SharedPref intForKey: @"isPurchased" default: 0];
//    if ((isPurchased&0x5) == 0) {
//        NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
//        if ([APPDELEGATE isNull_InterstitialAd] || ![APPDELEGATE isReady_InterstitialAd] || timestamp <= [BAdsTimeCounter lastTimeAdShown] + MIN_INTERVAL) {
//            if(![APPDELEGATE isReady_InterstitialAd] && timestamp > [BAdsTimeCounter lastTimeLoadTried] + MIN_RETRY_INTERVAL) {
//                [APPDELEGATE loadAd];
//            }
//        } else {
//            APPDELEGATE.delegate = self;
//            [APPDELEGATE showInterstitialAd: self];
//            [BAdsTimeCounter setLastTimeAdShown: timestamp];
//            self.gotoWhere = @"gotoQuiz";
//            self.tempMeta1 = nil;
//            return;
//        }
//    } else {
//
//    }
    [self gotoScreen: @"gotoQuiz" meta: nil];
    
}
- (void) completeLesson {
    [_lesson complete];
    [_lesson contract];
    if (_lesson.next != nil) {
        [_lesson.next setStudying];
    }
    if ([_lesson stars] == 1) {
        _starImage1.hidden = YES;
        _starImage2.hidden = YES;
        _starImage0.hidden = NO;
    } else if ([_lesson stars] == 2) {
        _starHeight0.constant = 1;
        _starImage1.hidden = NO;
        _starImage2.hidden = NO;
        _starImage0.hidden = YES;
    } else if ([_lesson stars] == 3) {
        _starImage1.hidden = NO;
        _starImage2.hidden = NO;
        _starImage0.hidden = NO;
    }
    _resultView.hidden = NO;
    NSString* path = [[NSBundle mainBundle] pathForResource: @"completed" ofType: @"wav"];
    NSURL* url = [NSURL fileURLWithPath: path];
    [self stopLessonAudio];
    
    NSError *error;
    _resultPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [_resultPlayer setDelegate:self];
    
    if(![_resultPlayer play]) {
        [_resultPlayer stop];
        _resultPlayer = nil;
    }
    
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self setTitleBar];
    [self setRightBarButton];
    
    [self callDownloadProgress];
    [self setScreen];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [BAnalytics sendScreenName:@"Lesson Start Screen"];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stopLessonAudio];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) onClickBookmark {
    int type = FINAL_CHECK;
    if (_session == 0x00) {
        type = START_LESSON;
    } else if ((_session&0x40) != 0) {
        type = FINAL_CHECK;
    }
    BOOL bookmark = [_lesson bookmark: type];
    [_lesson bookmark: !bookmark type: type];
    [self setRightBarButton];
    [BAnalytics sendEvent: @"Bookmark pressed" label: @"Final Check"];
}
- (void) onClickGoBack {
    [self.navigationController popViewControllerAnimated: YES];
    [BAnalytics sendEvent: @"Back pressed" label: (_session==0x00)?@"Start Lesson!":@"Final Check"];
}
- (void) setTitle:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.bounds.size.width-90, self.navigationController.view.bounds.size.height)];
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName: @"NanumBarunGothicOTFBold" size: 20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.minimumScaleFactor = 0.75;
    titleLabel.adjustsFontSizeToFitWidth = NO;
    self.navigationItem.titleView = titleLabel;
    [self.navigationItem setTitleView:titleLabel];
    //[self.navigationItem setTitle:title];
    //self.navigationItem.title = title;
    if (self.screen == STARTING) {
        self.navigationController.navigationBar.barTintColor = RGB(44, 45, 50);
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        titleLabel.textColor = [UIColor whiteColor];
    }
    else if ( self.screen == UNDERSTOOD) {
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.tintColor = RGB(44, 45, 50);
        titleLabel.textColor = RGB(44, 45, 50);
    }
}
- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self setScreen];
    if (self.currentVC != nil && [self.currentVC isKindOfClass: [BLessonStartViewController class]]) {
        [(BLessonStartViewController*)_currentVC refresh];
    }
    if (self.currentVC != nil && [self.currentVC isKindOfClass: [BUnderstoodViewController class]]) {
        [(BUnderstoodViewController*)_currentVC refresh];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"SSID_LessonStartContainer"]) {
        
        self.checkedLevel = -1;
        self.pageVC = segue.destinationViewController;
        self.pageVC.delegate = self;
        
        [self setScreen];
    }
}
- (NSUInteger)countOfPageVC {
    return 1;
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    return nil;
}

- (void) playLessonAudio {
    BLesson* entry = _lesson;
    NSURL* url = [BLessonDataManager audio: entry.mainAudio forLesson: entry.number];
    if ([self playAudio: url]) {
        [entry increaseListenedCount];
        if (self.currentVC != nil && [self.currentVC isKindOfClass: [BLessonStartViewController class]]) {
            [(BLessonStartViewController*)_currentVC enablePlayButton: entry.listenedCount<3];
        }        
    }
}
- (BOOL)playAudio:(NSURL*)url {
    [BAnalytics sendEvent:@"Play Audio" label:url.absoluteString];
    [self stopLessonAudio];
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [_audioPlayer setDelegate:self];
    [self startAudioProgressMonitor];
    if(![_audioPlayer play]) {
        [_audioPlayer stop];
        _audioPlayer = nil;
        return NO;
    }
    return YES;
}
- (void)stopLessonAudio {
    if (_audioPlayer != nil) {
        [self stopAudioProgressMonitor];
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    if (_resultPlayer != nil) {
        [_resultPlayer stop];
        _resultPlayer = nil;
    }
}
- (void)startAudioProgressMonitor {
    [self updateAudioProgress];
    if(_progressMonitor == nil && _audioPlayer != nil) {
        NSTimeInterval duration = _audioPlayer.duration;
        
        _progressMonitor = [NSTimer scheduledTimerWithTimeInterval:duration / 250
                                                         fireBlock:^{
                                                             if(_audioPlayer == nil || ![_audioPlayer isPlaying]){
                                                                 [_progressMonitor invalidate];
                                                             }
                                                             else {
                                                                 [self updateAudioProgress];
                                                             }
                                                         }
                                                           repeats:YES];
    }
}

- (void)stopAudioProgressMonitor {
    [_progressMonitor invalidate];
    _progressMonitor = nil;
    self.showProgress = NO;
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (player == _audioPlayer) {
        if (self.currentVC != nil && [self.currentVC isKindOfClass: [BLessonStartViewController class]]) {
            [(BLessonStartViewController*)_currentVC setAudioProgress: 1];
            [(BLessonStartViewController*)_currentVC setAudioProgress: 0];
            [(BLessonStartViewController*)_currentVC showProgressConrol: NO];
            self.showProgress = NO;
        }
    } else if (player == _resultPlayer) {
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            _resultView.hidden = YES;
//            int isPurchased = [SharedPref intForKey: @"isPurchased" default: 0];
//            if ((isPurchased&0x5) == 0) {
//                NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
//                if ([APPDELEGATE isNull_InterstitialAd] || ![APPDELEGATE isReady_InterstitialAd] || timestamp <= [BAdsTimeCounter lastTimeAdShown] + MIN_INTERVAL) {
//                    if(![APPDELEGATE isReady_InterstitialAd] && timestamp > [BAdsTimeCounter lastTimeLoadTried] + MIN_RETRY_INTERVAL) {
//                        [APPDELEGATE loadAd];
//                    }
//                } else {
//                    APPDELEGATE.delegate = self;
//                    [APPDELEGATE showInterstitialAd: self];
//                    [BAdsTimeCounter setLastTimeAdShown: timestamp];
//                    self.gotoWhere = @"goback";
//                    self.tempMeta1 = @(YES);
//                    return;
//                }
//            } else {
//
//            }
            [self gotoScreen: @"goback" meta: @(YES)];
            
        });
    }
}
- (void)updateAudioProgress {
    if(_audioPlayer == nil) {
        if (self.currentVC != nil && [self.currentVC isKindOfClass: [BLessonStartViewController class]]) {
            [(BLessonStartViewController*)_currentVC showProgressConrol: YES];
            [(BLessonStartViewController*)_currentVC setAudioProgress: 0];
            self.showProgress = YES;
        }
    }
    else {
        NSTimeInterval duration = _audioPlayer.duration;
        NSTimeInterval current = _audioPlayer.currentTime;
        float progress;
        if(duration == 0) progress = 0;
        else {
            progress = MAX(0, MIN(1, (float)current / (float)duration));
        }
        if (self.currentVC != nil && [self.currentVC isKindOfClass: [BLessonStartViewController class]]) {
            self.showProgress = YES;
            [(BLessonStartViewController*)_currentVC showProgressConrol: YES];
            [(BLessonStartViewController*)_currentVC setAudioProgress: progress];
        }
    }
}
@end
