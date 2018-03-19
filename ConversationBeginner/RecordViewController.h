//
//  RecordViewController.h
//  EnglishConversation
//
//  Created by SongJiang on 3/8/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonViewController.h"
@interface RecordViewController : UIViewController
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) LessonViewController* superView;
@end
