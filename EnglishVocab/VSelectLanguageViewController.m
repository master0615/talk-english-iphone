//
//  SelectLanguageViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 4/17/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VSelectLanguageViewController.h"
#import "VAppInfo.h"
#import "AppDelegate.h"
#import "VAnalytics.h"

@interface VSelectLanguageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblLanguage;

@end

@implementation VSelectLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"app_name"]];
    
    BOOL nofirst = [[[NSUserDefaults standardUserDefaults] objectForKey:@"firstView"] boolValue];
    
    if(nofirst == YES){
    
        UIStoryboard *storyBoard;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            storyBoard = [UIStoryboard storyboardWithName:@"Main-iPad" bundle:nil];
        }else{
            storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        }
        // reload the view controllers
        UINavigationController *vcNav = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"MainNav"];
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController = vcNav;
    }
    [VAnalytics sendScreenName:@"Settings Screen"];
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
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstView"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard *storyBoard;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            storyBoard = [UIStoryboard storyboardWithName:@"Main-iPad" bundle:nil];
        }else{
            storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        }
        
        // reload the view controllers
        UINavigationController *vcNav = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"MainNav"];
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController = vcNav;
        
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
