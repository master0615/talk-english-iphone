//
//  ViewController.m
//  TalkEnglishPlayer
//
//  Created by SongJiang on 7/31/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PViewController.h"
#import "PMenuViewController.h"
#import "PSlideMenuController.h"
@interface PViewController ()

@end

@implementation PViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UINavigationController* nvc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    PMenuViewController* leftController = (PMenuViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    
    PSlideMenuController *menuController = [[PSlideMenuController alloc] init:nvc leftMenuViewController:leftController];
    [self.navigationController setViewControllers:@[menuController]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
