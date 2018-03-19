//
//  OfflineModeViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 6/23/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "OfflineModeViewController.h"
#import "UIViewController+SlideMenu.h"
#import "InAppPurchaseController.h"
#import "ECCategoryManager.h"
#import "Analytics.h"
#import "DownloadManager.h"
#import "Reachability.h"

@interface OfflineModeViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewOfflineMode;
@property (weak, nonatomic) IBOutlet UIView *viewPurchaseMode;
@property (weak, nonatomic) IBOutlet UILabel *lbDescOfOfflineMode;
@property (weak, nonatomic) IBOutlet UILabel *lbDownloadButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgOnOffMode;
@property (weak, nonatomic) IBOutlet UIView *viewDownloadProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIView *btnDownload;


@end

@implementation OfflineModeViewController

- (void)successInAppPurchase:(NSNotification*)ntf {
    NSString* productId = [ntf.userInfo objectForKey:IAPHelperProductPurchasedNotification];
    if (productId.length > 0) {
        if ([productId isEqualToString:kIAPItemProductId1499]) {
            [ECCategoryManager sharedInstance].isPurchased |= 1;
            [[NSUserDefaults standardUserDefaults] setValue:@([ECCategoryManager sharedInstance].isPurchased) forKey:@"isPurchased"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return;
//        }else if ([productId isEqualToString:kIAPItemProductId299]) {
//            [ECCategoryManager sharedInstance].isPurchased |= 2;
//            [[NSUserDefaults standardUserDefaults] setValue:@([ECCategoryManager sharedInstance].isPurchased) forKey:@"isPurchased"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
        }else if ([productId isEqualToString:kIAPItemProductId3999]) {
            [ECCategoryManager sharedInstance].isPurchased |= 4;
            [[NSUserDefaults standardUserDefaults] setValue:@([ECCategoryManager sharedInstance].isPurchased) forKey:@"isPurchased"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else if ([productId isEqualToString:kIAPItemProductId_offline]) {
            [ECCategoryManager sharedInstance].isPurchasedOffline = 1;
            [[NSUserDefaults standardUserDefaults] setValue:@([ECCategoryManager sharedInstance].isPurchasedOffline) forKey:@"isPurchasedOffline"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self updateUI];
            [self onDownloadAndDelete:self];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarItem];
    
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(-130,0,180,32)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 160, 32)];
    lb.textAlignment = NSTextAlignmentCenter;
    [iv addSubview:lb];
    lb.text = @"Offline Mode";
    lb.textColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 13, 24)];
    [btn setBackgroundImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [btn addTarget:self
            action:@selector(myAction)
  forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnBig = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 60, 34)];
    [btnBig addTarget:self
               action:@selector(myAction)
     forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:btnBig];
    
    [iv addSubview:lb];
    [iv addSubview:btn];
    self.navigationItem.titleView = iv;
    [self hideProgressBar];
    if([DownloadManager sharedInstance].nStartedDownload == 1) {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            NSLog(@"There IS NO internet connection");
            [self changeButtonTitle:YES];
        } else {
            NSLog(@"There IS internet connection");
            self.viewDownloadProgress.hidden = NO;
            if ([DownloadManager sharedInstance].nTotalCount > 0) {
                float fProgress = (float)((double)[DownloadManager sharedInstance].nDownloadCount / (double)[DownloadManager sharedInstance].nTotalCount);
                [self setProgress:fProgress];
            } else {
                [self setProgress:0];
            }
        }
    }
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUI];
    [DownloadManager sharedInstance].vc = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successInAppPurchase:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [DownloadManager sharedInstance].vc = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductPurchasedNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) myAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) updateUI {
//    if ([ECCategoryManager sharedInstance].isPurchasedOffline == 1){
        self.viewOfflineMode.hidden = NO;
        self.viewPurchaseMode.hidden = YES;
//    } else {
//        self.viewOfflineMode.hidden = YES;
//        self.viewPurchaseMode.hidden = NO;
//    }
    
    if ([ECCategoryManager sharedInstance].isOfflineMode == 1){
        self.lbDescOfOfflineMode.text = @"All the audio files are downloaded on your device. If you need to remove them, you may delete them by pressing the delete button.\n\nYou may download the audio files again later at any time.\n\nOffline Mode will be turned off if you delete the audio files.";
        self.lbDownloadButton.text = @"DELETE ALL AUDIO FILES";
        self.imgOnOffMode.image = [UIImage imageNamed:@"ic_offlinemode_on"];
    } else {
        self.lbDescOfOfflineMode.text = @"You do not have audio files on your device. Please press the button below to download all the audio files.\n\nYou may delete the audio files from your device at any time.\n\nOffline Mode will be turned on after you download the audio files.";
        self.lbDownloadButton.text = @"DOWNLOAD AUDIO FILES";
        self.imgOnOffMode.image = [UIImage imageNamed:@"ic_offlinemode_off"];
    }
}
- (IBAction)onDownloadAndDelete:(id)sender {
    if ([ECCategoryManager sharedInstance].isOfflineMode == 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Files"
                                                        message:@"Are you sure you want to delete all the audio files?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
        [alert show];
    } else {
        if([DownloadManager sharedInstance].nStartedDownload == 0) {
            [DownloadManager sharedInstance].nDownloadCount = 0;
            [[DownloadManager sharedInstance] downloadAll:0];
        }
    }
}

- (void) showProgressBar {
    self.viewDownloadProgress.hidden = NO;
    [self.progressBar setProgress:0.0f];
    self.btnDownload.hidden = YES;
}

- (void) setProgress:(float) fProgress {
    self.viewDownloadProgress.hidden = NO;
    self.btnDownload.hidden = YES;
    self.progressBar.progress = fProgress;
}

- (void) changeButtonTitle:(BOOL) bFailed {
    if (bFailed) {
        [self.lbDownloadButton setText:@"Please check your internet connection."];
    } else {
        [self.lbDownloadButton setText:@"DOWNLOAD AUDIO FILES"];
    }
}

- (void)hideProgressBar {
    self.viewDownloadProgress.hidden = YES;
    self.btnDownload.hidden = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"No" pressed
            //do something?
            break;
        case 1: //"Yes" pressed
            //here you pop the viewController
            //[self.navigationController popViewControllerAnimated:YES];
            [self deleteAll];
            break;
    }
}



- (void) deleteAll {
    for (NSString* strFileName in [DownloadManager sharedInstance].arrayFileNames) {
        [self deleteFile:strFileName];
    }
    [ECCategoryManager sharedInstance].isOfflineMode = 0;
    [[NSUserDefaults standardUserDefaults] setValue:@([ECCategoryManager sharedInstance].isOfflineMode) forKey:@"isOfflineMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateUI];
    return;
}

- (void) deleteFile:(NSString*)strFileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:strFileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:targetPath error:&error];
    if (success) {
        [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:strFileName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

- (IBAction)onPurchase:(id)sender {
    if (![InAppPurchaseController canPurchaseItems]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"You couldn't purchase items in your device."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    NSInteger kPurchaseItemIndex = 2;
    InAppPurchaseController* iap = [InAppPurchaseController sharedController];
    [iap requestProductsAtDoneIndex:kPurchaseItemIndex withCompletionHandler:^(BOOL success, NSArray *products) {
        if (success && products.count > 0) {
            [iap buyProductAtIndex:kPurchaseItemIndex];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Something went wrong to connect iTunes."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }];
}
- (IBAction)onRestore:(id)sender {
//    [ECCategoryManager sharedInstance].isPurchasedOffline = 1;
//    [[NSUserDefaults standardUserDefaults] setValue:@([ECCategoryManager sharedInstance].isPurchasedOffline) forKey:@"isPurchasedOffline"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self updateUI];
    if (![InAppPurchaseController canPurchaseItems]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"You couldn't purchase items in your device."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    InAppPurchaseController* iap = [InAppPurchaseController sharedController];
    [iap restoreCompletedProducts];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
