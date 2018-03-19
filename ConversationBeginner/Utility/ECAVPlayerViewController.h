//
//  ECAVPlayerViewController.h
//  EnglishConversation
//
//  Created by SongJiang on 3/12/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <AVKit/AVKit.h>
#import "ViewController.h"
#define PLAYER_NOTIFIFCATION @"PLAYER_DISMISS"
@interface ECAVPlayerViewController : AVPlayerViewController
@property (nonatomic, strong) ViewController* vc;
@end
