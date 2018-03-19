//
//  DownloadProgressViewController.m
//  englistening
//
//  Created by alex on 5/28/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BDownloadProgressViewController.h"
#import "BReachability.h"
#import "BAnalytics.h"
#import "UIUtils.h"

@interface BDownloadProgressViewController()

@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressView;

@end

@implementation BDownloadProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"nav_back"] style: UIBarButtonItemStylePlain target:self action:@selector(onClickGoBack)];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barTintColor = RGB(44, 45, 50);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    BReachability *networkReachability = [BReachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [self dismissViewControllerAnimated:NO completion: ^ {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message: @"Please check your Internet connection."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            if (self.delegate != nil) {
                [self.delegate downloadFailedFor: _lessonNumber];
            }
        }];
        return;
    }
    [self.downloadProgressView setProgress: 0];
    //[BLessonDataManager sharedInstance].delegate = self;
}
- (void) onClickGoBack {
    [self hideDownloadProgress];
    [self dismissViewControllerAnimated:NO completion: ^ {
        if (self.delegate != nil) {
            [self.delegate downloadFailedFor: _lessonNumber];
        }
    }];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [BAnalytics sendScreenName:@"Lesson Data Progress Screen"];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void) progress:(int)current_count of:(int)total_count forLesson:(int)lessonNumber {
    float progress = (float) current_count / (float) total_count;
    [self showDownloadProgress: progress];
}
- (void) failedForLesson:(int)lessonNumber {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideDownloadProgress];
        [self dismissViewControllerAnimated:NO completion: ^ {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Download Failed"
                                                            message: @"The download failed. Please check your internet connection and try again."
                                                           delegate: nil
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            if (self.delegate != nil) {
                [self.delegate downloadFailedFor: _lessonNumber];
            }
        }];
    });    
}
- (void) completedForLesson:(int)lessonNumber {
    if (lessonNumber >= _lessonNumber) {
        [self hideDownloadProgress];
        [self dismissViewControllerAnimated:NO completion: ^ {
            if (self.delegate != nil) {
                [self.delegate downloadCompletedFor: _lessonNumber];
            }
        }];
    } else {
        [self showDownloadProgress: 0];
    }
}
- (void)showDownloadProgress:(float)progress {
    [_downloadProgressView setProgress:progress];
}

- (void)hideDownloadProgress {
    
}
@end
