//
//  SplitMenuHandler.h
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 21..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSplitMenuHandler;

@protocol SSplitMenuDelegate <NSObject>
@property SSplitMenuHandler *splitMenuHandler;
@end

@interface SSplitMenuHandler : NSObject

@property UIBarButtonItem *barButtonItem;
@property UIPopoverController *popoverController;

+ (SSplitMenuHandler*)popFrom:(UIViewController<SSplitMenuDelegate>*)from;

+ (void)pushFromMasterViewController:(UIViewController*)master
                             toSegue:(UIStoryboardSegue*)segue
                           sendBlock:(void (^)(id destination))sendBlock;

+ (void)pushFromSplitView:(UISplitViewController*)splitViewController
                       to:(UIViewController<SSplitMenuDelegate>*)to;

- (id) initWithBarButtonItem:(UIBarButtonItem*)barButtonItem
           popoverController:(UIPopoverController*)popoverController;

- (void)pushTo:(UIViewController<SSplitMenuDelegate>*)to;

@end


