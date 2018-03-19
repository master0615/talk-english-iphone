//
//  RecommendedAppsViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 4/18/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "SRecommendedAppsViewController.h"
#import "SEnv.h"
#import "SAnalytics.h"

@interface SRecommendedAppsViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation SRecommendedAppsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"TalkEnglish Offline";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [SAnalytics sendScreenName:@"Recommended Apps Screen"];
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
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [SEnv currentEnglishConvApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [SAnalytics sendEvent:@"App English Conversation" label:@""];
    }else if (indexPath.row == 1) {
        [SAnalytics sendEvent:@"Recommended App"
                       label:@"English Listening App"];
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [SEnv currentEnglishListeningApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [SAnalytics sendEvent:@"App English Listening" label:@""];
    } else if (indexPath.row == 2) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [SEnv currentEnglishVocabApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [SAnalytics sendEvent:@"App English Vocabulary" label:@""];
    } else if (indexPath.row == 3) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [SEnv currentEnglishPlayerApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [SAnalytics sendEvent:@"App English Player" label:@""];
    } else if (indexPath.row == 4) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [SEnv currentEnglishBeginnerApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [SAnalytics sendEvent:@"App English Beginner" label:@""];
    } else if (indexPath.row == 5) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [SEnv currentEnglishKidsApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [SAnalytics sendEvent:@"App English Kids" label:@""];
    } else if (indexPath.row == 6) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [SEnv currentEnglishGrammarApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [SAnalytics sendEvent:@"App English Grammar" label:@""];
    } else if (indexPath.row == 7) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [SEnv currentEnglishPracticeApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [SAnalytics sendEvent:@"English Speaking Practice" label:@""];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView* imgApps = [cell viewWithTag:1250];
    UILabel* lbTitle = [cell viewWithTag:1251];
    UILabel* lbContent = [cell viewWithTag:1252];
    if(indexPath.row == 0){
        imgApps.image = [UIImage imageNamed:@"ic_recommend_app1.jpg"];
        lbTitle.text = @"English Conversation";
        lbContent.text = @"Great English conversation practice.  Excellent for speaking practice.";
    }else if (indexPath.row == 1) {
        imgApps.image = [UIImage imageNamed:@"ic_recommend_app3.png"];
        lbTitle.text = @"English Listening";
        lbContent.text = @"Highly rated and very popular!\nImprove your English listening with this amazing FREE app.";
    }else if (indexPath.row == 2) {
        imgApps.image = [UIImage imageNamed:@"ic_recommend_app2.png"];
        lbTitle.text = @"English Vocabulary";
        lbContent.text = @"Learn how to use words in sentences.\nLearn how to remember words.\nOver 40,000 audio files.";
    } else if(indexPath.row == 3){
        imgApps.image = [UIImage imageNamed:@"ic_recommend_app4.png"];
        lbTitle.text = @"English Listening Player";
        lbContent.text = @"Listen to English conversations and English lessons.  Create playlists and listen for hours without clicking on sentences.";
    } else if(indexPath.row == 4){
        imgApps.image = [UIImage imageNamed:@"ic_recommend_app5.png"];
        lbTitle.text = @"Basic English for Beginners";
        lbContent.text = @"Learn English step by step. Great for beginners and completely FREE!";
    } else if(indexPath.row == 5){
        imgApps.image = [UIImage imageNamed:@"ic_recommend_app6.png"];
        lbTitle.text = @"Learn English for Kids";
        lbContent.text = @"POPULAR: The best way to learn English using an app. Thousands of pictures and audio files to help your child learn English";
    } else if(indexPath.row == 6){
        imgApps.image = [UIImage imageNamed:@"ic_recommend_app7.png"];
        lbTitle.text = @"English Grammar Book";
        lbContent.text = @"Learn the structure of English with this English grammar app. Very simple and fun with over 130 grammar lessons.";
    } else if(indexPath.row == 7){
        imgApps.image = [UIImage imageNamed:@"ic_recommend_app8.png"];
        lbTitle.text = @"English Speaking Practice";
        lbContent.text = @"Practice your English speaking using beginner level conversations (includes basic business conversations too).";
    }
    return cell;
}


@end
