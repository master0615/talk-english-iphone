//
//  LessonByLevelChildViewController.h
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCommonViewController.h"

#import "GLevelItem.h"

@interface GLessonByLevelChildController : GCommonViewController

@property (nonatomic, assign) GLevelItem *currLevel;

@end
