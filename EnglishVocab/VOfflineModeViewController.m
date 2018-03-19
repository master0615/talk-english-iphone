//
//  VOfflineModeViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 7/27/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VOfflineModeViewController.h"
#import "VAppInfo.h"
#import "VPurchaseInfo.h"
#import "VSettingViewController.h"
#import "VDownloadManager.h"
#import "VPurchaseViewController.h"
#import "VAudioFileItem.h"
#import "VReachability.h"

@interface VOfflineModeViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewDownloadProgress;
@property (weak, nonatomic) IBOutlet UILabel *lbDownload;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeLanguage;
@property (weak, nonatomic) IBOutlet UILabel *lbOfflineMode;
@property (weak, nonatomic) IBOutlet UILabel *lbBook1;
@property (weak, nonatomic) IBOutlet UIImageView *imgBook1;
@property (weak, nonatomic) IBOutlet UILabel *lbBook2;
@property (weak, nonatomic) IBOutlet UIImageView *imgBook2;
@property (weak, nonatomic) IBOutlet UILabel *lbBook3;
@property (weak, nonatomic) IBOutlet UIImageView *imgBook3;
@property (weak, nonatomic) IBOutlet UILabel *lbBook4;
@property (weak, nonatomic) IBOutlet UIImageView *imgBook4;
@property (weak, nonatomic) IBOutlet UILabel *lbBook5;
@property (weak, nonatomic) IBOutlet UIImageView *imgBook5;
@property (weak, nonatomic) IBOutlet UILabel *lbBook6;
@property (weak, nonatomic) IBOutlet UIImageView *imgBook6;
@property (weak, nonatomic) IBOutlet UILabel *lbBook7;
@property (weak, nonatomic) IBOutlet UIImageView *imgBook7;
@property (weak, nonatomic) IBOutlet UILabel *lbBook8;
@property (weak, nonatomic) IBOutlet UIImageView *imgBook8;
@property (weak, nonatomic) IBOutlet UILabel *lbBook9;
@property (weak, nonatomic) IBOutlet UIImageView *imgBook9;
@property (weak, nonatomic) IBOutlet UILabel *lbBook10;
@property (weak, nonatomic) IBOutlet UIImageView *imgBook10;
@property (weak, nonatomic) IBOutlet UILabel *lbBook11;
@property (weak, nonatomic) IBOutlet UIImageView *imgBook11;

@end

@implementation VOfflineModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self hideProgressBar];
    if([VDownloadManager sharedInstance].nStartedDownload == 1) {
        VReachability *networkReachability = [VReachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            NSLog(@"There IS NO internet connection");
        } else {
            NSLog(@"There IS internet connection");
            self.viewDownloadProgress.hidden = NO;
            if ([VDownloadManager sharedInstance].nTotalCount > 0) {
                float fProgress = (float)((double)[VDownloadManager sharedInstance].nDownloadCount / (double)[VDownloadManager sharedInstance].nTotalCount);
                [self setProgress:fProgress];
            } else {
                [self setProgress:0];
            }
        }
    }
}

/*
 * Add setUpdateOffline 2018-01-26 by GoldRabbit
 */
- (void) setUpdateOffline:(NSInteger)nBookNum on:(int)nOn{
    [[VPurchaseInfo sharedInfo] setUpdate:nBookNum];
    [[VPurchaseInfo sharedInfo] setUpdateOffline:nBookNum on:nOn];
}

- (void)updateUI{
    [self.navigationItem setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"main_page_15"]];
    [self.btnChangeLanguage setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"settings_page_04"] forState:UIControlStateNormal];
    self.lbOfflineMode.text = [[VAppInfo sharedInfo] localizedStringForKey:@"main_offline"];
    self.lbBook1.text = [[VAppInfo sharedInfo] localizedStringForKey:@"section_01"];
    self.lbBook2.text = [[VAppInfo sharedInfo] localizedStringForKey:@"section_02"];
    self.lbBook3.text = [[VAppInfo sharedInfo] localizedStringForKey:@"section_03"];
    self.lbBook4.text = [[VAppInfo sharedInfo] localizedStringForKey:@"section_04"];
    self.lbBook5.text = [[VAppInfo sharedInfo] localizedStringForKey:@"section_05"];
    self.lbBook6.text = [[VAppInfo sharedInfo] localizedStringForKey:@"section_06"];
    self.lbBook7.text = [[VAppInfo sharedInfo] localizedStringForKey:@"section_07"];
    self.lbBook8.text = [[VAppInfo sharedInfo] localizedStringForKey:@"section_08"];
    self.lbBook9.text = [[VAppInfo sharedInfo] localizedStringForKey:@"section_09"];
    self.lbBook10.text = [[VAppInfo sharedInfo] localizedStringForKey:@"section_10"];
    self.lbBook11.text = [[VAppInfo sharedInfo] localizedStringForKey:@"section_11"];
    NSArray* arrayImageView = [NSArray arrayWithObjects: self.imgBook1, self.imgBook2, self.imgBook3, self.imgBook4, self.imgBook5, self.imgBook6,self.imgBook7, self.imgBook8, self.imgBook9, self.imgBook10, self.imgBook11, nil];
    for (int i = 1; i <= 11; i ++) {
        NSInteger isPurchased = [[VPurchaseInfo sharedInfo].purchased[i] integerValue];
        if([[VPurchaseInfo sharedInfo].purchased[0] integerValue] == 1){
            isPurchased = 1;
        }
        UIImageView* img = arrayImageView[i - 1];
        if(isPurchased == 0){
            img.image = [UIImage imageNamed:@"ic_offlinemode_off"];
        } else {
            int offlineMode = [[VPurchaseInfo sharedInfo] isOfflineMode:i];
            if(offlineMode == 1) {
                img.image = [UIImage imageNamed:@"ic_offlinemode_on"];
            }else {
                img.image = [UIImage imageNamed:@"ic_offlinemode_off"];
            }
        }
    }
    self.lbDownload.text = [[VAppInfo sharedInfo] localizedStringForKey:@"message_downloading"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [VDownloadManager sharedInstance].vc = self;
    [self updateUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [VDownloadManager sharedInstance].vc = nil;
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
- (IBAction)onChangeLanguage:(id)sender {
    VSettingViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)onQuestionMark:(id)sender {
    NSString* strText1 = [[VAppInfo sharedInfo] localizedStringForKey:@"turnon_offline"];
    NSString* strText2 = [[VAppInfo sharedInfo] localizedStringForKey:@"turnoff_offline"];
    NSString* strText3 = [[VAppInfo sharedInfo] localizedStringForKey:@"offline_desc1"];
    NSString* strText4 = [[VAppInfo sharedInfo] localizedStringForKey:@"offline_desc2"];
    NSString* strAllText = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@", strText1, strText2, strText3, strText4];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:strAllText
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
- (void) showProgressBar {
    self.viewDownloadProgress.hidden = NO;
    [self.progressBar setProgress:0.0f];
}

- (void) setProgress:(float) fProgress {
    self.viewDownloadProgress.hidden = NO;
    self.progressBar.progress = fProgress;
}

- (void)hideProgressBar {
    self.viewDownloadProgress.hidden = YES;
}

- (IBAction)onBook:(id)sender {
    UIButton* btnBook = (UIButton*) sender;
    int nBookNum = btnBook.tag - 1250;
    int offlineMode = [[VPurchaseInfo sharedInfo] isOfflineMode:nBookNum];
//    NSInteger isPurchased = [[VPurchaseInfo sharedInfo].purchased[nBookNum] integerValue];
//    if([[VPurchaseInfo sharedInfo].purchased[0] integerValue] == 1){
//        isPurchased = 1;
//    }
//    if(isPurchased == 0){
//        [self purchaseBook];
//    } else {
        if(offlineMode == 0) {
            [self downloadAudioFiles:nBookNum];
        }else {
            [self deleteAudioFiles:nBookNum];
        }
//    }
}

- (void) showSpaceDialog{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:[[VAppInfo sharedInfo] localizedStringForKey:@"no_enough_space"] preferredStyle:UIAlertControllerStyleAlert];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void) purchaseBook{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:[[VAppInfo sharedInfo] localizedStringForKey:@"purchase_offline_mode"] preferredStyle:UIAlertControllerStyleAlert];
    [actionSheet addAction:[UIAlertAction actionWithTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"rate_app_03"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"rate_app_02"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
        [self dismissViewControllerAnimated:YES completion:nil];
        VPurchaseViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VPurchaseViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void) downloadAudioFiles:(int) nBookNum {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:[[VAppInfo sharedInfo] localizedStringForKey:@"download_audio_file"] preferredStyle:UIAlertControllerStyleAlert];
    [actionSheet addAction:[UIAlertAction actionWithTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"rate_app_03"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"rate_app_02"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
        [self dismissViewControllerAnimated:YES completion:nil];
        VReachability *networkReachability = [VReachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[[VAppInfo sharedInfo] localizedStringForKey:@"error_audio_download"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        VDownloadManager* manager = [VDownloadManager sharedInstance];
        long totalSpace = [self getFreeDiskspace];
        long needSpace = 0;
        BOOL bExisted = NO;
        for (int i = 0; i < manager.downloadBookArray.count; i ++) {
            int nNum = [manager.downloadBookArray[i] integerValue];
            if (nNum == nBookNum){
                bExisted = YES;
                break;
            }
        }
        if (bExisted) {
            needSpace = 300 * (manager.downloadBookArray.count + 1);
        } else {
            needSpace = 300 * (manager.downloadBookArray.count);
        }
        if (totalSpace > needSpace) {
            if (!bExisted) {
                [manager.downloadBookArray addObject:@(nBookNum)];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [manager startDownload];
            });
            
        } else {
            [self showSpaceDialog];
        }
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(uint64_t)getFreeDiskspace {
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return ((totalFreeSpace/1024ll)/1024ll);
}

- (void) deleteAudioFiles:(int)nBookNum {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:[[VAppInfo sharedInfo] localizedStringForKey:@"delete_audio_file"] preferredStyle:UIAlertControllerStyleAlert];
    [actionSheet addAction:[UIAlertAction actionWithTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"rate_app_03"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"rate_app_02"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
        [self dismissViewControllerAnimated:YES completion:nil];
        NSMutableArray* arrayAudioItems = [VAudioFileItem getBookAudioFiles:nBookNum];
        for (int i = 0; i < arrayAudioItems.count; i ++) {
            VAudioFileItem* item = arrayAudioItems[i];
            [self deleteFile:item];
        }
        [[VPurchaseInfo sharedInfo] setUpdateOffline:nBookNum on:0];
        [self updateUI];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void) deleteFile:(VAudioFileItem*)item {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString* strFileName = [item getDownloadPath];
    BOOL success = [fileManager removeItemAtPath:strFileName error:&error];
    if (success) {
        NSString* strKeyName = [item getKeyString];
        [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:strKeyName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

@end
