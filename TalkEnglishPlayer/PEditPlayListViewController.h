//
//  PEditPlayListViewController.h
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/16/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMyPlaylistsViewController.h"
@interface PEditPlayListViewController : PBaseViewController
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) NSString* strPlayListName;
@property (nonatomic, assign) NSInteger nPlayListNum;
@property (nonatomic, strong) PMyPlaylistsViewController* vcPlayList;
@end
