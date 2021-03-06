//
//  PAlbumDetailViewController.m
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/13/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PAlbumDetailViewController.h"
#import "PDBManager.h"
#import "PTrackItem.h"
#import "PConstant.h"
#import "PAudioPlayer.h"
#import "PMyPlaylistsViewController.h"
#import "PSubMainNavigationController.h"
#import "Reachability.h"
#import "PPurchaseInfo.h"
#import "PEnv.h"
#import "PTrackDetailViewController.h"

@interface PAlbumDetailViewController (){
//    GADInterstitial *_interstitialAd;
    NSInteger _trackNumber;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgAlbum;
@property (weak, nonatomic) IBOutlet UILabel *lbAlbumName;
@property (weak, nonatomic) IBOutlet UILabel *lbConversations;
@property (weak, nonatomic) IBOutlet UILabel *lbNormalTime;
@property (weak, nonatomic) IBOutlet UILabel *lbSlowTime;
@property (weak, nonatomic) IBOutlet UILabel *lbSlowestTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgSelectAll;
@property (weak, nonatomic) IBOutlet UIImageView *imgAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnNormal;
@property (weak, nonatomic) IBOutlet UIButton *btnSlow;
@property (weak, nonatomic) IBOutlet UIButton *btnSlowest;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UITableView *tblTrack;
@property (weak, nonatomic) IBOutlet UITableView *tblMore;
@property (nonatomic, assign) BOOL bNormal;
@property (nonatomic, assign) BOOL bSlow;
@property (nonatomic, assign) BOOL bSlowest;
@property (nonatomic, assign) BOOL bMore;
@property (nonatomic, assign) NSInteger nShowMode;
@property (nonatomic, strong) NSMutableArray* mTrackList;
@property (nonatomic, assign) NSInteger nGenderMode;

@property (nonatomic, strong) NSMutableArray* mArrayChecked;
@property (nonatomic, assign) BOOL bSelectAll;
@property (nonatomic, assign) BOOL bEditable;

@end
@implementation PAlbumDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bEditable = NO;
    self.bNormal = YES;
    self.bSlow = NO;
    self.bSlowest = NO;
    self.btnNormal.selected = YES;
    self.nShowMode = 1;
    self.nGenderMode = 0;
    self.tblMore.hidden = YES;
    self.bMore = NO;
    self.mArrayChecked = [[NSMutableArray alloc] init];
    
    UILongPressGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0;
    [self.tblTrack addGestureRecognizer:lpgr];
    
    // Do any additional setup after loading the view.
    [self updateUI];
    [self loadData];
    
    self.imgAlbum.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", self.nAlbumNumber]];
    PTrackItem* item = self.mTrackList[0];
    self.lbAlbumName.text = item.strAlbumName;
    
    self.lbConversations.text = [NSString stringWithFormat:@"%ld Conversations", self.mTrackList.count];
    self.lbNormalTime.text = [NSString stringWithFormat:@"%@ normal", [PConstant getDurationString:[self getTotalNormalTime]]];
    self.lbSlowTime.text = [NSString stringWithFormat:@"%@ slow", [PConstant getDurationString:[self getTotalSlowTime]]];
    self.lbSlowestTime.text = [NSString stringWithFormat:@"%@ slowest", [PConstant getDurationString:[self getTotalSlowestTime]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backAlbumView:) name:@"BackAlbumView" object:nil];
//    [self loadAd];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [PAnalytics sendScreenName:@"AlbmuDetail Screen"];
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
- (BOOL) isNetworkAvailable {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    }
    return YES;
}

- (void) handleLongPress:(UILongPressGestureRecognizer*) gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self.tblTrack];
    NSIndexPath* indexPath = [self.tblTrack indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long press on table view at row %ld", indexPath.row);
        self.bEditable = YES;
        [self.mArrayChecked removeAllObjects];
        for (int i = 0 ; i < self.mTrackList.count * self.nShowMode; i ++) {
            [self.mArrayChecked addObject:@(NO)];
        }
        PSubMainNavigationController* nav = (PSubMainNavigationController*)self.navigationController;
        nav.vcMain.bAlbumEditable = YES;
        [nav.vcMain showBackButton];
        [self.tblTrack reloadData];
        [self updateUI];
    } else {
        NSLog(@"gestureRecognizer.state = %ld", gestureRecognizer.state);
    }
}

- (void) backAlbumView:(NSNotification*) notification {
    self.bEditable = NO;
    PSubMainNavigationController* nav = (PSubMainNavigationController*)self.navigationController;
    nav.vcMain.bAlbumEditable = NO;
    [self.tblTrack reloadData];
    [self updateUI];
}

- (void) updateUI {
    if (self.bEditable) {
        _imgSelectAll.hidden = NO;
        _imgAdd.hidden = NO;
    } else {
        _imgSelectAll.hidden = YES;
        _imgAdd.hidden = YES;
    }
}

- (NSInteger) getTotalNormalTime{
    NSInteger nTotalTime = 0;
    if (self.mTrackList != nil) {
        for (int i = 0; i < self.mTrackList.count; i ++) {
            PTrackItem* item = self.mTrackList[i];
            nTotalTime += item.mNormalTime;
        }
    }
    return nTotalTime;
}

- (NSInteger) getTotalSlowTime{
    NSInteger nTotalTime = 0;
    if (self.mTrackList != nil) {
        for (int i = 0; i < self.mTrackList.count; i ++) {
            PTrackItem* item = self.mTrackList[i];
            nTotalTime += item.mSlowTime;
        }
    }
    return nTotalTime;
}

- (NSInteger) getTotalSlowestTime{
    NSInteger nTotalTime = 0;
    if (self.mTrackList != nil) {
        for (int i = 0; i < self.mTrackList.count; i ++) {
            PTrackItem* item = self.mTrackList[i];
            nTotalTime += item.mVerySlowTime;
        }
    }
    return nTotalTime;
}

- (void)loadData{
    NSInteger nShowMode = 0;
    if (self.bNormal) { nShowMode ++; }
    if (self.bSlow) { nShowMode ++; }
    if (self.bSlowest) { nShowMode ++; }
    self.nShowMode = nShowMode;
    self.mTrackList = [PDBManager loadTrackList:self.nAlbumNumber nGenderMode:self.nGenderMode];
    [self.mArrayChecked removeAllObjects];
    for (int i = 0 ; i < self.mTrackList.count * self.nShowMode; i ++) {
        [self.mArrayChecked addObject:@(NO)];
    }
    [self.tblTrack reloadData];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)onSelectAll:(id)sender {
    if (self.bSelectAll == NO) {
        for (int i = 0 ; i < self.mTrackList.count * self.nShowMode; i ++) {
            self.mArrayChecked[i] = @(YES);
        }
        self.imgSelectAll.image = [UIImage imageNamed:@"checked"];
        self.bSelectAll = YES;
        [self.tblTrack reloadData];
    } else {
        for (int i = 0 ; i < self.mTrackList.count * self.nShowMode; i ++) {
            self.mArrayChecked[i] = @(NO);
        }
        self.imgSelectAll.image = [UIImage imageNamed:@"unchecked"];
        self.bSelectAll = NO;
        [self.tblTrack reloadData];
    }    
}
- (IBAction)onAdd:(id)sender {
    NSMutableArray* list = [self getSelectedTrackItem];
    PMyPlaylistsViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PMyPlaylistsViewController"];
    vc.bNeedAdd = YES;
    vc.playNewList = list;
    PSubMainNavigationController* nav = (PSubMainNavigationController*)self.navigationController;
    [nav.vcMain.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray*) getSelectedTrackItem {
    NSString* strShowMode = @"";
    NSMutableArray* list = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.mArrayChecked.count; i++) {
        NSLog(@"%d %d", self.mArrayChecked.count, i);
        if ([self.mArrayChecked[i] boolValue] == YES) {
            if (self.nShowMode != 0) {
                int nPos = i / self.nShowMode;
                PTrackItem* trackItem = self.mTrackList[nPos];
                PPlayListDataItem* itemData = [[PPlayListDataItem alloc] init];
                itemData.mAlbumNumber = trackItem.mAlbumNumber;
                itemData.strAlbumName = trackItem.strAlbumName;
                itemData.strTrackName = trackItem.strTrackName;
                itemData.strTrackImage = trackItem.strTrackImage;
                itemData.strDialog = trackItem.strDialog;
                itemData.strAudioSlowType = trackItem.strAudioSlowType;
                itemData.strFirst = trackItem.strFirst;
                itemData.strSecond = trackItem.strSecond;
                itemData.strGender = trackItem.strGender;
                itemData.nPlayListNum = @"";
                
                int nAudioSpeedMode = [self getAudioSpeedMode:i];
                if (nAudioSpeedMode == 0) {
                    strShowMode = @"normal";
                    itemData.mNormalTime = trackItem.mNormalTime;
                    itemData.strAudioNormal = trackItem.strAudioNormal;
                } else if(nAudioSpeedMode == 1) {
                    strShowMode = @"slow";
                    itemData.mNormalTime = trackItem.mNormalTime;
                    itemData.strAudioNormal = trackItem.strAudioSlow;
                } else if(nAudioSpeedMode ==2) {
                    strShowMode = @"slowest";
                    itemData.mNormalTime = trackItem.mNormalTime;
                    itemData.strAudioNormal = trackItem.strAudioVerySlow;
                }
                itemData.strSlowType = strShowMode;
                [list addObject:itemData];
            }
        }
    }
    return list;
}

- (IBAction)onNormal:(id)sender {
    self.bNormal = !self.bNormal;
    self.btnNormal.selected = self.bNormal;
    [self loadData];
}
- (IBAction)onSlow:(id)sender {
    self.bSlow = !self.bSlow;
    self.btnSlow.selected = self.bSlow;
    [self loadData];
}
- (IBAction)onSlowest:(id)sender {
    self.bSlowest = !self.bSlowest;
    self.btnSlowest.selected = self.bSlowest;
    [self loadData];
}
- (IBAction)onMore:(id)sender {
    self.bMore = !self.bMore;
    self.tblMore.hidden = !self.bMore;
    self.btnMore.selected = self.bMore;
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:self.nGenderMode inSection:0];
    [self.tblMore selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self loadData];
}


- (IBAction)onSelectCell:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblTrack];
    NSIndexPath *indexPath = [self.tblTrack indexPathForRowAtPoint:buttonPosition];
    if (self.bEditable == NO) {
        
        PTrackItem* item = self.mTrackList[indexPath.row];
        
        if([PConstant checkExistFile:item.strAudioNormal]){
            _trackNumber = indexPath.row;
            [[PAudioPlayer sharedInfo] pauseAudio:YES];
            [PAudioPlayer sharedInfo].nShowMode = self.nShowMode;
            [PAudioPlayer sharedInfo].bNormal = self.bNormal;
            [PAudioPlayer sharedInfo].bSlow = self.bSlow;
            [PAudioPlayer sharedInfo].bSlowest = self.bSlowest;
            [PAudioPlayer sharedInfo].nConversationMode = 0;
            [PAudioPlayer sharedInfo].playingList = self.mTrackList;
            [[PAudioPlayer sharedInfo] selectTrack:indexPath.row isPlaying:YES];
            PTrackDetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PTrackDetailViewController"];
            PSubMainNavigationController* nav = (PSubMainNavigationController*)self.navigationController;
            [nav.vcMain.navigationController pushViewController:vc animated:YES];
            [PAnalytics sendEvent:@"Select Track" label:item.strTrackName];

        }else{
            if ([self isNetworkAvailable] == NO && [PPurchaseInfo sharedInfo].purchasedOffline == 0) {
                [self showNetworkMessage];
                return;
            }
        }
        
    } else {
        if ([self.mArrayChecked[indexPath.row] boolValue] == YES) {
            self.mArrayChecked[indexPath.row] = @(NO);
        } else {
            self.mArrayChecked[indexPath.row] = @(YES);
        }
        [self.tblTrack reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.tblMore == tableView) {
        return 5;
    }
    return self.mTrackList.count * self.nShowMode;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tblMore == tableView) {
        return 40;
    }
    return 70;
}

- (NSInteger) getAudioSpeedMode:(NSInteger) pos{
    NSInteger nRet = -1;
    if (self.nShowMode != 0) {
        
        NSInteger nPosRemainder = pos % self.nShowMode;
        if (self.bNormal) {
            if (nPosRemainder == 0) {
                nRet = 0;
            } else if (nPosRemainder == 1) {
                if (self.bSlow) {
                    nRet = 1;
                } else if (self.bSlowest) {
                    nRet = 2;
                }
            } else if (nPosRemainder == 2) {
                if (self.bSlow && self.bSlowest) {
                    nRet = 2;
                }
            }
        } else {
            if (self.bSlow) {
                if (nPosRemainder == 0) {
                    nRet = 1;
                } else if (self.bSlowest) {
                    nRet = 2;
                }
            } else {
                if (self.bSlowest) {
                    nRet = 2;
                }
            }
        }
    }
    return nRet;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tblMore == tableView) {
        self.nGenderMode = indexPath.row;
        [self onMore:self];
    } else {
//        [PAudioPlayer sharedInfo].nShowMode = self.nShowMode;
//        [PAudioPlayer sharedInfo].bNormal = self.bNormal;
//        [PAudioPlayer sharedInfo].bSlow = self.bSlow;
//        [PAudioPlayer sharedInfo].bSlowest = self.bSlowest;
//        [PAudioPlayer sharedInfo].nConversationMode = 0;
//        [PAudioPlayer sharedInfo].playingList = self.mTrackList;
//        [[PAudioPlayer sharedInfo] selectTrack:indexPath.row isPlaying:YES];
    }
    
}
- (void) tableView:(UITableView *)tableView didDeSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tblMore == tableView) {
        //        UITableViewCell* cell = [self.tblMore cellForRowAtIndexPath:indexPath];
        //        cell.contentView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:65.0f/255.0f blue:9.0f/255.0f alpha:1.0f];
        //        cell.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:70.0f/255.0f blue:9.0f/255.0f alpha:1.0f];
    }
    
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tblMore == tableView) {
        UITableViewCell* cell = [self.tblMore dequeueReusableCellWithIdentifier:@"cell"];
        UIImageView* img = [cell viewWithTag:1250];
        UILabel* lbTitle = [cell viewWithTag:1251];
        switch (indexPath.row) {
            case 0:
                img.image = [UIImage imageNamed:@"popup_showall"];
                lbTitle.text = @"show all";
                break;
            case 1:
                img.image = [UIImage imageNamed:@"popup_girlgirl"];
                lbTitle.text = @"girl-girl";
                break;
            case 2:
                img.image = [UIImage imageNamed:@"popup_boyboy"];
                lbTitle.text = @"boy-boy";
                break;
            case 3:
                img.image = [UIImage imageNamed:@"popup_boygirl"];
                lbTitle.text = @"boy-girl";
                break;
            case 4:
                img.image = [UIImage imageNamed:@"popup_withkid"];
                lbTitle.text = @"with kid";
                break;
            default:
                break;
        }
        
        UIView* bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:110.0f/255.0f green:80.0f/255.0f blue:19.0f/255.0f alpha:1.0f];
        [cell setSelectedBackgroundView:bgColorView];
        
        
        
        return cell;
    }
    UITableViewCell* cell;
    if (self.bEditable == YES) {
        cell = [self.tblTrack dequeueReusableCellWithIdentifier:@"editcell"];
        UIImageView* imgChecked = [cell viewWithTag:1249];
        if ([self.mArrayChecked[indexPath.row] boolValue] == YES) {
            imgChecked.image = [UIImage imageNamed:@"checked"];
        } else {
            imgChecked.image = [UIImage imageNamed:@"unchecked"];
        }
    } else {
        cell = [self.tblTrack dequeueReusableCellWithIdentifier:@"cell"];
    }
    UIImageView* img = [cell viewWithTag:1250];
    UILabel* lbTitle = [cell viewWithTag:1251];
    UILabel* lbAlbumName = [cell viewWithTag:1252];
    NSInteger nPos = indexPath.row / self.nShowMode;
    PTrackItem* item = self.mTrackList[nPos];
    lbTitle.text = [NSString stringWithFormat:@"%ld. %@", indexPath.row + 1, item.strTrackName];
    img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", item.strTrackImage]];
    
    NSInteger nAudioSpeedMode = [self getAudioSpeedMode:indexPath.row];
    NSString* strMode;
    if (nAudioSpeedMode == 0) {
        strMode = @"normal";
    } else if (nAudioSpeedMode == 1) {
        strMode = @"slow";
    } else  if (nAudioSpeedMode == 2) {
        strMode = @"slowest";
    }
    lbAlbumName.text = [NSString stringWithFormat:@"%@ / %@", item.strAlbumName, strMode];
    
    
    return cell;
}


@end
