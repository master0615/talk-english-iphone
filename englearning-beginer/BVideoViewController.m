//
//  BVideoViewController.m
//  englearning-kids
//
//  Created by sworld on 9/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BVideoViewController.h"
#import "AVFoundation/AVPlayer.h"
#import "AVFoundation/AVPlayerLayer.h"
#import "SharedPref.h"

@import AVFoundation.AVAsset;
@import AVFoundation.AVPlayerItem;

@interface BVideoViewController ()
@property (weak, nonatomic) IBOutlet UIView *videoContainer;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoWidth;
@property (nonatomic, strong) AVPlayer* avPlayer;
@property (nonatomic, strong) AVPlayerItem* avPlayerItem;
@property (nonatomic, strong) AVAsset* avAsset;
@property (nonatomic, strong) AVPlayerLayer* avPlayerLayer;
@end

@implementation BVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    NSString* path = [[NSBundle mainBundle] pathForResource: self.videoFile ofType: @"mp4"];
    NSURL* url = [NSURL fileURLWithPath: path];
    self.avAsset = [AVAsset assetWithURL: url];
    self.avPlayerItem =[[AVPlayerItem alloc] initWithAsset: self.avAsset];
    self.avPlayer = [[AVPlayer alloc]initWithPlayerItem: self.avPlayerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object: self.avPlayerItem];
    self.avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer: self.avPlayer];
    [self.avPlayerLayer setFrame:self.videoContainer.frame];
    [self.videoContainer.layer addSublayer: self.avPlayerLayer];
    [self.playButton setEnabled: NO];
    [self.avPlayer seekToTime:kCMTimeZero];
    [self.avPlayer play];
    [self setVideoRegion];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self setModalPresentationStyle: UIModalPresentationCustom];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion: ^{
        
    }];
}
- (IBAction)playPressed:(id)sender {
    [self.avPlayer seekToTime:kCMTimeZero];
    [self.avPlayer play];
}
- (IBAction)OKPressed:(id)sender {
    NSString* key = [NSString stringWithFormat: @"played_%@", self.videoFile];
    [SharedPref setBool: YES forKey: key];
    [self dismissViewControllerAnimated:YES completion: ^{
        
    }];
}
- (void)viewWillLayoutSubviews {
    [self setVideoRegion];
}
- (void) setVideoRegion {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    double rate = 1280.0/720.0;
    double rate0 = 0.6;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        rate0 = 0.6;
    } else if (UIInterfaceOrientationIsPortrait(orientation)) {
        rate0 = 0.85;
    }
    double width;
    width = [[UIScreen mainScreen] bounds].size.width * rate0;
    self.videoWidth.constant = width;
    CGRect frame = CGRectMake(0,0, width, (width)/rate);
    [self.avPlayerLayer setFrame: frame];
}
-(void)itemDidFinishPlaying:(NSNotification *) notification {
    // Will be called when AVPlayer finishes playing playerItem
    [self.avPlayer seekToTime:kCMTimeZero];
    [self.playButton setEnabled: YES];
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
