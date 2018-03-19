//
//  BLessonsListViewController.h
//  englearning-kids
//
//  Created by sworld on 8/21/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLessonsListViewController : UIViewController

- (void) refresh;
@property (nonatomic, strong) NSArray* lessons;

@end
