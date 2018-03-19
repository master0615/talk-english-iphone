//
//  PMyPlaylistsViewController.h
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/6/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBaseViewController.h"
@interface PMyPlaylistsViewController : PBaseViewController

@property(nonatomic, assign) BOOL bNeedAdd;
@property(nonatomic, strong) NSMutableArray* playNewList;

- (void) createPlayList:(NSString*) strPlayListName;
- (void) editPlayList:(NSString*) strOldPlayListName new:(NSString*) strNewPlayListName;
- (void) deletePlayList:(NSString*) strPlayListName;
@end
