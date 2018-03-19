//
//  RecommendedAppsViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 4/18/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VRecommendedAppsViewController.h"
#import "VAppInfo.h"
#import "VEnv.h"
#import "VAnalytics.h"

@interface VRecommendedAppsViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation VRecommendedAppsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"main_page_13"]];
    
    [VAnalytics sendScreenName:@"Recommended Apps Screen"];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        return 150;
    return 120;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
    if (indexPath.row == 0) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [VEnv currentEnglishConvApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [VAnalytics sendEvent:@"App English Conversation" label:@""];
    } else if (indexPath.row == 1) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [VEnv currentEnglishListeningApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [VAnalytics sendEvent:@"App English Listening" label:@""];
    }else if (indexPath.row == 2) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [VEnv currentTalkEnglishApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [VAnalytics sendEvent:@"App Talk English" label:@""];
    }else if (indexPath.row == 3) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [VEnv currentEnglishPlayerApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [VAnalytics sendEvent:@"App Listening player" label:@""];
    }else if (indexPath.row == 4) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [VEnv currentEnglishGrammarApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [VAnalytics sendEvent:@"App English Grammar Book" label:@""];
    }else if (indexPath.row == 5) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [VEnv currentEnglishBeginnerApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [VAnalytics sendEvent:@"Basic English for Beginners" label:@""];
    }else if (indexPath.row == 6) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [VEnv currentEnglishKidsApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [VAnalytics sendEvent:@"Learn English for Kids" label:@""];
    }else if (indexPath.row == 7) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [VEnv currentEnglishKidsApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [VAnalytics sendEvent:@"Learn English for Kids" label:@""];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView* imgApps = [cell viewWithTag:1250];
    UILabel* lbTitle = [cell viewWithTag:1251];
    UILabel* lbContent = [cell viewWithTag:1252];
    if (indexPath.row == 0) {
        imgApps.image = [UIImage imageNamed:@"recommend_app2"];
        lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"recommend_page_03"];
        lbContent.text = [[VAppInfo sharedInfo] localizedStringForKey:@"recommend_page_04"];
    } else if (indexPath.row == 1) {
        imgApps.image = [UIImage imageNamed:@"recommend_app3"];
        lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"app_listening_title"];
        lbContent.text = [[VAppInfo sharedInfo] localizedStringForKey:@"app_listening_desc"];
    }else if (indexPath.row == 2) {
        imgApps.image = [UIImage imageNamed:@"recommend_app1"];
        lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"recommend_page_01"];
        lbContent.text = [[VAppInfo sharedInfo] localizedStringForKey:@"recommend_page_02"];
    }else if (indexPath.row == 3) {
        imgApps.image = [UIImage imageNamed:@"recommend_app4"];
        lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"recommend_page_04_1"];
        lbContent.text = [[VAppInfo sharedInfo] localizedStringForKey:@"recommend_page_desc_04"];
    }else if (indexPath.row == 4) {
        imgApps.image = [UIImage imageNamed:@"recommend_app5"];
        lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"recommend_page_05"];
        lbContent.text = [[VAppInfo sharedInfo] localizedStringForKey:@"recommend_page_desc_05"];
    }else if (indexPath.row == 5) {
        imgApps.image = [UIImage imageNamed:@"recommend_app6"];
        lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"recommend_page_06"];
        lbContent.text = [[VAppInfo sharedInfo] localizedStringForKey:@"recommend_page_desc_06"];
    }else if (indexPath.row == 6) {
        imgApps.image = [UIImage imageNamed:@"recommend_app7"];
        lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"recommend_page_07"];
        lbContent.text = [[VAppInfo sharedInfo] localizedStringForKey:@"recommend_page_desc_07"];
    }else if (indexPath.row == 7) {
        imgApps.image = [UIImage imageNamed:@"recommend_app8"];
        lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"recommend_page_08"];
        lbContent.text = [[VAppInfo sharedInfo] localizedStringForKey:@"recommend_page_desc_08"];
    }
    
    return cell;
}


@end
