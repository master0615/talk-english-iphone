//
//  VOfflineModeViewController.h
//  EnglishVocab
//
//  Created by SongJiang on 7/27/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VOfflineModeViewController : UIViewController
- (void) showProgressBar;
- (void) setProgress:(float) fProgress;
- (void) hideProgressBar;
- (void) updateUI;
- (void) setUpdateOffline:(NSInteger)nBookNum on:(int)nOn;

@end
