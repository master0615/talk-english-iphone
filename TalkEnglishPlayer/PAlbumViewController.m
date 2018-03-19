//
//  PAlbumViewController.m
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/6/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PAlbumViewController.h"
#import "PDBManager.h"
#import "PAlbumItem.h"
#import "PAlbumDetailViewController.h"
#import "PSubMainNavigationController.h"
#import "PPurchaseInfo.h"
#import "PDownloadManager.h"
#import "PDownloadProgressControl.h"
#import "PConstants.h"
#import "PTrackItem.h"
#import "PConstant.h"
#import "Reachability.h"

@interface PAlbumViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblAlbum;
@property (nonatomic, strong) NSMutableArray* arrayAlbum;
@end

@implementation PAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tblAlbum.rowHeight = UITableViewAutomaticDimension;
    self.tblAlbum.estimatedRowHeight = 240;
    self.arrayAlbum = [PDBManager loadAlbumList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_DOWNLOAD_ALBUM_START object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_DOWNLOAD_ALBUM_STATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_DOWNLOAD_ALBUM_COMPLETE object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [PAnalytics sendScreenName:@"Albmu Screen"];
}


- (void) recieveNotification:(NSNotification*) notification {
    NSLog(@"%@", [notification name]);
    if ([[notification name] isEqualToString:NOTIFICATION_DOWNLOAD_ALBUM_START]) {
        
    } else if ([[notification name] isEqualToString:NOTIFICATION_DOWNLOAD_ALBUM_STATE]) {
        
    } else if ([[notification name] isEqualToString:NOTIFICATION_DOWNLOAD_ALBUM_COMPLETE]) {
    }
    [self.tblAlbum reloadData];
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

- (void) showNetworkMessage{
    if (self.navigationController.viewControllers[self.navigationController.viewControllers.count - 1] == self) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"Please check your Internet connection. If you need to use the English Listening Player without Internet connection, please purchase the Offline mode."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void) showNetworkMessageWithOffline{
    if (self.navigationController.viewControllers[self.navigationController.viewControllers.count - 1] == self) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"Please check your Internet connection."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (BOOL) isNetworkAvailable {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    }
    return YES;
}

- (IBAction)onDownload:(id)sender {
    if ([self isNetworkAvailable] == NO && [PPurchaseInfo sharedInfo].purchasedOffline == 0) {
        [self showNetworkMessage];
        return;
    }
    if ([self isNetworkAvailable] == NO) {
        [self showNetworkMessageWithOffline];
        return;
    }
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblAlbum];
    NSIndexPath *indexPath = [self.tblAlbum indexPathForRowAtPoint:buttonPosition];
    NSInteger nPos = 0;
    if ([sender tag] == 1254) {
        nPos = 0;
    } else {
        nPos = 1;
    }
    nPos = nPos + indexPath.row * 2;
    PAlbumItem *item = self.arrayAlbum[nPos];
    
    if ([[PDownloadManager sharedInstance] albumStatus:item.nAlbumNumber] == 0) {
        int nCount = [PDownloadManager sharedInstance].downloadAlbumArray.count;
        if ([self getFreeDiskspace] < nCount * 30) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                           message:@"There is no more storage on your device. Please free up space and try again."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [[PDownloadManager sharedInstance].downloadAlbumArray addObject:@(item.nAlbumNumber)];
            [[PDownloadManager sharedInstance] startDownload];
        }
    }
    [self.tblAlbum reloadData];
}

- (IBAction)onDelete:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblAlbum];
    NSIndexPath *indexPath = [self.tblAlbum indexPathForRowAtPoint:buttonPosition];
    NSInteger nPos = 0;
    if ([sender tag] == 1252) {
        nPos = 0;
    } else {
        nPos = 1;
    }
    nPos = nPos + indexPath.row * 2 + 1;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"Do you want to delete all the audio files for this album? You can download it again later."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableArray* arrayAudioFileItem = [PDBManager loadTrackList:nPos nGenderMode:0];
        for (int i = 0; i < arrayAudioFileItem.count; i ++) {
            PTrackItem* item = arrayAudioFileItem[i];
            [self deleteFile:item.strAudioNormal];
            [self deleteFile:item.strAudioSlow];
            [self deleteFile:item.strAudioVerySlow];
        }
        [[PPurchaseInfo sharedInfo] setDownloadAlbum:nPos on:0];
        [self.tblAlbum reloadData];
    }];
    
    
    
    [alert addAction:defaultAction];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) deleteFile:(NSString*)strFileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString* strPath = [PConstant getAudioFilePath:strFileName];
    BOOL success = [fileManager removeItemAtPath:strPath error:&error];
    if (success) {
        [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:strFileName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

- (IBAction)onPlay:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblAlbum];
    NSIndexPath *indexPath = [self.tblAlbum indexPathForRowAtPoint:buttonPosition];
    NSInteger nPos = 0;
    if ([sender tag] == 1257) {
        nPos = 0;
    } else {
        nPos = 1;
    }
    nPos = nPos + indexPath.row * 2;
    PAlbumItem *item = self.arrayAlbum[nPos];
    
    PAlbumDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PAlbumDetailViewController"];
    vc.nAlbumNumber = item.nAlbumNumber;
    PSubMainNavigationController* nav = (PSubMainNavigationController*)self.navigationController;
    nav.vcMain.bBackForAlbum = YES;
    [nav.vcMain showBackButton];
    [self.navigationController pushViewController:vc animated:NO];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayAlbum.count / 2;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self.tblAlbum dequeueReusableCellWithIdentifier:@"album" forIndexPath:indexPath];
    PAlbumItem *itemFirst;
    PAlbumItem *itemSecond;
    NSInteger index = indexPath.row;
    itemFirst = self.arrayAlbum[index * 2];
    itemSecond = self.arrayAlbum[index * 2 + 1];
    UIImageView* imgFirst = [cell viewWithTag:1250];
    UIImageView* imgSecond = [cell viewWithTag:1260];
    UIImageView* imgFirstClose = [cell viewWithTag:1251];
    UIImageView* imgSecondClose = [cell viewWithTag:1261];
    UIButton* btnFirstClose = [cell viewWithTag:1252];
    UIButton* btnSecondClose = [cell viewWithTag:1262];
    
    UILabel* lbFirstAlbumName = [cell viewWithTag:1256];
    UILabel* lbSecondAlbumName = [cell viewWithTag:1266];
    lbFirstAlbumName.text = itemFirst.strAlbumTitle;
    lbSecondAlbumName.text = itemSecond.strAlbumTitle;
    UIView* viewFirstDownload = [cell viewWithTag:1253];
    UIView* viewSecondDownload = [cell viewWithTag:1263];
    UIView* viewFirstPlay = [cell viewWithTag:1255];
    UIView* viewSecondPlay = [cell viewWithTag:1265];
    
//    UIButton* btnFirstPlay = [cell viewWithTag:1257];
//    UIButton* btnSecondPlay = [cell viewWithTag:1267];
    
    UIButton* btnFirstDownload = [cell viewWithTag:1254];
    UIButton* btnSecondDownload = [cell viewWithTag:1264];
    PDownloadProgressControl* progressFirst = [cell viewWithTag:1258];
    PDownloadProgressControl* progressSecond = [cell viewWithTag:1268];
    NSInteger nStatusFirst = [[PDownloadManager sharedInstance] albumStatus:itemFirst.nAlbumNumber] ;
    if (nStatusFirst == 1) {
        imgFirst.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", itemFirst.nAlbumNumber]];
        if ([PPurchaseInfo sharedInfo].purchasedOffline == 1) {
            imgFirstClose.hidden = NO;
            btnFirstClose.hidden = NO;
        } else {
            imgFirstClose.hidden = YES;
            btnFirstClose.hidden = YES;
        }
        viewFirstDownload.hidden = YES;
        viewFirstPlay.hidden = NO;
    } else {
        imgFirst.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", itemFirst.nAlbumNumber]];
        imgFirstClose.hidden = YES;
        btnFirstClose.hidden = YES;
        viewFirstDownload.hidden = NO;
        viewFirstPlay.hidden = YES;
        switch (nStatusFirst) {
            case 0:
                [btnFirstDownload setTitle:@"Download Audio Files" forState:UIControlStateNormal];
                btnFirstDownload.hidden = NO;
                progressFirst.hidden = YES;
                break;
            case 2:
                btnFirstDownload.hidden = YES;
                progressFirst.hidden = NO;
                
                [progressFirst setProgress:[[PDownloadManager sharedInstance] getCurrentProgress]];
                break;
            case 3:
                [btnFirstDownload setTitle:@"Pending..." forState:UIControlStateNormal];
                btnFirstDownload.hidden = NO;
                progressFirst.hidden = YES;
                break;
                
            default:
                break;
        }
    }
    NSInteger nStatusSecond = [[PDownloadManager sharedInstance] albumStatus:itemSecond.nAlbumNumber] ;
    if (nStatusSecond == 1) {
        imgSecond.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", itemSecond.nAlbumNumber]];
        if ([PPurchaseInfo sharedInfo].purchasedOffline == 1) {
            imgSecondClose.hidden = NO;
            btnSecondClose.hidden = NO;
        } else {
            imgSecondClose.hidden = YES;
            btnSecondClose.hidden = YES;
        }
        viewSecondDownload.hidden = YES;
        viewSecondPlay.hidden = NO;
    } else {
        imgSecond.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", itemSecond.nAlbumNumber]];
        imgSecondClose.hidden = YES;
        btnSecondClose.hidden = YES;
        viewSecondDownload.hidden = NO;
        viewSecondPlay.hidden = YES;
        switch (nStatusSecond) {
            case 0:
                [btnSecondDownload setTitle:@"Download Audio Files" forState:UIControlStateNormal];
                btnSecondDownload.hidden = NO;
                progressSecond.hidden = YES;
                break;
            case 2:
                btnSecondDownload.hidden = YES;
                progressSecond.hidden = NO;
                
                [progressSecond setProgress:[[PDownloadManager sharedInstance] getCurrentProgress]];
                break;
            case 3:
                [btnSecondDownload setTitle:@"Pending..." forState:UIControlStateNormal];
                btnSecondDownload.hidden = NO;
                progressSecond.hidden = YES;
                break;
                
            default:
                break;
        }
    }
    return cell;
}

@end
