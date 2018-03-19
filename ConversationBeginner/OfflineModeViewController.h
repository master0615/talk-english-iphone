//
//  OfflineModeViewController.h
//  EnglishConversation
//
//  Created by SongJiang on 6/23/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfflineModeViewController : UIViewController

- (void) showProgressBar;

- (void) setProgress:(float) fProgress;
- (void) changeButtonTitle:(BOOL) bFailed;

- (void)hideProgressBar;
- (void) updateUI;
@end
