//
//  ECAVPlayerViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/12/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "ECAVPlayerViewController.h"
#import <AVFoundation/AVPlayerItem.h>

@interface ECAVPlayerViewController ()
@end

@implementation ECAVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_NOTIFIFCATION object:self.vc];
//    if (_dismissBlock != nil) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _dismissBlock();
//        });
//    }
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
