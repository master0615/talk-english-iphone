//
//  UIViewController+SlideMenu.m
//  EnglishConversation
//
//  Created by SongJiang on 3/3/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "UIViewController+SlideMenu.h"


@implementation UIViewController(SlideMenu)

-(void) setNavigationBarItem {
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"ic_menu_black_24dp"]];
    [self.navigationItem.backBarButtonItem setTitle:@""];
    [[self slideMenuController] removeLeftGestures];
    [[self slideMenuController] removeRightGestures];
    [[self slideMenuController] addLeftGestures];
    [[self slideMenuController] addRightGestures];
}

-(void) removeNavigationBarItem {
    self.navigationItem.rightBarButtonItem = nil;
    [[self slideMenuController] removeLeftGestures];
    [[self slideMenuController] removeRightGestures];
}

- (SlideMenuController*) slideMenuController{
    UIViewController* viewController = self;
    while (viewController != nil) {
        if ([viewController isKindOfClass:[SlideMenuController class]]) {
            return (SlideMenuController*)viewController;
        }
        viewController = viewController.parentViewController;
    }
    return nil;
}

- (void) addLeftBarButtonWithImage:(UIImage*) buttonImage{
    UIBarButtonItem* leftButton = [[UIBarButtonItem alloc] initWithImage:buttonImage style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeft)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void) addRightBarButtonWithImage:(UIImage*) buttonImage{
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:buttonImage style:UIBarButtonItemStylePlain target:self action:@selector(toggleRight)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void) toggleLeft{
    SlideMenuController* menuController = [self slideMenuController];
    [menuController toggleLeft];
}

- (void) toggleRight{
    [[self slideMenuController] toggleRight];
}

- (void) openLeft{
    [[self slideMenuController] openLeft];
}

- (void) openRight{
    [[self slideMenuController] openRight];
}

- (void) closeLeft{
    [[self slideMenuController] closeLeft];
}

- (void) closeRight{
    [[self slideMenuController] closeRight];
}

- (void) addPriorityToMenuGesuture:(UIPageViewController*)targetScrollView{
    SlideMenuController* menuController = [self slideMenuController];
    if (menuController == nil) {
        return;
    }
    
    if (menuController.view.gestureRecognizers == nil) {
        return;
    }
    for (UIGestureRecognizer* recognizer in menuController.view.gestureRecognizers) {
        if (recognizer != nil && [recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            for (UIGestureRecognizer* recognizer1 in targetScrollView.gestureRecognizers) {
                [recognizer1 requireGestureRecognizerToFail:recognizer];
            }
            
        }
    }
}
@end
