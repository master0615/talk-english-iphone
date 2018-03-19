//
//  SettingViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 4/17/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VSettingViewController.h"
#import "VAppInfo.h"
#import "VEnv.h"
#import "VAnalytics.h"

@interface VSettingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tblLang;
@property (weak, nonatomic) IBOutlet UILabel *lbSettings;
@property (strong, nonatomic) UIBarButtonItem *btnShare;
@end

@implementation VSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"main_page_15"]];
    
// Remove share button 2018-01-27 by GoldRabbit
//    _btnShare = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonDidClick)];
//    self.navigationItem.rightBarButtonItem = _btnShare;
    
    //[self.navigationItem setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_lesson_title"]];
    self.lbSettings.text = [[VAppInfo sharedInfo] localizedStringForKey:@"settings_page_05"];
    [VAnalytics sendScreenName:@"Setting Screen"];
}

- (void)shareButtonDidClick {
    NSMutableArray * objectToShare = [[NSMutableArray alloc] init];
    [objectToShare addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"share_content"]];
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
    NSString* url = [NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [VEnv currentAppId]];
    [objectToShare addObject:url];
    
    UIActivityViewController* controller = [[UIActivityViewController alloc] initWithActivityItems:objectToShare applicationActivities:nil];
    
    // Exclude all activities except AirDrop.
    NSArray *excludedActivities = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        //excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,                                    UIActivityTypePostToWeibo, UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    }
    
    controller.excludedActivityTypes = excludedActivities;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)
        controller.popoverPresentationController.sourceView = self.view;
    [self presentViewController:controller animated:YES completion:nil];
    
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tblLang selectRowAtIndexPath:[NSIndexPath indexPathForRow:[VAppInfo sharedInfo].currentLanguage - 1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSArray* arrLang = @[@"en", @"hi", @"bn", @"ta", @"it", @"pt", @"es", @"fr", @"de", @"tr", @"pl", @"ru", @"ko", @"ja", @"zh", @"in", @"th", @"vi"/*, @"ar", @"iw"*/];
    NSLocale *nLocale = [[NSLocale alloc] initWithLocaleIdentifier:arrLang[indexPath.row]];
    NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    NSString* strDisplayName = [nLocale displayNameForKey:NSLocaleIdentifier value:arrLang[indexPath.row]];
    NSString* strEnDisplayName = [enLocale displayNameForKey:NSLocaleIdentifier value:arrLang[indexPath.row]];
    NSLog(@"%@ %@", strDisplayName, strEnDisplayName);
    NSString* strText = [NSString stringWithFormat:@"%@ - %@", strDisplayName, strEnDisplayName];
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:strText preferredStyle:UIAlertControllerStyleAlert];
    [actionSheet addAction:[UIAlertAction actionWithTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"rate_app_03"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"rate_app_02"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        [[VAppInfo sharedInfo] setCurrentLanguage:indexPath.row + 1];
        [self.navigationController popViewControllerAnimated:YES];
        
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    
    return;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* arrLang = @[@"en", @"hi", @"bn", @"ta", @"it", @"pt", @"es", @"fr", @"de", @"tr", @"pl", @"ru", @"ko", @"ja", @"zh", @"in", @"th", @"vi"/*, @"ar", @"iw"*/];
    NSLocale *nLocale = [[NSLocale alloc] initWithLocaleIdentifier:arrLang[indexPath.row]];
    NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    NSString* strDisplayName = [nLocale displayNameForKey:NSLocaleIdentifier value:arrLang[indexPath.row]];
    NSString* strEnDisplayName = [enLocale displayNameForKey:NSLocaleIdentifier value:arrLang[indexPath.row]];
    NSLog(@"%@ %@", strDisplayName, strEnDisplayName);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel* lbDisplayName = [cell viewWithTag:1250];
    lbDisplayName.text = [NSString stringWithFormat:@"%@ - %@", strDisplayName, strEnDisplayName];
    if ([arrLang[indexPath.row] isEqualToString:@"ar"] || [arrLang[indexPath.row] isEqualToString:@"iw"]) {
        lbDisplayName.textAlignment = NSTextAlignmentRight;
    }else{
        lbDisplayName.textAlignment = NSTextAlignmentLeft;
    }
    return cell;
}

@end
