//
//  SplitMenuHandler.m
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 21..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SSplitMenuHandler.h"

@implementation SSplitMenuHandler

+ (SSplitMenuHandler*)popFrom:(UIViewController<SSplitMenuDelegate>*)from {
    if(NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        SSplitMenuHandler *handler = from.splitMenuHandler;
        [from.navigationItem setLeftBarButtonItem:nil animated:YES];
        from.splitMenuHandler = nil;
        return handler;
    }
    return nil;
}

+ (void)pushFromMasterViewController:(UIViewController*)master
                             toSegue:(UIStoryboardSegue*)segue
                           sendBlock:(void (^)(id destination))sendBlock
{
    id dest = [segue destinationViewController];
    if([dest isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navCtrl = dest;
        UIViewController<SSplitMenuDelegate> *to = (UIViewController<SSplitMenuDelegate>*)[navCtrl topViewController];
        [SSplitMenuHandler pushFromSplitView:master.splitViewController to:to];
        if(sendBlock != nil) sendBlock(to);
    }
    else {
        UIViewController<SSplitMenuDelegate> *to = dest;
        [SSplitMenuHandler pushFromSplitView:master.splitViewController to:to];
        if(sendBlock != nil) sendBlock(to);
    }
}

+ (void)pushFromSplitView:(UISplitViewController*)splitViewController
                       to:(UIViewController<SSplitMenuDelegate>*)to {
    if(NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        UIViewController<SSplitMenuDelegate> *from = (UIViewController<SSplitMenuDelegate>*)navigationController.topViewController;
        [SSplitMenuHandler pushFrom:from to:to];
    }
    else {
        SSplitMenuHandler *handler = [[SSplitMenuHandler alloc] initWithBarButtonItem:splitViewController.displayModeButtonItem
                                                                  popoverController:nil];
        [handler pushTo:to];
    }
}

+ (void)pushFrom:(UIViewController<SSplitMenuDelegate>*)from
              to:(UIViewController<SSplitMenuDelegate>*)to {
    [[SSplitMenuHandler popFrom:from] pushTo:to];
}

- (id) initWithBarButtonItem:(UIBarButtonItem*)barButtonItem
           popoverController:(UIPopoverController*)popoverController {
    self = [super init];
    if(self) {
        _barButtonItem = barButtonItem;
        _popoverController = popoverController;
    }
    return self;
}

- (void)pushTo:(UIViewController<SSplitMenuDelegate>*)to {
    [to.navigationItem setLeftBarButtonItem:_barButtonItem animated:YES];
    to.navigationItem.leftItemsSupplementBackButton = YES;
    to.splitMenuHandler = self;
    [_popoverController dismissPopoverAnimated:YES];
}

@end
