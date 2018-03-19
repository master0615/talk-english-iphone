//
//  SearchTrackViewController.m
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/6/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PSearchTrackViewController.h"
#import "PDBManager.h"
#import "PTrackItem.h"
#import "PPlayListDataItem.h"
#import "PAudioPlayer.h"
#import "PMyPlaylistsViewController.h"
#import "PPlaylistViewController.h"
#import "PTrackDetailViewController.h"

@interface PSearchTrackViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgSelectAll;
@property (weak, nonatomic) IBOutlet UIImageView *imgAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnNormal;
@property (weak, nonatomic) IBOutlet UIButton *btnSlow;
@property (weak, nonatomic) IBOutlet UIButton *btnSlowest;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UITableView *tblTrack;
@property (weak, nonatomic) IBOutlet UITableView *tblMore;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
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
@property (nonatomic, strong) NSString* strSearchText;
@end

@implementation PSearchTrackViewController

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
    self.bSelectAll = NO;
    self.mArrayChecked = [[NSMutableArray alloc] init];
    
    UILongPressGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0;
    [self.tblTrack addGestureRecognizer:lpgr];
    
    // Do any additional setup after loading the view.
    [self updateUI];
    self.strSearchText = @"";
    [self loadData:self.strSearchText];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search = %@", searchBar.text);
    self.strSearchText = searchBar.text;
    [self loadData:self.strSearchText];
    [searchBar resignFirstResponder];
}
- (void) handleLongPress:(UILongPressGestureRecognizer*) gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self.tblTrack];
    NSIndexPath* indexPath = [self.tblTrack indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long press on table view at row %ld", indexPath.row);
        self.bEditable = YES;
        [self.tblTrack reloadData];
        [self updateUI];
    } else {
        NSLog(@"gestureRecognizer.state = %ld", gestureRecognizer.state);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) backTrackView:(NSNotification*) notification {
    self.bEditable = NO;
    [self.tblTrack reloadData];
    [self updateUI];
}
- (void) addTrackForPlaylist:(NSNotification*) notification {
    self.bEditable = YES;
    [self.tblTrack reloadData];
    [self updateUI];
}

- (void) updateUI {
    if (self.bEditable) {
        _imgSelectAll.hidden = NO;
        _imgAdd.hidden = NO;
    } else {
        _imgSelectAll.hidden = YES;
        _imgSelectAll.image = [UIImage imageNamed:@"unchecked"];
        _imgAdd.hidden = YES;
    }
}
- (IBAction)onTapGesture:(id)sender {
}

- (void)loadData:(NSString*)strText{
    NSInteger nShowMode = 0;
    if (self.bNormal) { nShowMode ++; }
    if (self.bSlow) { nShowMode ++; }
    if (self.bSlowest) { nShowMode ++; }
    self.nShowMode = nShowMode;
    self.mTrackList = [PDBManager loadTrackList:self.nGenderMode track:strText];
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
    [self.navigationController pushViewController:vc animated:YES];
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
                itemData.nPlayListNum = 0;
                
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
- (IBAction)onNormal:(id)sender {
    self.bNormal = !self.bNormal;
    self.btnNormal.selected = self.bNormal;
    [self loadData:self.strSearchText];
}
- (IBAction)onSlow:(id)sender {
    self.bSlow = !self.bSlow;
    self.btnSlow.selected = self.bSlow;
    [self loadData:self.strSearchText];
}
- (IBAction)onSlowest:(id)sender {
    self.bSlowest = !self.bSlowest;
    self.btnSlowest.selected = self.bSlowest;
    [self loadData:self.strSearchText];
}
- (IBAction)onMore:(id)sender {
    self.bMore = !self.bMore;
    self.tblMore.hidden = !self.bMore;
    self.btnMore.selected = self.bMore;
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:self.nGenderMode inSection:0];
    [self.tblMore selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self loadData:self.strSearchText];
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

- (IBAction)onSelectCell:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblTrack];
    NSIndexPath *indexPath = [self.tblTrack indexPathForRowAtPoint:buttonPosition];
    if (self.bEditable == NO) {
        [PAudioPlayer sharedInfo].nShowMode = self.nShowMode;
        [PAudioPlayer sharedInfo].bNormal = self.bNormal;
        [PAudioPlayer sharedInfo].bSlow = self.bSlow;
        [PAudioPlayer sharedInfo].bSlowest = self.bSlowest;
        [PAudioPlayer sharedInfo].nConversationMode = 0;
        [PAudioPlayer sharedInfo].playingList = self.mTrackList;
        [[PAudioPlayer sharedInfo] selectTrack:indexPath.row isPlaying:YES];
    } else {
        if ([self.mArrayChecked[indexPath.row] boolValue] == YES) {
            self.mArrayChecked[indexPath.row] = @(NO);
        } else {
            self.mArrayChecked[indexPath.row] = @(YES);
        }
        [self.tblTrack reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
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
