//
//  AppInfoViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 4/14/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VAppInfoViewController.h"
#import "VAppInfo.h"
#import "VPurchaseViewController.h"
#import "VTutorialViewController.h"
#import "VAnalytics.h"

@interface VAppInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbAppInfo1;
@property (weak, nonatomic) IBOutlet UILabel *lbAppInfo2;
@property (weak, nonatomic) IBOutlet UILabel *lbAppInfo27;
@property (weak, nonatomic) IBOutlet UILabel *lbAppInfo3;
@property (weak, nonatomic) IBOutlet UILabel *lbAppInfo28;
@property (weak, nonatomic) IBOutlet UILabel *lbAppInfo29;
@property (weak, nonatomic) IBOutlet UIButton *btnVideo05;
@property (weak, nonatomic) IBOutlet UILabel *lbAppInfo30;
@property (weak, nonatomic) IBOutlet UILabel *lbAppInfo31;
@property (weak, nonatomic) IBOutlet UIButton *btnVideo05_1;
@property (weak, nonatomic) IBOutlet UILabel *lbAppInfo6;
@property (weak, nonatomic) IBOutlet UILabel *lbAppInfo7;
@property (weak, nonatomic) IBOutlet UILabel *lbAppInfo8;
@property (weak, nonatomic) IBOutlet UILabel *lbAppInfo9;
@property (weak, nonatomic) IBOutlet UILabel *lbAppInfo10;
@property (weak, nonatomic) IBOutlet UILabel *lbAppInfo11;


@end

@implementation VAppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"main_page_07"]];
    
    [_btnVideo05 setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"app_info_05"] forState:UIControlStateNormal];
    [_btnVideo05_1 setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"app_info_05"] forState:UIControlStateNormal];
    
    _lbAppInfo1.text = [[VAppInfo sharedInfo] localizedStringForKey:@"app_info_01"];
    _lbAppInfo2.text = [[VAppInfo sharedInfo] localizedStringForKey:@"app_info_02"];
    _lbAppInfo27.text = [[VAppInfo sharedInfo] localizedStringForKey:@"app_info_27"];
    _lbAppInfo3.text = [[VAppInfo sharedInfo] localizedStringForKey:@"app_info_03"];
    _lbAppInfo28.text = [[VAppInfo sharedInfo] localizedStringForKey:@"app_info_28"];
    _lbAppInfo29.text = [[VAppInfo sharedInfo] localizedStringForKey:@"app_info_29"];
    _lbAppInfo30.text = [[VAppInfo sharedInfo] localizedStringForKey:@"app_info_30"];
    _lbAppInfo31.text = [[VAppInfo sharedInfo] localizedStringForKey:@"app_info_31"];
    _lbAppInfo6.text = [[VAppInfo sharedInfo] localizedStringForKey:@"app_info_06"];
    _lbAppInfo7.text = [[VAppInfo sharedInfo] localizedStringForKey:@"app_info_07"];
    _lbAppInfo8.text = [[VAppInfo sharedInfo] localizedStringForKey:@"app_info_08"];
    _lbAppInfo9.text = [[VAppInfo sharedInfo] localizedStringForKey:@"app_info_09"];
    _lbAppInfo10.text = [[VAppInfo sharedInfo] localizedStringForKey:@"app_info_10"];
    _lbAppInfo11.text = [[VAppInfo sharedInfo] localizedStringForKey:@"app_info_11"];
    
    
    [VAnalytics sendScreenName:@"App Information Screen"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onWatchVideo1:(id)sender {
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self getVideo1Url]]];
    VTutorialViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VTutorialViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    [VAnalytics sendEvent:@"App Info Video1 Page" label:@""];
}
- (IBAction)onWatchVideo2:(id)sender {
    VTutorialViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VTutorialViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    [VAnalytics sendScreenName:@"App Info Video2 Screen"];
}
- (IBAction)onPurchase:(id)sender {
    VPurchaseViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VPurchaseViewController"];
    vc.section = 0;
    [self.navigationController pushViewController:vc animated:YES];
    [VAnalytics sendScreenName:@"Purchase All Screen"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSString*)getVideo1Url{
    LanguageType type = [VAppInfo sharedInfo].currentLanguage;
    if(type == Lang_fr) return @"https://youtu.be/WzjIt7x7324";
    else if(type == Lang_ko) return @"https://youtu.be/_9YyeCOlmeY";
    else if(type == Lang_ar) return @"https://youtu.be/9RLQTEZoMAA";
    else if(type == Lang_bn) return @"https://youtu.be/zK4zlZ8Ge54";
    else if(type == Lang_hi) return @"https://youtu.be/75_4wMgxkIY";
    else if(type == Lang_ta) return @"https://youtu.be/rgSq667LQjg";
    else if(type == Lang_zh) return @"https://youtu.be/kLO17Ca1x5s";
    else if(type == Lang_de) return @"https://youtu.be/ZqPK-yaE1k0";
    else if(type == Lang_iw) return @"https://youtu.be/44uc1fJkylM";
//    else if(type == Lang_he) return @"https://youtu.be/44uc1fJkylM"; // old
    else if(type == Lang_in) return @"https://youtu.be/j4ZAeWYwPIk";
//    else if(type == Lang_id) return @"https://youtu.be/j4ZAeWYwPIk"; // old
    else if(type == Lang_it) return @"https://youtu.be/yqs7VhrLy60";
    else if(type == Lang_ja) return @"https://youtu.be/firXSB2aWps";
    else if(type == Lang_pl) return @"https://youtu.be/NnvrHoAPrbA";
    else if(type == Lang_pt) return @"https://youtu.be/5KjWgTWAefM";
    else if(type == Lang_ru) return @"https://youtu.be/OdjXGFc8n4U";
    else if(type == Lang_es) return @"https://youtu.be/VyfJ1cyDs34";
    else if(type == Lang_th) return @"https://youtu.be/jj8_-sdB1VY";
    else if(type == Lang_tr) return @"https://youtu.be/k_2rTC6i8_A";
    else if(type == Lang_vi) return @"https://youtu.be/WZHhXRh2rS8";
    else return @"https://youtu.be/nmd74ivVTjg";

}
@end
