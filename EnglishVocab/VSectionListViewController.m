//
//  SectionListViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 3/28/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VSectionListViewController.h"
#import "VWordListViewController.h"
#import "VAppInfo.h"
#import "VWordSearchViewController.h"
#import "VAnalytics.h"

@interface VSectionListViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;

@end

@implementation VSectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"vocab_lesson_title"]];
    [VAnalytics sendScreenName:@"Section List Screen"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"show"]){
        VWordListViewController *vc = segue.destinationViewController;
        NSNumber* section = sender;
        vc.mSection = [section integerValue];
    }
    if([segue.identifier isEqualToString:@"search"]){
        VWordSearchViewController *vc = segue.destinationViewController;
        vc.strSearchText = _txtSearch.text;
    }
}

- (IBAction)onSection:(id)sender {
    NSInteger section = [sender tag] - 1250;
    [self performSegueWithIdentifier:@"show" sender:@(section)];
    [VAnalytics sendEvent:@"Section Page" label:[NSString stringWithFormat:@"%d", section]];
}
- (IBAction)onSearch:(id)sender {
    [_txtSearch resignFirstResponder];
    [self performSegueWithIdentifier:@"search" sender:nil];
    [VAnalytics sendEvent:@"Search Page" label:_txtSearch.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self performSegueWithIdentifier:@"search" sender:nil];
    return NO;
}
@end
