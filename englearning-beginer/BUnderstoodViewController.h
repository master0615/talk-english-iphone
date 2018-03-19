//
//  BUnderstoodViewController.h
//  englearning-kids
//
//  Created by sworld on 8/27/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLessonStartContainerViewController.h"

@interface BUnderstoodViewController : UIViewController

@property (nonatomic, strong) BLessonStartContainerViewController* containerVC;

- (void) refresh;

@end
