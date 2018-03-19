//
//  LHomeViewController.h
//  englistening
//
//  Created by alex on 5/18/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMainViewController.h"
#import "LBaseViewController.h"
#define MAIN_ITEM_TAB ((int)0)
#define MENU_ITEM_TAB ((int)1)
#define PREFIX_LD1 "ld1"
#define PREFIX_LD2 "ld2"
#define PREFIX_LD3 "ld3"
#define PREFIX_LD4 "ld4"
#define PREFIX_LD5 "ld5"
#define PREFIX_LD6 "ld6"

#define SHARE_CONTENT "English Listening"

@interface LHomeViewController : UIViewController
@property (nonatomic, assign) int selectedTab;

+ (LHomeViewController*) singleton;
- (void)gotoSection: (NSString*) prefix;
@end
