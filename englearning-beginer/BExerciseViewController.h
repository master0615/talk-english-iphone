//
//  BExerciseViewController.h
//  englearning-kids
//
//  Created by sworld on 8/31/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSessionContainerViewController.h"

@interface BExerciseViewController : UIViewController

@property (nonatomic, strong) BSessionContainerViewController* containerVC;

- (void) refresh;
- (void) showProgress: (float) progress selected: (int) selected;

@end
