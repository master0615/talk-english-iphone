//
//  PRecommendedAppsViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 4/18/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PRecommendedAppsViewController.h"
#import "PAppInfo.h"
#import "PEnv.h"
#import "PAnalytics.h"

@interface PRecommendedAppsViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation PRecommendedAppsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"Recommended Apps"];
    
    [PAnalytics sendScreenName:@"Recommended Apps Screen"];
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
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [PEnv currentEnglishConvApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [PAnalytics sendEvent:@"App English Conversation" label:@""];
    } else if (indexPath.row == 1) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [PEnv currentEnglishListeningApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [PAnalytics sendEvent:@"App English Listening" label:@""];
    }else if (indexPath.row == 2) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [PEnv currentTalkEnglishApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [PAnalytics sendEvent:@"App Talk English" label:@""];
    }else if (indexPath.row == 3) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [PEnv currentEnglishVocabApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [PAnalytics sendEvent:@"App English Vocab" label:@""];
    }else if (indexPath.row == 4) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [PEnv currentEnglishGrammarApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [PAnalytics sendEvent:@"App English Grammar" label:@""];
    }else if (indexPath.row == 5) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [PEnv currentEnglishBeginnerApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [PAnalytics sendEvent:@"App English Beginner" label:@""];
    }else if (indexPath.row == 6) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [PEnv currentEnglishKidsApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [PAnalytics sendEvent:@"App English Kids" label:@""];
    }else if (indexPath.row == 7) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [PEnv currentEnglishPracticeApp]]];
        [[UIApplication sharedApplication] openURL:url];
        [PAnalytics sendEvent:@"App Speaking Practice" label:@""];
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView* imgApps = [cell viewWithTag:1250];
    UILabel* lbTitle = [cell viewWithTag:1251];
    UILabel* lbContent = [cell viewWithTag:1252];
    if (indexPath.row == 0) {
        imgApps.image = [UIImage imageNamed:@"recommend_app1"];
        lbTitle.text = @"English Conversation";
        lbContent.text = @"Great English conversation practice.  Excellent for speaking practice.";
    } else if (indexPath.row == 1) {
        imgApps.image = [UIImage imageNamed:@"recommend_app2"];
        lbTitle.text = @"English Listening";
        lbContent.text = @"Improve your English listening with great lessons and fun quizzes.";
        lbContent.numberOfLines = 0;
    }else if (indexPath.row == 2){
        imgApps.image = [UIImage imageNamed:@"recommend_app3"];
        lbTitle.text = @"Learn to Speak English";
        lbContent.text = @"Over 800 lessons and 8000 audio files.\nAll Completely free!";
        lbContent.numberOfLines = 0;
    }else if (indexPath.row == 3){
        imgApps.image = [UIImage imageNamed:@"recommend_app4"];
        lbTitle.text = @"English Vocabulary";
        lbContent.text = @"Learn how to use words in sentences.\nLearn how to remember words.\nOver 40,000 audio files.";
        lbContent.numberOfLines = 0;
    }else if (indexPath.row == 4){
        imgApps.image = [UIImage imageNamed:@"recommend_app5"];
        lbTitle.text = @"English Grammar Book";
        lbContent.text = @"Learn the structure of English with this English grammar app. Very simple and fun with over 130 grammar lessons.";
        lbContent.numberOfLines = 0;
    }else if (indexPath.row == 5){
        imgApps.image = [UIImage imageNamed:@"recommend_app6"];
        lbTitle.text = @"Basic English for Beginners";
        lbContent.text = @"Learn English step by step. Great for beginners and completely FREE!";
        lbContent.numberOfLines = 0;
    }else if (indexPath.row == 6){
        imgApps.image = [UIImage imageNamed:@"recommend_app7"];
        lbTitle.text = @"Learn English for Kids";
        lbContent.text = @"POPULAR: The best way to learn English using an app. Thousands of pictures and audio files to help your child learn English";
        lbContent.numberOfLines = 0;
    }else if (indexPath.row == 7){
        imgApps.image = [UIImage imageNamed:@"recommend_app8"];
        lbTitle.text = @"English Speaking Practice";
        lbContent.text = @"Practice your English speaking using beginner level conversations (includes basic business conversations too).";
        lbContent.numberOfLines = 0;
    }
    
    
//    if(indexPath.row == 0){
//        img.image = [UIImage imageNamed:@"app3"];
//        labelTitle.text = @"English Listening";
//        labelDecription.text = @"Highly rated and very popular!\nImprove your English listening with this amazing FREE app.";
//        labelDecription.numberOfLines = 0;
//    }else if(indexPath.row == 1){
//        img.image = [UIImage imageNamed:@"app1"];
//        labelTitle.text = @"Learn to Speak English";
//        labelDecription.text = @"Over 800 lessons and 8000 audio files.\nAll Completely free!";
//        labelDecription.numberOfLines = 0;
//    } else if(indexPath.row == 2){
//        img.image = [UIImage imageNamed:@"app2"];
//        labelTitle.text = @"English Vocabulary";
//        labelDecription.text = @"Learn how to use words in sentences.\nLearn how to remember words.\nOver 40,000 audio files.";
//        labelDecription.numberOfLines = 0;
//    }
    
//    "recommend_page_03" = "English Conversation";
//    "recommend_page_04" = "Great English conversation practice.  Excellent for speaking practice.";
    return cell;
}


@end
