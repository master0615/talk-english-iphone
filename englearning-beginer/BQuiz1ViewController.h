//
//  Quiz1ViewController.h
//  englearning-kids
//
//  Created by sworld on 9/2/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQuizContainerViewController.h"

@interface BQuiz1ViewController : UIViewController

@property (nonatomic, strong) BQuizContainerViewController* containerVC;

- (void) refresh;
- (void) hideResultByAnim;

@end
