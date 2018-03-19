//
//  MainViewController.h
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/5/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PMainViewController : UIViewController
@property (nonatomic, assign) BOOL bBackForAlbum;
@property (nonatomic, assign) BOOL bTrackEditable;
@property (nonatomic, assign) BOOL bAlbumEditable;
@property (nonatomic, assign) NSInteger nPlayListNum;
- (void) showBackButton;
- (void) hideBackButton;
@end
