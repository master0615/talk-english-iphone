//
//  BListeningViewController.h
//  englearning-kids
//
//  Created by sworld on 8/27/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSessionContainerViewController.h"

@interface BListeningViewController : UIViewController

@property (nonatomic, strong) BSessionContainerViewController* containerVC;

- (void) refresh;
- (void) progressUpdated: (float) progress;
- (void) completed;

@end
