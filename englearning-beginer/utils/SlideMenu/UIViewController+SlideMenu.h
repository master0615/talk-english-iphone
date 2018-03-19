//
//  UIViewController+SlideMenu.h
//  EnglishConversation
//
//  Created by SongJiang on 3/3/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideMenuController.h"

@interface UIViewController(SlideMenu)


-(void) setNavigationBarItem;
-(void) removeNavigationBarItem;
- (void) addLeftBarButtonWithImage:(UIImage*) buttonImage;
- (void) addRightBarButtonWithImage:(UIImage*) buttonImage;
- (void) toggleLeft;
- (void) toggleRight;
- (void) openLeft;
- (void) openRight;
- (void) closeLeft;
- (void) closeRight;
- (void) addPriorityToMenuGesuture:(UIPageViewController*)targetScrollView;
- (SlideMenuController*) slideMenuController;
@end
