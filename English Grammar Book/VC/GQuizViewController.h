//
//  QuizViewController.h
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCommonViewController.h"

#import "GLessonItem.h"

@interface GQuizViewController : GCommonViewController<UITextFieldDelegate>


@property (nonatomic, strong) GLessonItem *lesson;

- (void) stopScroll;
- (void) freeScroll;

- (void)textFieldDidChanged:(UITextField *)textField;

@end
