//
//  ViewController.h
//  englearning-kids
//
//  Created by alex on 8/13/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBaseViewController.h"
#import "BMainViewController.h"
#import "AppDelegate.h"

@interface BHomeViewController : BBaseViewController<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, assign) int level;
@property (nonatomic, assign) int studyingLevel;
@property (nonatomic, strong) NSObject* meta1;
@property (nonatomic, strong) NSObject* meta2;
@property (nonatomic, strong) NSObject* meta3;

+ (BHomeViewController*) singleton;
- (void) gotoLevel: (int) level;

@end

