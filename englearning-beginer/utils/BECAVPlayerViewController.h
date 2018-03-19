//
//  BECAVPlayerViewController.h
//  EnglishConversation
//
//  Created by SongJiang on 3/12/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <AVKit/AVKit.h>
#import "BInitialViewController.h"
#define PLAYER_NOTIFIFCATION @"PLAYER_DISMISS"
@interface BECAVPlayerViewController : AVPlayerViewController
@property (nonatomic, strong) BInitialViewController* vc;
@end
