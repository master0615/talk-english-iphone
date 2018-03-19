//
//  CommonBaseController.m
//  englistening
//
//  Created by alex on 5/24/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LLessonContainerViewController.h"
#import "LHomeViewController.h"
#import "LLessonBaseViewController.h"
#import "LessonAudioProvider+Standard.h"
#import "LDownloadProgressViewController.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "LFileUtils.h"
#import "LUIUtils.h"
#import "NSTimer+Block.h"
#import "LUtils.h"
#import "LEnv.h"
#import "Lesson1.h"
#import "Lesson2.h"
#import "Lesson3.h"
#import "Lesson4.h"
#import "Lesson5.h"
#import "Lesson6.h"
#import "AdsTimeCounter.h"

@interface LLessonContainerViewController()<AVAudioPlayerDelegate, LDownloadProgressDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource> {
    
}
@property (nonatomic, strong) UIPageViewController* pageVC;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *progressMonitor;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) LLessonBaseViewController* currentViewController;
@property (nonatomic, strong) LLessonBaseViewController* portraitVC;
@property (nonatomic, strong) LLessonBaseViewController* landscapeVC;
@property (nonatomic, strong) NSString* portraitVCId;
@property (nonatomic, strong) NSString* landscapeVCId;
@end

static LLessonContainerViewController* sharedVC;

@implementation LLessonContainerViewController

+ (LLessonContainerViewController*) singleton {
    return sharedVC;
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [LAnalytics sendScreenName:[NSString stringWithFormat: @"Lesson Container Screen"]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    sharedVC = self;
    self.title = @"English Listening";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"ic_back"] style: UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    if (self.lessons == nil) {
        if ([self.prefix isEqualToString: [Lesson1 prefix]]) {
            [self.titleLabel setText: [NSString stringWithFormat: @"Beginner I: Fill in the Blanks"]];
            self.lessons = [Lesson1 loadAll];
            self.portraitVCId = @"Lesson1ViewController";
            self.landscapeVCId = @"Lesson1ViewController0";
        } else if ([self.prefix isEqualToString: [Lesson2 prefix]]) {
            [self.titleLabel setText: @"Beginner II: What is in the Picture?"];
            self.lessons = [Lesson2 loadAll];
            self.portraitVCId = @"Lesson2ViewController";
            self.landscapeVCId = @"Lesson2ViewController0";
        } else if ([self.prefix isEqualToString: [Lesson3 prefix]]) {
            [self.titleLabel setText: @"Beginner III: Fomous Quotes"];
            self.lessons = [Lesson3 loadAll];
            self.portraitVCId = @"Lesson3ViewController";
            self.landscapeVCId = @"Lesson3ViewController0";
        } else if ([self.prefix isEqualToString: [Lesson4 prefix]]) {
            [self.titleLabel setText: @"Intermediate I: Short Passages"];
            self.lessons = [Lesson4 loadAll];
            self.portraitVCId = @"Lesson4ViewController";
            self.landscapeVCId = @"Lesson4ViewController0";
        } else if ([self.prefix isEqualToString: [Lesson5 prefix]]) {
            [self.titleLabel setText: @"Intermediate II: Sentence Dictation"];
            self.lessons = [Lesson5 loadAll];
            self.portraitVCId = @"Lesson5ViewController";
            self.landscapeVCId = @"Lesson5ViewController0";
        } else if ([self.prefix isEqualToString: [Lesson6 prefix]]) {
            [self.titleLabel setText: @"Advanced: Long Paragraphs"];
            self.lessons = [Lesson6 loadAll];
            self.portraitVCId = @"Lesson6ViewController";
            self.landscapeVCId = @"Lesson6ViewController0";
        }
    }
    self.entry = [self.lessons objectAtIndex: self.position];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    sharedVC = self;
    if ([segue.identifier isEqualToString: @"SSID_LessonContainer"]) {
        if (self.lessons == nil) {
            if ([self.prefix isEqualToString: [Lesson1 prefix]]) {
                [self.titleLabel setText: [NSString stringWithFormat: @"Beginner I: Fill in the Blanks"]];
                self.lessons = [Lesson1 loadAll];
                self.portraitVCId = @"Lesson1ViewController";
                self.landscapeVCId = @"Lesson1ViewController0";
            } else if ([self.prefix isEqualToString: [Lesson2 prefix]]) {
                [self.titleLabel setText: @"Beginner II: What is in the Picture?"];
                self.lessons = [Lesson2 loadAll];
                self.portraitVCId = @"Lesson2ViewController";
                self.landscapeVCId = @"Lesson2ViewController0";
            } else if ([self.prefix isEqualToString: [Lesson3 prefix]]) {
                [self.titleLabel setText: @"Beginner III: Fomous Quotes"];
                self.lessons = [Lesson3 loadAll];
                self.portraitVCId = @"Lesson3ViewController";
                self.landscapeVCId = @"Lesson3ViewController0";
            } else if ([self.prefix isEqualToString: [Lesson4 prefix]]) {
                [self.titleLabel setText: @"Intermediate I: Short Passages"];
                self.lessons = [Lesson4 loadAll];
                self.portraitVCId = @"Lesson4ViewController";
                self.landscapeVCId = @"Lesson4ViewController0";
            } else if ([self.prefix isEqualToString: [Lesson5 prefix]]) {
                [self.titleLabel setText: @"Intermediate II: Sentence Dictation"];
                self.lessons = [Lesson5 loadAll];
                self.portraitVCId = @"Lesson5ViewController";
                self.landscapeVCId = @"Lesson5ViewController0";
            } else if ([self.prefix isEqualToString: [Lesson6 prefix]]) {
                [self.titleLabel setText: @"Advanced: Long Paragraphs"];
                self.lessons = [Lesson6 loadAll];
                self.portraitVCId = @"Lesson6ViewController";
                self.landscapeVCId = @"Lesson6ViewController0";
            }
        }
        self.entry = [self.lessons objectAtIndex: self.position];
        self.pageVC = segue.destinationViewController;

        self.pageVC.delegate = self;
       
        
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        [self showViewByOrientation: orientation];
    }
}
- (NSUInteger)countOfPageVC {
    return 1;
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    return nil;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self updateBookmarkButton];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self showViewByOrientation: orientation];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopLessonAudio];
}
- (void) updateBookmarkButton {
    if (self.entry != nil && self.entry.bookmark) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_toolbar_bookmark_on"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBookmark)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_toolbar_bookmark_off"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBookmark)];
    }
}
- (void) onClickBack {
    [self.navigationController popViewControllerAnimated: YES];
    [self stopLessonAudio];
    if (self.entry != nil && [self.entry isCompleted]) {
        [[LLessonAudioProvider provider] deleteLessonAudioFile: self.entry.audio];
    }
}
- (void) onClickBookmark {
    if (self.entry != nil) {
        [LAnalytics sendEvent: @"onClickBookmark"
                       label: [NSString stringWithFormat: @"%@ - %@",
                               self.entry.prefix,
                               self.entry.number]];
    
        self.entry.bookmark = !self.entry.bookmark;
    } else {
        [LAnalytics sendEvent: @"onClickBookmark"
                       label: [NSString stringWithFormat: @"entry is nil"]];
    }
    [self updateBookmarkButton];
}
- (BOOL) gotoNextLesson {
    
    int isPurchased = [LSharedPref intForKey: @"isPurchased" default: 0];

    [self displayNextLesson];
    return YES;
}
- (void) displayNextLesson {
    [self stopLessonAudio];
    if (self.position+1 >= [self.lessons count]) {
        //must go to next section.
        if ([self.prefix isEqualToString: [Lesson1 prefix]]) {
            [self.navigationController popToViewController: [LHomeViewController singleton] animated: NO];
            [[LHomeViewController singleton] gotoSection: [Lesson2 prefix]];
        } else if ([self.prefix isEqualToString: [Lesson2 prefix]]) {
            [self.navigationController popToViewController: [LHomeViewController singleton] animated: NO];
            [[LHomeViewController singleton] gotoSection: [Lesson3 prefix]];
        } else if ([self.prefix isEqualToString: [Lesson3 prefix]]) {
            [self.navigationController popToViewController: [LHomeViewController singleton] animated: NO];
            [[LHomeViewController singleton] gotoSection: [Lesson4 prefix]];
        } else if ([self.prefix isEqualToString: [Lesson4 prefix]]) {
            [self.navigationController popToViewController: [LHomeViewController singleton] animated: NO];
            [[LHomeViewController singleton] gotoSection: [Lesson5 prefix]];
        } else if ([self.prefix isEqualToString: [Lesson5 prefix]]) {
            [self.navigationController popToViewController: [LHomeViewController singleton] animated: NO];
            [[LHomeViewController singleton] gotoSection: [Lesson6 prefix]];
        } else if ([self.prefix isEqualToString: [Lesson6 prefix]]) {
            [self.navigationController popToViewController: [LHomeViewController singleton] animated: YES];
            
        }
    } else {
        self.position += 1;
        self.entry = [self.lessons objectAtIndex: self.position];
        [self updateBookmarkButton];
        [self.currentViewController loadData];
    }
}
- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    [self showViewByOrientation: orientation];
}
- (void) showViewByOrientation: (UIInterfaceOrientation) orientation {

    if (self.portraitVC == nil) {
        self.portraitVC = (LLessonBaseViewController*) [LUtils newViewControllerWithId:self.portraitVCId];
    }
    if (self.landscapeVC == nil) {
        self.landscapeVC = (LLessonBaseViewController*) [LUtils newViewControllerWithId:self.landscapeVCId];
    }
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [self.pageVC setViewControllers:@[self.landscapeVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        self.currentViewController = self.landscapeVC;
        self.checkResultLabelLeft.constant = [[UIScreen mainScreen] bounds].size.width/3;
        self.badgeViewContainerLeft.constant = [[UIScreen mainScreen] bounds].size.width/3;
    } else if (UIInterfaceOrientationIsPortrait(orientation)) {
        [self.pageVC setViewControllers:@[self.portraitVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        self.currentViewController = self.portraitVC;
        self.checkResultLabelLeft.constant = 0;
        self.badgeViewContainerLeft.constant = 0;
    }
}
- (void) hideCheckResultViews {
    self.badgeContainerView.hidden = YES;
    self.checkResultLabel.hidden = YES;
}
- (void) showCorrectResultLabel {
    [self.view layoutIfNeeded];
    self.badgeContainerView.hidden = YES;
    self.checkResultLabel.hidden = NO;
    [self.checkResultLabel setText: @"Correct"];
    self.checkResultLabel.textColor = RGB(0x66, 0x99, 0);
}
- (void) showIncorrectResultLabel {
    [self.view layoutIfNeeded];
    self.badgeContainerView.hidden = YES;
    self.checkResultLabel.hidden = NO;
    [self.checkResultLabel setText: @"Incorrect"];
    self.checkResultLabel.textColor = RGB(0xCC, 0, 0);
}
- (void) showRibbonByAnim {
    [self.view layoutIfNeeded];
    self.badgeContainerView.hidden = NO;
    self.checkResultLabel.hidden = YES;
    Lesson* entry = self.entry;
    [self.badgeView setPoint: [entry point]];
    self.badgeContainerView.alpha = 0;
    self.badgeContainerView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView beginAnimations: @"fadeInNewView" context: NULL];
    [UIView setAnimationDuration: 1.0];
    self.badgeContainerView.transform = CGAffineTransformMakeScale(1, 1);
    self.badgeContainerView.alpha = 1;
    [UIView commitAnimations];
}
- (void) hideRibbonByAnim {
    [self.view layoutIfNeeded];
    self.badgeContainerView.alpha = 1;
    self.badgeContainerView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView beginAnimations: @"fadeInNewView" context: NULL];
    [UIView setAnimationDuration: 0.7];
    self.badgeContainerView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.badgeContainerView.alpha = 0;
    [UIView commitAnimations];
    self.checkResultLabel.hidden = YES;
    double delayInSeconds = 0.7;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.badgeContainerView.hidden = YES;
    });
}
- (void) playEffectSound {
    
    [self stopLessonAudio];
    [self.currentViewController setAudioProgress: 0];
    NSString* path = [[NSBundle mainBundle] pathForResource: @"congratulations" ofType: @"mp3"];
    NSURL* url = [NSURL fileURLWithPath: path];
    
    [LAnalytics sendEvent:@"Play Effect Audio" label:url.absoluteString];
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [_audioPlayer setDelegate:self];
    
    if(![_audioPlayer play]) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
}
- (void) playLessonAudio: (Lesson*) entry {
    if ([entry isAudioInAssets]) {
        NSRange range0 = NSMakeRange(0, [entry.audio length]-4);
        NSString* audio = [entry.audio substringWithRange: range0];
        NSString* path = [[NSBundle mainBundle] pathForResource: audio ofType: @"mp3"];
        NSURL* url = [NSURL fileURLWithPath: path];
        if ([self playAudio: url]) {
            [entry increaseRepeatCount];
            [self.currentViewController setCanSelectAnswer];
        }
    } else {
        NSURL* url = [[LLessonAudioProvider provider] lessonAudioUrlByFilename: entry.audio];
        if (url != nil) {
            if ([self playAudio: url]) {
                [entry increaseRepeatCount];
                [self.currentViewController setCanSelectAnswer];
            }
        } else {
            LDownloadProgressViewController* vc = (LDownloadProgressViewController*)[LUtils newViewControllerWithId: @"DownloadProgressViewController"  ];
            vc.view.backgroundColor = [UIColor clearColor];
            vc.delegate = self;
            vc.entry = entry;
            [vc setModalPresentationStyle: UIModalPresentationOverCurrentContext];
            [self presentViewController: vc animated: NO completion: nil];
        }
    }
}
- (void) playLessonAudio {
    Lesson* entry = self.entry;
    [self playLessonAudio: entry];
    
    [LLessonContainerViewController singleton].badgeContainerView.hidden = YES;
    [LLessonContainerViewController singleton].checkResultLabel.hidden = YES;
}
- (BOOL)playAudio:(NSURL*)url {
    [LAnalytics sendEvent:@"Play Audio" label:url.absoluteString];
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
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if(player == _audioPlayer) {
        if (self.currentViewController != nil) {
            [self.currentViewController setAudioProgress: 1];
            [self.currentViewController setAudioProgress: 0];
        }
        if (self.badgeContainerView.hidden == NO) {
            [self hideRibbonByAnim];
        }
    }
}
- (void)updateAudioProgress {
    if(_audioPlayer == nil) {
        if (self.currentViewController != nil) {
            [self.currentViewController setAudioProgress: 0];
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
        if (self.currentViewController != nil) {
            [self.currentViewController setAudioProgress: progress];
        }
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

- (void)download:(Lesson *)entry didSuccess:(NSURL *)url {
    if ([self playAudio: url]) {
        [entry increaseRepeatCount];
        [self.currentViewController setCanSelectAnswer];
    }
}
- (void)download:(Lesson *)entry didFail:(NSString *)message {
    
}


@end
