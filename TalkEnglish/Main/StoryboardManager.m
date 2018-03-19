//
//  StoryboardManager.m
//  TalkEnglish
//
//  Created by Xander Addison on 11/27/17.
//  Copyright © 2017 X. All rights reserved.
//

#import "StoryboardManager.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@implementation StoryboardManager

IMPLEMENT_SINGLETON

- (UIViewController *)getViewControllerWithIdentifierFromStoryboard:(NSString *)viewControllerIdentifier storyboardName:(NSString *)storyboardName {
    UIStoryboard *stb = [UIStoryboard storyboardWithName: storyboardName bundle: nil];
    UIViewController *vc = [stb instantiateViewControllerWithIdentifier:viewControllerIdentifier];
    return vc;
}

- (void) setMainController:(UIViewController *) viewcontroller {
//    MainViewController* mainVC = (MainViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"MainViewController" storyboardName:@"Main"];
    [[AppDelegate shared].rootNavigationController setViewControllers:@[viewcontroller]];

}

- (void) showConversationApp {
    UINavigationController* nvc = (UINavigationController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"ConversationNavigationController" storyboardName:@"Conversation"];
    MenuViewController* leftController = (MenuViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"MenuViewController" storyboardName:@"Conversation"];
    
    SlideMenuController *menuController = [[SlideMenuController alloc] init:nvc leftMenuViewController:leftController];
    
    [[AppDelegate shared].rootNavigationController setNavigationBarHidden:true];
    [[AppDelegate shared].rootNavigationController setViewControllers:@[menuController] animated:false];
}

- (void) showESLApp {
    UINavigationController* nvc = (UINavigationController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"MainNavigationController" storyboardName:@"Learning_iPhone"];
    BMenuViewController* leftController = (BMenuViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"BMenuViewController" storyboardName:@"Learning_iPhone"];
    
    SlideMenuController *menuController = [[SlideMenuController alloc] init:nvc leftMenuViewController:leftController];
    
    [[AppDelegate shared].rootNavigationController setNavigationBarHidden:true];
    [[AppDelegate shared].rootNavigationController setViewControllers:@[menuController] animated:false];
}

- (void) showSpeakingApp {
    [[AppDelegate shared].rootNavigationController setNavigationBarHidden:false];
    SMainViewController* mainVC = (SMainViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"SMainViewController" storyboardName:@"Speaking"];
    [[StoryboardManager sharedInstance] setMainController:mainVC];
}

- (void) showListeningApp {
    [[AppDelegate shared].rootNavigationController setNavigationBarHidden:false];
    LMainViewController* mainVC = (LMainViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"LMainViewController" storyboardName:@"Listening_iPhone"];
    [[StoryboardManager sharedInstance] setMainController:mainVC];
}

- (void) showVocabularyApp {
    [[AppDelegate shared].rootNavigationController setNavigationBarHidden:false];
    VMainViewController* vmainVC = (VMainViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"VMainViewController" storyboardName:@"Vocab"];
    [[StoryboardManager sharedInstance] setMainController:vmainVC];
}

- (void) showGrammarApp {
    [[AppDelegate shared].rootNavigationController setNavigationBarHidden:false];
    GMainViewController* gmainVC = (GMainViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"GMainViewController" storyboardName:@"Grammar"];
    [[StoryboardManager sharedInstance] setMainController:gmainVC];
}

- (void) showPlayerApp {
    UINavigationController* nvc = (UINavigationController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"PlayerNavigationController" storyboardName:@"Talk"];
    PMenuViewController* leftController = (PMenuViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"MenuViewController" storyboardName:@"Talk"];
    
    SlideMenuController *menuController = [[SlideMenuController alloc] init:nvc leftMenuViewController:leftController];
    
    [AppDelegate shared].rootNavigationController.navigationBarHidden = true;
    [[AppDelegate shared].rootNavigationController setViewControllers:@[menuController] animated:false];
}

@end
