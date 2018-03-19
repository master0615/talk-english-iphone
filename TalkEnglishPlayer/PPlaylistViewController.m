//
//  PPlaylistViewController.m
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/7/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PPlaylistViewController.h"
#import "PPlayListDataItem.h"
#import "PProgressControl.h"
#import "PDBManager.h"
#import "PMyPlaylistsViewController.h"
#import "PDBManager.h"
#import "PAudioPlayer.h"
#import "PMBProgressHUD.h"
#import "Reachability.h"
#import "PPurchaseInfo.h"
#import "PTrackDetailViewController.h"
#import "PEnv.h"

@interface PPlaylistViewController () <UITableViewDelegate, UITableViewDataSource>{
    NSInteger _trackNumber;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgTrack;
@property (weak, nonatomic) IBOutlet UILabel *lbTrackTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbCurrentTime;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlay;
@property (weak, nonatomic) IBOutlet UIImageView *imgPrev;
@property (weak, nonatomic) IBOutlet UIImageView *imgNext;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlayType;
@property (weak, nonatomic) IBOutlet UIImageView *imgShuffle;
@property (weak, nonatomic) IBOutlet PProgressControl *audioProgress;
@property (weak, nonatomic) IBOutlet UIImageView *imgSelectAll;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tblPlaylist;
@property (weak, nonatomic) IBOutlet UIView *viewNoTracks;
@property (nonatomic, strong) NSMutableArray* mPlayListDataItemList;

@property (nonatomic, strong) NSMutableArray* mArrayChecked;
@property (nonatomic, assign) BOOL bSelectAll;
@property (nonatomic, assign) BOOL bEditable;
@property (nonatomic, strong) PMBProgressHUD *hud;


@end

@implementation PPlaylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem* leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    self.navigationItem.leftBarButtonItem = leftButton;
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(onPlus)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.title = self.strListName;
    
    self.mArrayChecked = [[NSMutableArray alloc] init];
    
    UILongPressGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0;
    [self.tblPlaylist addGestureRecognizer:lpgr];
    
    [self loadData];
    [self updateUI];
    
    self.topConstraint.constant = 0;
    if (self.mPlayListDataItemList.count > 0) {
        self.viewNoTracks.hidden = YES;
    } else {
        self.viewNoTracks.hidden = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_DOWNLOAD_START object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_DOWNLOAD_PROGRESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_DOWNLOAD_DONE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_DOWNLOAD_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_PLAY_AUDIO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_STOP_AUDIO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_PAUSE_AUDIO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_RESUME_AUDIO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_SEEK_AUDIO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_CHANGE_PLAY_MODE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_CHANGE_SHUFFLE_MODE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_BECOME_ACTIVATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_NO_NETWORK object:nil];
    
    [self updateAudioProgress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [PAnalytics sendScreenName:@"Playlist Screen"];
    if ([[PAudioPlayer sharedInfo].audioPlayer isPlaying] == YES ) {
        self.imgPlay.image = [UIImage imageNamed:@"pause_round"];
    } else {
        self.imgPlay.image = [UIImage imageNamed:@"play_round"];
    }
    self.lbTrackTitle.text = [NSString stringWithFormat:@"%@ - %@", [PAudioPlayer sharedInfo].mStrTrackName, [PAudioPlayer sharedInfo].mStrAlbumName];
    self.imgTrack.image = [UIImage imageNamed:[PAudioPlayer sharedInfo].mStrTrackImage];
    if ([PAudioPlayer sharedInfo].nRepeatMode == 0) {
        self.imgPlayType.image = [UIImage imageNamed:@"media_norepeat"];
    } else if([PAudioPlayer sharedInfo].nRepeatMode == 1) {
        self.imgPlayType.image = [UIImage imageNamed:@"media_repeatsingle"];
    } else if([PAudioPlayer sharedInfo].nRepeatMode == 2) {
        self.imgPlayType.image = [UIImage imageNamed:@"media_repeatall"];
    }
    if ([PAudioPlayer sharedInfo].nSuffleMode == 0) {
        self.imgShuffle.image = [UIImage imageNamed:@"shuffle_inactive"];
    } else {
        self.imgShuffle.image = [UIImage imageNamed:@"shuffle_active"];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onTapTrackImage:(id)sender {
    PTrackDetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PTrackDetailViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) recieveNotification:(NSNotification*) notification {
    NSLog(@"%@", [notification name]);
    if ([[notification name] isEqualToString:NOTIFICATION_DOWNLOAD_START]) {
        self.hud = [PMBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Set the determinate mode to show task progress.
        self.hud.mode = MBProgressHUDModeDeterminate;
        self.hud.label.text = @"The audio file is still downloading. Please wait a couple of more minutes.";
    } else if ([[notification name] isEqualToString:NOTIFICATION_DOWNLOAD_DONE]) {
        [self.hud hideAnimated:YES];
    } else if([[notification name] isEqualToString:NOTIFICATION_DOWNLOAD_PROGRESS]) {
        self.hud.progress = [PAudioPlayer sharedInfo].downloadProgress;
    } else if([[notification name] isEqualToString:NOTIFICATION_DOWNLOAD_FAILED]) {
        [self.hud hideAnimated:YES];
        if (self.navigationController.viewControllers[self.navigationController.viewControllers.count - 1] == self) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                           message:@"The download failed. Please check your internet connection and try again."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else if ([[notification name] isEqualToString:NOTIFICATION_SEEK_AUDIO]) {
        [self updateAudioProgress];
    } else if([[notification name] isEqualToString:NOTIFICATION_PLAY_AUDIO]) {
        self.imgPlay.image = [UIImage imageNamed:@"pause_round"];
        self.lbTrackTitle.text = [NSString stringWithFormat:@"%@ - %@", [PAudioPlayer sharedInfo].mStrTrackName, [PAudioPlayer sharedInfo].mStrAlbumName];
        self.imgTrack.image = [UIImage imageNamed:[PAudioPlayer sharedInfo].mStrTrackImage];
    } else if([[notification name] isEqualToString:NOTIFICATION_RESUME_AUDIO]) {
        self.imgPlay.image = [UIImage imageNamed:@"pause_round"];
        self.lbTrackTitle.text = [NSString stringWithFormat:@"%@ - %@", [PAudioPlayer sharedInfo].mStrTrackName, [PAudioPlayer sharedInfo].mStrAlbumName];
        self.imgTrack.image = [UIImage imageNamed:[PAudioPlayer sharedInfo].mStrTrackImage];
    } else if([[notification name] isEqualToString:NOTIFICATION_PAUSE_AUDIO]) {
        self.imgPlay.image = [UIImage imageNamed:@"play_round"];
        self.lbTrackTitle.text = [NSString stringWithFormat:@"%@ - %@", [PAudioPlayer sharedInfo].mStrTrackName, [PAudioPlayer sharedInfo].mStrAlbumName];
        self.imgTrack.image = [UIImage imageNamed:[PAudioPlayer sharedInfo].mStrTrackImage];
    } else if([[notification name] isEqualToString:NOTIFICATION_CHANGE_PLAY_MODE]){
        if ([PAudioPlayer sharedInfo].nRepeatMode == 0) {
            self.imgPlayType.image = [UIImage imageNamed:@"media_norepeat"];
        } else if([PAudioPlayer sharedInfo].nRepeatMode == 1) {
            self.imgPlayType.image = [UIImage imageNamed:@"media_repeatsingle"];
        } else if([PAudioPlayer sharedInfo].nRepeatMode == 2) {
            self.imgPlayType.image = [UIImage imageNamed:@"media_repeatall"];
        }
    } else if([[notification name] isEqualToString:NOTIFICATION_CHANGE_SHUFFLE_MODE]) {
        if ([PAudioPlayer sharedInfo].nSuffleMode == 0) {
            self.imgShuffle.image = [UIImage imageNamed:@"shuffle_inactive"];
        } else {
            self.imgShuffle.image = [UIImage imageNamed:@"shuffle_active"];
        }
    } else if([[notification name] isEqualToString:NOTIFICATION_BECOME_ACTIVATE]) {
        if ([[PAudioPlayer sharedInfo].audioPlayer isPlaying] == YES ) {
            self.imgPlay.image = [UIImage imageNamed:@"pause_round"];
        } else {
            self.imgPlay.image = [UIImage imageNamed:@"play_round"];
        }
        self.lbTrackTitle.text = [NSString stringWithFormat:@"%@ - %@", [PAudioPlayer sharedInfo].mStrTrackName, [PAudioPlayer sharedInfo].mStrAlbumName];
        self.imgTrack.image = [UIImage imageNamed:[PAudioPlayer sharedInfo].mStrTrackImage];
        if ([PAudioPlayer sharedInfo].nRepeatMode == 0) {
            self.imgPlayType.image = [UIImage imageNamed:@"media_norepeat"];
        } else if([PAudioPlayer sharedInfo].nRepeatMode == 1) {
            self.imgPlayType.image = [UIImage imageNamed:@"media_repeatsingle"];
        } else if([PAudioPlayer sharedInfo].nRepeatMode == 2) {
            self.imgPlayType.image = [UIImage imageNamed:@"media_repeatall"];
        }
        if ([PAudioPlayer sharedInfo].nSuffleMode == 0) {
            self.imgShuffle.image = [UIImage imageNamed:@"shuffle_inactive"];
        } else {
            self.imgShuffle.image = [UIImage imageNamed:@"shuffle_active"];
        }
    } else if([[notification name] isEqualToString:NOTIFICATION_NO_NETWORK]) {
        [self showNetworkMessage];
    }
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

- (void)updateAudioProgress {
    if([PAudioPlayer sharedInfo].audioPlayer == nil) {
        [self.audioProgress setProgress:0];
    }
    else {
        
        NSTimeInterval duration = [PAudioPlayer sharedInfo].audioPlayer.duration;
        NSTimeInterval current = [PAudioPlayer sharedInfo].audioPlayer.currentTime;
        self.lbCurrentTime.text = [PConstant getDurationString:current];
        self.lbTotalTime.text = [PConstant getDurationString:duration];
        float progress;
        if(duration == 0) progress = 0;
        else {
            progress = MAX(0, MIN(1, (float)current / (float)duration));
        }
        [self.audioProgress setProgress:progress];
    }
}

- (void) handleLongPress:(UILongPressGestureRecognizer*) gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self.tblPlaylist];
    NSIndexPath* indexPath = [self.tblPlaylist indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long press on table view at row %ld", indexPath.row);
        self.bEditable = YES;
        [self.tblPlaylist reloadData];
        [self updateUI];
    } else {
        NSLog(@"gestureRecognizer.state = %ld", gestureRecognizer.state);
    }
}

- (void) updateUI {
    if (self.bEditable) {
        self.topConstraint.constant = 36;
    } else {
        self.topConstraint.constant = 0;
    }
}

- (void) loadData {
    self.mPlayListDataItemList = [PDBManager getPlayListData:self.nPlayListNum];
    [self.mArrayChecked removeAllObjects];
    for (int i = 0 ; i < self.mPlayListDataItemList.count; i ++) {
        [self.mArrayChecked addObject:@(NO)];
    }
    [self.tblPlaylist reloadData];
}

- (void) onBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) onPlus{
    NSDictionary* userInfo = @{@"name": @(self.nPlayListNum)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddTrackForPlaylist" object:self userInfo:userInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSelectAll:(id)sender {
    if (self.bSelectAll == NO) {
        for (int i = 0 ; i < self.mPlayListDataItemList.count; i ++) {
            self.mArrayChecked[i] = @(YES);
        }
        self.imgSelectAll.image = [UIImage imageNamed:@"checked"];
        self.bSelectAll = YES;
        [self.tblPlaylist reloadData];
    } else {
        for (int i = 0 ; i < self.mPlayListDataItemList.count; i ++) {
            self.mArrayChecked[i] = @(NO);
        }
        self.imgSelectAll.image = [UIImage imageNamed:@"unchecked"];
        self.bSelectAll = NO;
        [self.tblPlaylist reloadData];
    }
}
- (IBAction)onAdd:(id)sender {
    NSMutableArray* list = [self getSelectedTrackItem];
    PMyPlaylistsViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PMyPlaylistsViewController"];
    vc.bNeedAdd = YES;
    vc.playNewList = list;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)onTrash:(id)sender {
    NSMutableArray* list = [self getSelectedTrackItem];
    if (list.count > 0) {
        [PDBManager deletePlayListItems:list];
        [self loadData];
    }
}

- (IBAction)onSelectCell:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblPlaylist];
    NSIndexPath *indexPath = [self.tblPlaylist indexPathForRowAtPoint:buttonPosition];
    if (self.bEditable == NO) {
        _trackNumber = indexPath.row;
        [[PAudioPlayer sharedInfo] pauseAudio:YES];
        [PAudioPlayer sharedInfo].nConversationMode = 2;
        [PAudioPlayer sharedInfo].playingList = self.mPlayListDataItemList;
        [[PAudioPlayer sharedInfo] selectTrack:indexPath.row isPlaying:YES];
        PTrackDetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PTrackDetailViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        PPlayListDataItem* item = self.mPlayListDataItemList[indexPath.row];
        [PAnalytics sendEvent:@"Select Track" label:item.strTrackName];
        
    } else {
        if ([self.mArrayChecked[indexPath.row] boolValue] == YES) {
            self.mArrayChecked[indexPath.row] = @(NO);
        } else {
            self.mArrayChecked[indexPath.row] = @(YES);
        }
        [self.tblPlaylist reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}


- (NSMutableArray*) getSelectedTrackItem {
    NSString* strShowMode = @"";
    NSMutableArray* list = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.mArrayChecked.count; i++) {
        NSLog(@"%d %d", self.mArrayChecked.count, i);
        if ([self.mArrayChecked[i] boolValue] == YES) {
            PPlayListDataItem* itemData = self.mPlayListDataItemList[i];
            [list addObject:itemData];
        }
    }
    return list;
}



- (IBAction)onPlay:(id)sender {
    if ([[PAudioPlayer sharedInfo] isPlaying]) {
        [[PAudioPlayer sharedInfo] pauseAudio:YES];
    } else {
        if ([self isNetworkAvailable] == NO && [PPurchaseInfo sharedInfo].purchasedOffline == 0) {
            [self showNetworkMessage];
            return;
        }
        [[PAudioPlayer sharedInfo] resumeAudio];
    }
    [PAnalytics sendEvent:@"Play" label:@""];
}

- (void)didTouchProgress:(float)progress {
    [[PAudioPlayer sharedInfo] seekAudio:progress];
}

- (IBAction)onPrev:(id)sender {
    if ([self isNetworkAvailable] == NO && [PPurchaseInfo sharedInfo].purchasedOffline == 0) {
        [self showNetworkMessage];
        return;
    }
    [[PAudioPlayer sharedInfo] previous];
    [PAnalytics sendEvent:@"Previous" label:@""];
}
- (IBAction)onNext:(id)sender {
    if ([self isNetworkAvailable] == NO && [PPurchaseInfo sharedInfo].purchasedOffline == 0) {
        [self showNetworkMessage];
        return;
    }
    [[PAudioPlayer sharedInfo] next];
    [PAnalytics sendEvent:@"Next" label:@""];
}
- (IBAction)onRepeatMode:(id)sender {
    [PAudioPlayer sharedInfo].nRepeatMode ++;
    if ([PAudioPlayer sharedInfo].nRepeatMode == 3) {
        [PAudioPlayer sharedInfo].nRepeatMode = 0;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHANGE_PLAY_MODE object:nil];
    [PAnalytics sendEvent:@"RepeatMode" label:@""];
}
- (IBAction)onShuffle:(id)sender {
    
    if ([PAudioPlayer sharedInfo].nSuffleMode == 0) {
        [PAudioPlayer sharedInfo].nSuffleMode = 1;
    } else {
        [PAudioPlayer sharedInfo].nSuffleMode = 0;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHANGE_SHUFFLE_MODE object:nil];
    [PAnalytics sendEvent:@"SuffleMode" label:@""];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mPlayListDataItemList.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}



- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell;
    if (self.bEditable == YES) {
        cell = [self.tblPlaylist dequeueReusableCellWithIdentifier:@"editcell"];
        UIImageView* imgChecked = [cell viewWithTag:1249];
        if ([self.mArrayChecked[indexPath.row] boolValue] == YES) {
            imgChecked.image = [UIImage imageNamed:@"checked"];
        } else {
            imgChecked.image = [UIImage imageNamed:@"unchecked"];
        }
    } else {
        cell = [self.tblPlaylist dequeueReusableCellWithIdentifier:@"cell"];
    }
    UIImageView* img = [cell viewWithTag:1250];
    UILabel* lbTitle = [cell viewWithTag:1251];
    UILabel* lbAlbumName = [cell viewWithTag:1252];
    PPlayListDataItem* item = self.mPlayListDataItemList[indexPath.row];
    lbTitle.text = [NSString stringWithFormat:@"%ld. %@", indexPath.row + 1, item.strTrackName];
    img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", item.strTrackImage]];
    lbAlbumName.text = [NSString stringWithFormat:@"%@ / %@", item.strAlbumName, item.strSlowType];
    return cell;
}


@end
