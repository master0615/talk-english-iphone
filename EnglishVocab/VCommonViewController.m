//
//  CommonViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 4/20/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VCommonViewController.h"
#import "VAnalytics.h"
#import "VEnv.h"
#import "VAppInfo.h"

@interface VCommonViewController ()

@end

@implementation VCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

@end
