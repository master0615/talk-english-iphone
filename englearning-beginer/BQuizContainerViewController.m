//
//  ViewController.m
//  englearning-kids
//
//  Created by alex on 8/13/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BQuizContainerViewController.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "BVideoViewController.h"
#import "NSTimer+Block.h"
#import "BQuiz1ViewController.h"
#import "BQuiz2ViewController.h"
#import "LUtils.h"
#import "UIUtils.h"
#import "BLesson.h"
#import "AppDelegate.h"
#import "BAdsTimeCounter.h"

@interface BQuizContainerViewController () <AVAudioPlayerDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, strong) UIPageViewController* pageVC;
@property (nonatomic, strong) UIViewController* currentVC;
@property (nonatomic, strong) UIViewController* portraitVC;
@property (nonatomic, strong) UIViewController* landscapeVC;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioPlayer *resultPlayer;
@property (nonatomic, strong) NSTimer *progressMonitor;
@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet UIView *resultView0;
@end

@implementation BQuizContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [[UIImage imageNamed: @"ic_toolbar_goback"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(onClickGoBack)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"nav_back"] style: UIBarButtonItemStylePlain target:self action:@selector(onClickGoBack)];
    
    [self setTitleBar];
    [self setRightBarButton];
    _guideVideoPlayed = 0;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void) setTitleBar {
    self.title =  @"Quiz";
}
- (void) setRightBarButton {
    int type = QUIZ;
    
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
- (void) showVideo: (NSString*) videoFile {
    _guideVideoPlayed = 1;
    BVideoViewController* vc = (BVideoViewController*)[LUtils newViewControllerWithId: @"BVideoViewController" In: @"Learning"];
    vc.videoFile = videoFile;
    vc.view.backgroundColor = [UIColor clearColor];
    [vc setModalPresentationStyle: UIModalPresentationCustom];
    [self.navigationController presentViewController: vc animated: YES completion: nil];
}
- (void) setScreen {
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

    if (self.screen == QUIZ1) {
        if (self.portraitVC == nil || ![_portraitVC isKindOfClass: [BQuiz1ViewController class]]) {
            self.portraitVC = [LUtils newViewControllerWithIdForBegin:@"Quiz1ViewController"];
        }
        if (self.landscapeVC == nil || ![_landscapeVC isKindOfClass: [BQuiz1ViewController class]]) {
            self.landscapeVC = [LUtils newViewControllerWithIdForBegin:@"Quiz1ViewController"];
        }if (UIInterfaceOrientationIsLandscape(orientation)) {
            [self.pageVC setViewControllers:@[self.landscapeVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            self.currentVC = self.landscapeVC;
            ((BQuiz1ViewController*)_currentVC).containerVC = self;
        } else if (UIInterfaceOrientationIsPortrait(orientation)) {
            [self.pageVC setViewControllers:@[self.portraitVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            self.currentVC = self.portraitVC;
            ((BQuiz1ViewController*)_currentVC).containerVC = self;
        }
    } else if (self.screen == QUIZ2) {
        if (self.portraitVC == nil || ![_portraitVC isKindOfClass: [BQuiz2ViewController class]]) {
            self.portraitVC = [LUtils newViewControllerWithIdForBegin:@"Quiz2ViewController"];
        }
        if (self.landscapeVC == nil || ![_landscapeVC isKindOfClass: [BQuiz2ViewController class]]) {
            self.landscapeVC = [LUtils newViewControllerWithIdForBegin:@"Quiz2ViewController"];
        }
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            [self.pageVC setViewControllers:@[self.landscapeVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            self.currentVC = self.landscapeVC;
            ((BQuiz2ViewController*)_currentVC).containerVC = self;
        } else if (UIInterfaceOrientationIsPortrait(orientation)) {
            [self.pageVC setViewControllers:@[self.portraitVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            self.currentVC = self.portraitVC;
            ((BQuiz2ViewController*)_currentVC).containerVC = self;
        }
    }
}
- (void) adsDismissed {
    
    [self gotoNextQuiz];
}
- (void) gotoNextQuiz {
    if (self.screen == QUIZ1) {
        BQuizContainerViewController* vc = (BQuizContainerViewController*) [LUtils newViewControllerWithIdForBegin: @"BQuizContainerViewController"];
        vc.screen = QUIZ2;
        vc.session = 0x31;
        vc.quiz2Stat = [[BQuiz2Stat alloc] init];
        [_lesson loadQuizzes2];
        vc.lesson = _lesson;
        vc.backToVC = _backToVC;
        [self.navigationController pushViewController: vc animated: YES];
        
    } else if (self.screen == QUIZ2) {
        if ([_lesson calculateStars] == 0) {
            
        } else {
            _lesson.section = 4;
        }
        if (_backToVC != nil) {
            [self.navigationController popToViewController: _backToVC animated: YES];
            if ([_lesson calculateStars] > 0) {
                if ([_backToVC isKindOfClass: [BLessonsListContainerViewController class]]) {
                    ((BLessonsListContainerViewController*)(_backToVC)).activeNumber = _lesson.number;
                    ((BLessonsListContainerViewController*)(_backToVC)).activeSession = 0x40;
                }
            }
        } else {
            [self.navigationController popViewControllerAnimated: YES];
        }
    }
}
- (void) gotoNext {
    [self stopAudio];
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
//            return;
//        }
//    } else {
//
//    }
    [self gotoNextQuiz];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.barTintColor = RGB(0, 162, 79);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [self setTitleBar];
    [self setRightBarButton];
    [self setScreen];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [BAnalytics sendScreenName:@"Quiz Screen"];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stopAudio];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) onClickBookmark {
    
    int type = QUIZ;
    BOOL bookmark = [_lesson bookmark: type];
    [_lesson bookmark: !bookmark type: type];
    [self setRightBarButton];
    [BAnalytics sendEvent: @"Bookmark pressed" label: @"Quiz"];
}
- (void) onClickGoBack {
    [self.navigationController popViewControllerAnimated: YES];
    [BAnalytics sendEvent: @"Back pressed" label: @"Quiz"];
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
}
- (void) viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self setScreen];
    if (self.currentVC != nil && [self.currentVC isKindOfClass: [BQuiz1ViewController class]]) {
        [(BQuiz1ViewController*)_currentVC refresh];
    }
    if (self.currentVC != nil && [self.currentVC isKindOfClass: [BQuiz2ViewController class]]) {
        [(BQuiz2ViewController*)_currentVC refresh];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"SSID_QuizContainer"]) {
        
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
- (void) showQuizResult {
    NSString* path = [[NSBundle mainBundle] pathForResource: @"session_completed" ofType: @"mp3"];
    if ([_lesson calculateStars] == 0) {
        path = [[NSBundle mainBundle] pathForResource: @"try_again" ofType: @"wav"];
        NSURL* url = [NSURL fileURLWithPath: path];
        [self stopAudio];
        
        NSError *error;
        _resultPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [_resultPlayer setDelegate:self];
        
        if(![_resultPlayer play]) {
            [_resultPlayer stop];
            _resultPlayer = nil;
        }
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 3.5 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self stopAudio];
            _resultView0.hidden = YES;
        });
        _resultView0.hidden = NO;
    } else {
        _resultView.hidden = NO;
        path = [[NSBundle mainBundle] pathForResource: @"session_completed" ofType: @"mp3"];
        NSURL* url = [NSURL fileURLWithPath: path];
        [self stopAudio];
        
        NSError *error;
        _resultPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [_resultPlayer setDelegate:self];
        
        if(![_resultPlayer play]) {
            [_resultPlayer stop];
            _resultPlayer = nil;
        }
    }
}
- (void) playQuiz1Result {
    NSString* path = [[NSBundle mainBundle] pathForResource: @"tada" ofType: @"wav"];
    int point = [_lesson pointsForQuiz1] / 40;
    if (point >= 0 && point < 2) {
        path = [[NSBundle mainBundle] pathForResource: @"failure" ofType: @"mp3"];
    } else if (point >= 2 && point < 4) {
        path = [[NSBundle mainBundle] pathForResource: @"tada1" ofType: @"wav"];
    } else {
        path = [[NSBundle mainBundle] pathForResource: @"tada" ofType: @"wav"];
    }
    NSURL* url = [NSURL fileURLWithPath: path];
    if ([self playAudio: url]) {
        
    }
}
- (void) playQuiz2Result {
    NSString* path = [[NSBundle mainBundle] pathForResource: @"tada" ofType: @"wav"];
    BQuiz* quiz = [_lesson quiz2At: _quiz2Stat.currentPos];
    int point = quiz.point;
    if (point <= 0) {
        path = [[NSBundle mainBundle] pathForResource: @"critical" ofType: @"wav"];
    } else {
        path = [[NSBundle mainBundle] pathForResource: @"tada" ofType: @"wav"];
    }
    NSURL* url = [NSURL fileURLWithPath: path];
    if ([self playAudio: url]) {
        _quiz2Stat.busy = YES;
    }
}
- (BOOL)playAudio:(NSURL*)url {
    [BAnalytics sendEvent:@"Play Audio" label:url.absoluteString];
    [self stopAudio];
    
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
- (void) stopAudio {
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
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if(player == _audioPlayer) {
        if ([_currentVC isKindOfClass: [BQuiz1ViewController class]]) {
            [(BQuiz1ViewController*)_currentVC hideResultByAnim];
        } else if ([_currentVC isKindOfClass: [BQuiz2ViewController class]]) {
            _quiz2Stat.busy = NO;
            if (_quiz2Stat.currentPos + 1 < [_lesson numOfQuizzes2]) {
                [_quiz2Stat next];
            } else {
                if ([_lesson wasQuiz2Taken]) {
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.75 * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self showQuizResult];
                    });
                }
            }
            [(BQuiz2ViewController*)_currentVC hideResultByAnim];
        }
    } else if (player == _resultPlayer) {
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            _resultView.hidden = YES;
            _resultView0.hidden = YES;
        });
    }
}
- (void)updateAudioProgress {
    if(_audioPlayer == nil) {
    
    } else {
        NSTimeInterval duration = _audioPlayer.duration;
        NSTimeInterval current = _audioPlayer.currentTime;
        float progress;
        if(duration == 0) progress = 0;
        else {
            progress = MAX(0, MIN(1, (float)current / (float)duration));
        }
    }
}
@end
