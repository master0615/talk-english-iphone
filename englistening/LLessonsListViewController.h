//
//  LessonsListViewController.h
//  englistening
//
//  Created by alex on 5/4/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCommonBaseViewController.h"

@interface LLessonsListViewController : LCommonBaseViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString* prefix;
@end
