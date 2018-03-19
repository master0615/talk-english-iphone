//
//  ViewController.m
//  englearning-kids
//
//  Created by alex on 8/13/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BSessionContainerViewController.h"
#import "BListeningViewController.h"
#import "BComparingViewController.h"
#import "BExerciseViewController.h"
#import "BVideoViewController.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "AVFoundation/AVAudioRecorder.h"
#import "NSTimer+Block.h"
#import "AppDelegate.h"
#import "FileUtils.h"
#import "LUtils.h"
#import "UIUtils.h"
#import "BLesson.h"
#import "BLessonDataManager.h"

@interface BSessionContainerViewController () <AVAudioPlayerDelegate, AVAudioRecorderDelegate, BMultiProgressUpdateDelegate, BListeningProgressUpdateDelegate, BComparingProgressUpdateDelegate,  UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, strong) UIPageViewController* pageVC;
@property (nonatomic, strong) UIViewController* currentVC;
@property (nonatomic, strong) UIViewController* portraitVC;
@property (nonatomic, strong) UIViewController* landscapeVC;

@property (nonatomic, strong) AVAudioRecorder* voiceRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioPlayer* effectPlayer;
@property (nonatomic, strong) AVAudioPlayer* resultPlayer;
@property (nonatomic, strong) NSTimer* progressMonitor;

@property (weak, nonatomic) IBOutlet UIView *resultView1;
@property (weak, nonatomic) IBOutlet UIView *resultView2;
@property (nonatomic, strong) NSString* gotoWhere;
@end

@implementation BSessionContainerViewController

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

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.barTintColor = RGB(44, 45, 50);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self setTitleBar];
    [self setRightBarButton];
    [self setScreen];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [BAnalytics sendScreenName:@"Session Screen"];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_listeningPlayer != nil) {
        [_listeningPlayer stop];
        _listeningPlayer = nil;
    }
    [self stopToListen];
    [self stopToCompare];
    [self stopRecord];
    
    [self stopEffectAudio];
    [self stopAudio];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) onClickBookmark {
    int type = STUDY_SESSION1;
    if ((_session&0x10) != 0) {
        type = STUDY_SESSION1;
    } else if ((_session&0x20) != 0) {
        type = STUDY_SESSION2;
    } else if (_session == 0) {
        type = START_LESSON;
    }
    BOOL bookmark = [_lesson bookmark: type];
    [_lesson bookmark: !bookmark type: type];
    [self setRightBarButton];
}
- (void) onClickGoBack {
    [self.navigationController popViewControllerAnimated: YES];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self setScreen];
    if (_currentVC != nil && [_currentVC isKindOfClass: [BListeningViewController class]]) {
        [(BListeningViewController*)_currentVC refresh];
    } else if (_currentVC != nil && [_currentVC isKindOfClass: [BComparingViewController class]]) {
        [(BComparingViewController*)_currentVC refresh];
    } else if (_currentVC != nil && [_currentVC isKindOfClass: [BExerciseViewController class]]) {
        [(BExerciseViewController*)_currentVC refresh];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"SSID_SessionContainer"]) {
        
        self.pageVC = segue.destinationViewController;
        self.pageVC.delegate = self;
        [self setTitleBar];
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
- (void) setTitleBar {
    if ((_session&0x10) != 0) {
        self.title = @"Study Session 1/2";
    } else if ((_session&0x20) != 0) {
        self.title = @"Study Session 2/2";
    }
}
- (void) setRightBarButton {
    int type = STUDY_SESSION1;
    if ((_session&0x10) != 0) {
        type = STUDY_SESSION1;
    } else if ((_session&0x20) != 0) {
        type = STUDY_SESSION2;
    } else if (_session == 0) {
        type = START_LESSON;
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
    
    if (self.screen == LISTEING) {
        if (self.portraitVC == nil || ![_portraitVC isKindOfClass: [BListeningViewController class]]) {
            self.portraitVC = [LUtils newViewControllerWithIdForBegin:@"BListeningViewController"];
        }
        if (self.landscapeVC == nil || ![_landscapeVC isKindOfClass: [BListeningViewController class]]) {
            self.landscapeVC = [LUtils newViewControllerWithIdForBegin:@"BListeningViewController"];
        }
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            [self.pageVC setViewControllers:@[self.landscapeVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            self.currentVC = self.landscapeVC;
            ((BListeningViewController*)(_currentVC)).containerVC = self;
        } else if (UIInterfaceOrientationIsPortrait(orientation)) {
            [self.pageVC setViewControllers:@[self.portraitVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            self.currentVC = self.portraitVC;
            ((BListeningViewController*)(_currentVC)).containerVC = self;
        }
    } else if (self.screen == COMPARING) {
        if (self.portraitVC == nil || ![_portraitVC isKindOfClass: [BComparingViewController class]]) {
            self.portraitVC = [LUtils newViewControllerWithIdForBegin:@"BComparingViewController"];
        }
        if (self.landscapeVC == nil || ![_landscapeVC isKindOfClass: [BComparingViewController class]]) {
            self.landscapeVC = [LUtils newViewControllerWithIdForBegin:@"BComparingViewController"];
        }
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            [self.pageVC setViewControllers:@[self.landscapeVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            self.currentVC = self.landscapeVC;
            ((BComparingViewController*)(_currentVC)).containerVC = self;
        } else if (UIInterfaceOrientationIsPortrait(orientation)) {
            [self.pageVC setViewControllers:@[self.portraitVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            self.currentVC = self.portraitVC;
            ((BComparingViewController*)(_currentVC)).containerVC = self;
        }
    } else if (self.screen == EXERCISE) {
        if (self.portraitVC == nil || ![_portraitVC isKindOfClass: [BExerciseViewController class]]) {
            self.portraitVC = [LUtils newViewControllerWithIdForBegin:@"BExerciseViewController"];
        }
        if (self.landscapeVC == nil || ![_landscapeVC isKindOfClass: [BExerciseViewController class]]) {
            self.landscapeVC = [LUtils newViewControllerWithIdForBegin:@"BExerciseViewController"];
        }
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            [self.pageVC setViewControllers:@[self.landscapeVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            self.currentVC = self.landscapeVC;
            ((BExerciseViewController*)(_currentVC)).containerVC = self;
        } else if (UIInterfaceOrientationIsPortrait(orientation)) {
            [self.pageVC setViewControllers:@[self.portraitVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            self.currentVC = self.portraitVC;
            ((BExerciseViewController*)(_currentVC)).containerVC = self;
        }
    }
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
- (void) showVideo {
    _guideVideoPlayed = 1;
    BVideoViewController* vc = (BVideoViewController*)[LUtils newViewControllerWithIdForBegin: @"BVideoViewController"];
    vc.videoFile = @"task1";
    vc.view.backgroundColor = [UIColor clearColor];
    [vc setModalPresentationStyle: UIModalPresentationCustom];
    [self.navigationController presentViewController: vc animated: YES completion: nil];
}
- (void) adsDismissed {
    if (self.gotoWhere == nil) {
        return;
    }
    if ([self.gotoWhere isEqualToString: @"gotoNext"]) {
        [self gotoSessionScreen];
    } else if ([self.gotoWhere isEqualToString: @"gotoBack"]) {
        [self gotoBack];
    }
}
- (void) gotoSessionScreen {
    if (_screen == LISTEING) {
        BSessionContainerViewController* vc = (BSessionContainerViewController*) [LUtils newViewControllerWithIdForBegin: @"BSessionContainerViewController"];
        vc.screen = COMPARING;
        vc.comparingStat = [[BComparingStat alloc] init];
        vc.lesson = _lesson;
        vc.session = _session;
        vc.backToVC = _backToVC;
        [self.navigationController pushViewController: vc animated: YES];
    } else if (_screen == COMPARING) {
        if (_session == 0x21) {
            //goto quiz...
            _lesson.section = 3;
            [_lesson takeSession2];
            _resultView2.hidden = NO;
            [self playSessionResult];
            return;
        } else {
            BSessionContainerViewController* vc = (BSessionContainerViewController*) [LUtils newViewControllerWithIdForBegin: @"BSessionContainerViewController"];
            [_lesson loadExercises: _session];
            vc.screen = EXERCISE;
            vc.session = _session;
            vc.lesson = _lesson;
            vc.exerciseStat = [[BExerciseStat alloc] init];
            vc.backToVC = _backToVC;
            [self.navigationController pushViewController: vc animated: YES];
        }
    } else if (_screen == EXERCISE) {
        if (_session == 0x11) {
            _lesson.section = 2;
            [_lesson takeSession1];
            _resultView1.hidden = NO;
            [self playSessionResult];
            return;
        } else {
            BSessionContainerViewController* vc = (BSessionContainerViewController*) [LUtils newViewControllerWithIdForBegin: @"BSessionContainerViewController"];
            [_lesson loadListens: _session^0x01];
            vc.screen = LISTEING;
            vc.session = _session ^ 0x1;
            vc.listeningStat = [[BListeningStat alloc] init];
            vc.lesson = _lesson;
            vc.backToVC = _backToVC;
            [self.navigationController pushViewController: vc animated: YES];
        }
    }
}
- (void) gotoBack {
    if (_backToVC != nil) {
        [self.navigationController popToViewController: _backToVC animated: YES];
        if ([_backToVC isKindOfClass: [BLessonsListContainerViewController class]]) {
            ((BLessonsListContainerViewController*)(_backToVC)).activeNumber = _lesson.number;
            ((BLessonsListContainerViewController*)(_backToVC)).activeSession = _session==0x11 ? 0x20 : 0x30;
        }
    } else {
        [self.navigationController popViewControllerAnimated: YES];
    }
}
- (void) gotoNext {
    if (_listeningPlayer != nil) {
        [_listeningPlayer stop];
        _listeningPlayer = nil;
    }
    [self stopToListen];
    [self stopToCompare];
    [self stopRecord];
    [self stopEffectAudio];
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
//            self.gotoWhere = @"gotoNext";
//            return;
//        }
//    } else {
//
//    }
    [self gotoSessionScreen];
}
- (void) playSessionResult {
    NSString* path = [[NSBundle mainBundle] pathForResource: @"session_completed" ofType: @"mp3"];
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
- (void) pauseListening {
    if (_listeningPlayer == nil) {
        return;
    }
    [_listeningPlayer pause];
    _listeningStat.paused = YES;
}
- (void) skipListening {
    if (_listeningPlayer == nil) {
        return;
    }
    _listeningStat.paused = NO;
    _listeningPlayer.delegate = self;
    [_listeningPlayer skip];
}
- (BOOL) playListening {
    if (_listeningPlayer == nil) {
        return NO;
    }
    _listeningPlayer.delegate = self;
    if ([_listeningPlayer isPlaying]) {
        [_listeningPlayer resume];
        _listeningStat.paused = NO;
        return YES;
    } else {
        if ([_listeningPlayer start]) {
            _listeningStat.paused = NO;
            return YES;
        } else {
            return NO;
        }
    }
}
- (void) progressUpdated: (float)progress {
    _listeningStat.currentPos = [_listeningPlayer currentPos];
    _listeningStat.durationLabel = [_listeningPlayer durationFormat];
    _listeningStat.progress = progress;
    if (_currentVC != nil && [_currentVC isKindOfClass: [BListeningViewController class]]) {
        [(BListeningViewController*)_currentVC progressUpdated: progress];
    }
}
- (void) completed {
    if (_listeningPlayer != nil) {
        [_listeningPlayer stop];
    }
    _listeningStat.currentPos = [_listeningPlayer currentPos];
    _listeningStat.durationLabel = [_listeningPlayer durationFormat];
    _listeningStat.progress = 0;
    _listeningStat.paused = YES;
    _listeningStat.completed = YES;
    if (_currentVC != nil && [_currentVC isKindOfClass: [BListeningViewController class]]) {
        
        [(BListeningViewController*)_currentVC completed];
    }
}
- (void) stopToListen {
    [BAudioListener stop: _audioListner];
    _audioListner = nil;
}
- (BOOL) listenAudio {
    BStudy* compare = [_lesson compareAt: _comparingStat.currentPos forSession: _session];
    
    NSURL* url = [BLessonDataManager audio: compare.audio forLesson: _lesson.number];
    _audioListner = [BAudioListener play: url delegate: self];
    if (_audioListner != nil) {
        _comparingStat.status = [BComparingStat STAT_Listening];
        return YES;
    }
    
    return NO;
}
- (void) listeningProgress: (float)progress {
    _comparingStat.listenProgress = progress;
    _comparingStat.status = [BComparingStat STAT_Listening];
    if (_currentVC != nil && [_currentVC isKindOfClass: [BComparingViewController class]]) {
        [(BComparingViewController*)_currentVC listeningProgress: progress];
    }
}
- (void) listeningCompleted {
    _comparingStat.listenProgress = 0;
    _comparingStat.status = [BComparingStat STAT_Nothing];
    [self stopToListen];
    if (_currentVC != nil && [_currentVC isKindOfClass: [BComparingViewController class]]) {
        [(BComparingViewController*)_currentVC listeningCompleted];
    }
}
- (BOOL) recordVoice {
    [BAnalytics sendEvent:@"Record Voice" label:_lesson.title];
    [self stopToListen];
    [self stopToCompare];
    if(_voiceRecorder != nil) {
        [_voiceRecorder stop];
        _voiceRecorder = nil;
    }
    
    NSURL *url = [self recordFileURL];
    
    _voiceRecorder = [[AVAudioRecorder alloc] initWithURL:url
                                                 settings:@{
                                                            AVFormatIDKey:@(kAudioFormatMPEG4AAC),
                                                            AVSampleRateKey:@(44100.0),
                                                            AVNumberOfChannelsKey:@(2),
                                                            }
                                                    error:nil];
    [_voiceRecorder setDelegate:self];
    [_voiceRecorder prepareToRecord];
    [_voiceRecorder setMeteringEnabled:YES];
    if(![_voiceRecorder record]) {
        [_voiceRecorder stop];
        _voiceRecorder = nil;
        return NO;
    }
    _comparingStat.status = [BComparingStat STAT_Recording];
    return YES;
}

- (void) stopRecord {
    [self stopToListen];
    [self stopToCompare];
    if(_voiceRecorder != nil) {
        [_voiceRecorder stop];
        _voiceRecorder = nil;
    }
    if (![self isRecordFileExists]) {
        _comparingStat.status = [BComparingStat STAT_Nothing];
    } else {
        _comparingStat.status = [BComparingStat STAT_Recorded];
    }
}
- (NSURL*) recordFileURL {
    return [NSURL fileURLWithPath:[FileUtils documentPath: @"recorded"]];
}

- (BOOL) isRecordFileExists {
    NSURL *url = [self recordFileURL];
    if(url == nil) return NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:url.path]) return NO;
    
    NSDictionary *attributesDict = [fileManager attributesOfItemAtPath:url.path error:nil];
    if([attributesDict fileSize] == 0) return NO;
    
    return YES;
}

- (BOOL) isVoiceRecording {
    return _voiceRecorder != nil;
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if(recorder == _voiceRecorder) {
        [self stopRecord];
    }
}

- (BOOL) compareAudio {
    BStudy* compare = [_lesson compareAt: _comparingStat.currentPos forSession: _session];
    
    NSURL* url1 = [BLessonDataManager audio: compare.audio forLesson: _lesson.number];
    NSURL* url2 = [self recordFileURL];
    _audioComparator = [BAudioComparator play: url1 url2: url2 delegate: self];
    if (_audioComparator != nil) {
        _comparingStat.status = [BComparingStat STAT_Comparing];
        return YES;
    }
    
    return NO;
}
- (void) stopToCompare {
    [BAudioComparator stop: _audioComparator];
    _audioComparator = nil;
}
- (void) skipComparing {
    [self stopRecord];
    [self stopToListen];
    [self stopToCompare];
    [_comparingStat next];
    if (_comparingStat.currentPos >= [_lesson numOfCompares: _session]) {
        _comparingStat.completed = YES;
        [_comparingStat initByPos: 0];
    }
    if (_currentVC != nil && [_currentVC isKindOfClass: [BComparingViewController class]]) {
        [(BComparingViewController*)_currentVC refresh];
    }
}
- (void) comparingProgress: (float)progress {
    _comparingStat.compareProgress = progress;
    _comparingStat.status = [BComparingStat STAT_Comparing];
    if (_currentVC != nil && [_currentVC isKindOfClass: [BComparingViewController class]]) {
        [(BComparingViewController*)_currentVC comparingProgress: progress];
    }
}
- (void) comparingCompleted {
    [self stopToCompare];
    _comparingStat.compareCount ++;
    _comparingStat.compareProgress = 0;
    _comparingStat.status = [BComparingStat STAT_Recorded];
//    if (_comparingStat.compareCount >= 2) {
//        [_comparingStat next];
//        if (_comparingStat.currentPos >= [_lesson numOfCompares: _session]) {
//            _comparingStat.currentPos = 0;
//            _comparingStat.completed = YES;
//        }
//    }
    if (_currentVC != nil && [_currentVC isKindOfClass: [BComparingViewController class]]) {
        [(BComparingViewController*)_currentVC comparingCompleted];
    }
}
- (void) checkExerciseResult {
    NSArray* exercises = [_lesson exercises: _session];
    _exerciseStat.busy = YES;
    BExercise* selected = [exercises objectAtIndex: _exerciseStat.selected];
    BExercise* answer = [_lesson exerciseAt: _exerciseStat.currentPos forSession: _session];
    if (selected.order == answer.order) {
        _exerciseStat.correct = YES;
        [self playExerciseResult: YES];
    } else {
        _exerciseStat.correct = NO;
        [self playExerciseResult: NO];
    }
}
- (void) playExerciseResult: (BOOL) correct {
    NSString* path = [[NSBundle mainBundle] pathForResource: @"tada" ofType: @"wav"];
    if (correct) {
        path = [[NSBundle mainBundle] pathForResource: @"tada" ofType: @"wav"];
    } else {
        path = [[NSBundle mainBundle] pathForResource: @"critical" ofType: @"wav"];
    }
    NSURL* url = [NSURL fileURLWithPath: path];
    [self stopAudio];
    
    NSError *error;
    _effectPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [_effectPlayer setDelegate:self];
    
    if(![_effectPlayer play]) {
        [_effectPlayer stop];
        _effectPlayer = nil;
    }
}
- (BOOL) playExerciseAudio {
    BExercise* exercise = [_lesson exerciseAt: _exerciseStat.currentPos forSession: _session];
    
    NSURL* url = [BLessonDataManager audio: exercise.audio forLesson: _lesson.number];
    if ([self playAudio: url]) {
        return YES;
    } else {
        _exerciseStat.busy = NO;
        _exerciseStat.selected = -1;
        if (_currentVC != nil && [_currentVC isKindOfClass: [BExerciseViewController class]]) {
            [(BExerciseViewController*)_currentVC refresh];
        }
        return NO;
    }
    return NO;
}
- (void) stopEffectAudio {
    if (_effectPlayer != nil) {
        [self stopAudioProgressMonitor];
        [_effectPlayer stop];
        _effectPlayer = nil;
    }
}
- (BOOL) playAudio: (NSURL*) url {
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
    if (_effectPlayer != nil) {
        [_effectPlayer stop];
        _effectPlayer = nil;
    }
    if (_resultPlayer != nil) {
        [_resultPlayer stop];
        _resultPlayer = nil;
    }
}
- (void) startAudioProgressMonitor {
    [self updateAudioProgress];
    if(_progressMonitor == nil && _audioPlayer != nil) {
        NSTimeInterval duration = _audioPlayer.duration;
        
        _progressMonitor = [NSTimer scheduledTimerWithTimeInterval:duration / 250
                                                         fireBlock:^{
                                                             if(_audioPlayer == nil || ![_audioPlayer isPlaying]){
                                                                 [_progressMonitor invalidate];
                                                             } else {
                                                                 [self updateAudioProgress];
                                                             }
                                                         }
                                                           repeats:YES];
    }
}

- (void) stopAudioProgressMonitor {
    [_progressMonitor invalidate];
    _progressMonitor = nil;
}
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if(player == _audioPlayer) {
        [self stopAudio];
        if (_exerciseStat.currentPos < 3) {
            [_exerciseStat next];
        } else {
            _exerciseStat.completed = YES;
            _exerciseStat.selected = -1;
            _exerciseStat.busy = NO;
        }
        if (_currentVC != nil && [_currentVC isKindOfClass: [BExerciseViewController class]]) {
            [(BExerciseViewController*)_currentVC refresh];
        }
    } else if (player == _effectPlayer) {
        [self stopEffectAudio];
        if (_exerciseStat.correct) {
            if ([self playExerciseAudio]) {
                
            }
        } else {
            _exerciseStat.busy = NO;
            _exerciseStat.selected = -1;
            if (_currentVC != nil && [_currentVC isKindOfClass: [BExerciseViewController class]]) {
                [(BExerciseViewController*)_currentVC refresh];
            }
        }
    } else if (player == _resultPlayer) {
        
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            _resultView1.hidden = YES;
            _resultView2.hidden = YES;
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
//                    self.gotoWhere = @"gotoBack";
//                    return;
//                }
//            } else {
//
//            }
            [self gotoBack];
        });
    }
}
- (void) updateAudioProgress {
    if(_audioPlayer == nil) {
    } else {
        NSTimeInterval duration = _audioPlayer.duration;
        NSTimeInterval current = _audioPlayer.currentTime;
        float progress;
        if(duration == 0) progress = 0;
        else {
            progress = MAX(0, MIN(1, (float)current / (float)duration));
        }
        if (self.currentVC != nil && [self.currentVC isKindOfClass: [BExerciseViewController class]]) {
            [(BExerciseViewController*)_currentVC showProgress: progress selected: _exerciseStat.selected];
        }
    }
}
@end
