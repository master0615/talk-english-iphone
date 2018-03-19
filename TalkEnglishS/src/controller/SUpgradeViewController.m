//
//  UpgradeViewController.m
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 22..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SUpgradeViewController.h"
#import "SEnv.h"

@interface SUpgradeViewController ()
{
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;

@end

@implementation SUpgradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
       UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self.navigationItem.leftBarButtonItem.target performSelector:self.navigationItem.leftBarButtonItem.action
                                                           withObject:self.navigationItem];
    }
    
    _scrollContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:_scrollContentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:_scrollContentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:rightConstraint];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SAnalytics sendScreenName:@"Upgrade Screen"];
}

- (IBAction)doUpgrade:(id)sender {
    [SEnv openItunesOfflinleVersionLink];
    [SAnalytics sendEvent:@"Open Upgrade"
                   label:@""];
}

@end
