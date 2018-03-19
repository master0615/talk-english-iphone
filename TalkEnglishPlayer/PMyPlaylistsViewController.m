//
//  PMyPlaylistsViewController.m
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/6/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PMyPlaylistsViewController.h"
#import "PPlayListItem.h"
#import "PDBManager.h"
#import "PConstant.h"
#import "PEditPlayListViewController.h"
#import "PSubMainNavigationController.h"
#import "PPlaylistViewController.h"

@interface PMyPlaylistsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblMyPlaylists;
@property (nonatomic, strong) NSMutableArray* mPlayList;

@end

@implementation PMyPlaylistsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILongPressGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0;
    [self.tblMyPlaylists addGestureRecognizer:lpgr];
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

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mPlayList = [PDBManager loadPlayList];
    [self.tblMyPlaylists reloadData];
    [PAnalytics sendScreenName:@"MyPlaylist Screen"];
}
- (void) handleLongPress:(UILongPressGestureRecognizer*) gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self.tblMyPlaylists];
    NSIndexPath* indexPath = [self.tblMyPlaylists indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long press on table view at row %ld", indexPath.row);
        if (indexPath.row != 0) {
            PPlayListItem* item = self.mPlayList[indexPath.row - 1];
            PEditPlayListViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PEditPlayListViewController"];
            vc.vcPlayList = self;
            vc.strPlayListName = item.strListName;
            vc.nPlayListNum = item.nPlaylistNumber;
            vc.isEdit = YES;
            [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
            if (self.bNeedAdd == YES) {
                [self presentViewController:vc animated:YES completion:nil];
            } else {
                PSubMainNavigationController* mainNav = (PSubMainNavigationController*)self.navigationController;
                [mainNav.vcMain presentViewController:vc animated:YES completion:nil];
            }
        }
    } else {
        NSLog(@"gestureRecognizer.state = %ld", gestureRecognizer.state);
    }
}

- (void) createPlayList:(NSString*) strPlayListName {
    [PDBManager createPlayList:strPlayListName];
    self.mPlayList = [PDBManager loadPlayList];
    [self.tblMyPlaylists reloadData];
}

- (void) editPlayList:(NSString*) strOldPlayListName new:(NSString*) strNewPlayListName {
    [PDBManager editPlayList:strOldPlayListName new:strNewPlayListName];
    self.mPlayList = [PDBManager loadPlayList];
    [self.tblMyPlaylists reloadData];
}

- (void) deletePlayList:(NSString*) strPlayListName {
    [PDBManager deletePlaylist:strPlayListName];
    self.mPlayList = [PDBManager loadPlayList];
    [self.tblMyPlaylists reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mPlayList.count + 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath on table view at row %ld", indexPath.row);
    if (indexPath.row == 0) {
        PEditPlayListViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PEditPlayListViewController"];
        vc.vcPlayList = self;
        vc.strPlayListName = [NSString stringWithFormat:@"Playlist%ld", self.mPlayList.count + 1];
        vc.isEdit = NO;
        [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        if (self.bNeedAdd == YES) {
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            PSubMainNavigationController* mainNav = (PSubMainNavigationController*)self.navigationController;
            [mainNav.vcMain presentViewController:vc animated:YES completion:nil];
        }
    } else {
        PPlayListItem* item = self.mPlayList[indexPath.row - 1];
        NSInteger nPlaylistNumber = item.nPlaylistNumber;
        if(self.bNeedAdd == YES) {
            [PDBManager addPlayListData:nPlaylistNumber list:self.playNewList];
            PPlaylistViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PPlaylistViewController"];
            vc.nPlayListNum = nPlaylistNumber;
            vc.strListName = item.strListName;
            NSMutableArray* viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            viewControllers[viewControllers.count - 1] = vc;
            [self.navigationController setViewControllers:viewControllers];
        } else {
            PPlaylistViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PPlaylistViewController"];
            vc.nPlayListNum = nPlaylistNumber;
            vc.strListName = item.strListName;
            PSubMainNavigationController* mainNav = (PSubMainNavigationController*)self.navigationController;
            [mainNav.vcMain.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self.tblMyPlaylists dequeueReusableCellWithIdentifier:@"cell"];
    UIImageView* img = [cell viewWithTag:1250];
    UILabel* lbTitle = [cell viewWithTag:1251];
    UILabel* lbAlbumName = [cell viewWithTag:1252];
    if (indexPath.row == 0) {
        img.image = [UIImage imageNamed:@"add_playlist"];
        lbTitle.text = @"Create playlist";
        lbAlbumName.text = @"";
    } else {
        PPlayListItem* item = self.mPlayList[indexPath.row - 1];
        NSInteger nPlaylistNumber = item.nPlaylistNumber;
        NSMutableArray* items = [PDBManager getPlayListData:nPlaylistNumber];
        NSInteger nTotalTime = [PConstant getTotalSlowTime:items];
        NSString* strTotalTime = [PConstant getDurationString:nTotalTime];
        NSString* strDescription = [NSString stringWithFormat:@"%ld tracks / %@", items.count, strTotalTime];
        if (items.count > 0) {
            PPlayListDataItem* item = items[0];
            NSString* strImageName = [NSString stringWithFormat:@"%@.jpg", item.strTrackImage];
            img.image = [UIImage imageNamed:strImageName];
        } else {
            img.image = [UIImage imageNamed:@"default_playlist"];
        }
        lbTitle.text = item.strListName;
        lbAlbumName.text = strDescription;
    }
    return cell;
}

@end
