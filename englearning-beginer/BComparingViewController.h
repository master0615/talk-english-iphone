//
//  BComparingViewController.h
//  englearning-kids
//
//  Created by sworld on 8/31/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSessionContainerViewController.h"

@interface BComparingViewController : UIViewController

@property (nonatomic, strong) BSessionContainerViewController* containerVC;

- (void) refresh;
- (void) listeningProgress: (float) progress;
- (void) listeningCompleted;
- (void) comparingProgress: (float) progress;
- (void) comparingCompleted;

@end
