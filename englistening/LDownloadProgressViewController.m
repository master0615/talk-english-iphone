//
//  DownloadProgressViewController.m
//  englistening
//
//  Created by alex on 5/28/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LDownloadProgressViewController.h"
#import "LessonAudioProvider+Standard.h"
#import "LAnalytics.h"

@interface LDownloadProgressViewController()<LessonAudioPrepareDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressView;

@end

@implementation LDownloadProgressViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.downloadProgressView setProgress: 0];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [LAnalytics sendScreenName:@"Lesson Audio Progress Screen"];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[LLessonAudioProvider provider] prepare: self.entry.audio withDelegate: self];
    
}
- (void)lessonAudio:(NSString*)filename
         didPrepare:(NSURL*)url {
    [self hideDownloadProgress];
    [self dismissViewControllerAnimated:NO completion: ^ {
        if (self.delegate != nil) {
            [self.delegate download: self.entry didSuccess: url];
        }
    }];
}

- (void)lessonAudio:(NSString*)filename
        didDownload:(float)progress {
    [self showDownloadProgress:progress];
}

- (void)lessonAudio:(NSString*)filename
            didFail:(NSString*)message {
    [self hideDownloadProgress];
    [self dismissViewControllerAnimated:NO completion: ^ {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Download Failed"
                                                        message: @"The download failed. Please check your internet connection and try again."
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
        if (self.delegate != nil) {
            [self.delegate download: self.entry didFail: message];
        }
        
    }];
}
- (void)showDownloadProgress:(float)progress {
    [_downloadProgressView setProgress:progress];
}

- (void)hideDownloadProgress {
    
}
@end
