//
//  Quiz2ViewController.h
//  englearning-kids
//
//  Created by sworld on 9/2/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQuizContainerViewController.h"

@interface BQuiz2ViewController : UIViewController

@property (nonatomic, strong) BQuizContainerViewController* containerVC;

- (void) refresh;
- (void) hideResultByAnim;

@end
