//
//  PEditPlayListViewController.m
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/16/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PEditPlayListViewController.h"

@interface PEditPlayListViewController()
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtPlayListName;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIImageView *imgTrash;
@property (weak, nonatomic) IBOutlet UIButton *btnTrash;

@end

@implementation PEditPlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.txtPlayListName.text = self.strPlayListName;
    if (self.isEdit) {
        self.lbTitle.text = @"Edit playlist";
        self.imgTrash.hidden = NO;
        self.btnTrash.hidden = NO;
        [self.btnCreate setTitle:@"SAVE" forState:UIControlStateNormal];
    } else {
        self.lbTitle.text = @"Create new playlist";
        self.imgTrash.hidden = YES;
        self.btnTrash.hidden = YES;
        [self.btnCreate setTitle:@"CREATE" forState:UIControlStateNormal];
    }
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


- (IBAction)onCreate:(id)sender {
    if (self.txtPlayListName.text.length < 1) {
        return;
    }
    if (self.isEdit) {
        [self.vcPlayList editPlayList:self.strPlayListName new:self.txtPlayListName.text];
    } else {
        [self.vcPlayList createPlayList:self.txtPlayListName.text];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onTrash:(id)sender {
    [self.vcPlayList deletePlayList:self.strPlayListName];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
