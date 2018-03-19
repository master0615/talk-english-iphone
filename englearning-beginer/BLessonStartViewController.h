//
//  BLessonStartViewController.h
//  englearning-kids
//
//  Created by sworld on 8/26/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLessonStartContainerViewController.h"

@interface BLessonStartViewController : UIViewController

@property (nonatomic, strong) BLessonStartContainerViewController* containerVC;

- (void) refresh;
- (void) setAudioProgress: (float) progress;
- (void) showProgressConrol: (BOOL) show;
- (void) enablePlayButton: (BOOL) enable;

@end
