//
//  StoryboardManager.h
//  TalkEnglish
//
//  Created by Xander Addison on 11/27/17.
//  Copyright © 2017 X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MenuViewController.h"
#import "SlideMenuController.h"
#import "PMenuViewController.h"
#import "BMenuViewController.h"
#import "PSlideMenuController.h"
#import "GMainViewController.h"
#import "LMainViewController.h"
#import "VMainViewController.h"
#import "BMainViewController.h"
#import "SMainViewController.h"


#ifndef DEFINE_SINGLETON
#define DEFINE_SINGLETON        + (instancetype)sharedInstance;
#endif

#ifndef IMPLEMENT_SINGLETON
#define IMPLEMENT_SINGLETON     + (instancetype)sharedInstance \
{ \
static dispatch_once_t once; \
static id sharedInstance; \
dispatch_once(&once, ^ \
{ \
sharedInstance = [self new]; \
}); \
return sharedInstance; \
}
#endif



@interface StoryboardManager : NSObject

DEFINE_SINGLETON

- (UIViewController *)getViewControllerWithIdentifierFromStoryboard:(NSString *)viewControllerIdentifier storyboardName:(NSString *)storyboardName;

- (void) setMainController:(UIViewController *) viewcontroller;

- (void) showConversationApp;

- (void) showESLApp;

- (void) showSpeakingApp;

- (void) showListeningApp;

- (void) showVocabularyApp;

- (void) showGrammarApp;

- (void) showPlayerApp;
@end
