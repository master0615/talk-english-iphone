//
//  BMainViewController.m
//  englearning-kids
//
//  Created by sworld on 8/19/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BMainViewController.h"
#import "BHomeViewController.h"
#import "BLevelViewCell.h"
#import "BLevelUI.h"
#import "BScore.h"
#import "SharedPref.h"

@interface BMainViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *levelsCollectionView;

@end

@implementation BMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [SharedPref setBool: NO forKey: @"COMPLETED_10"];
    // Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.levels = [BLevelUI levels: @"land_"];
    } else {
        self.levels = [BLevelUI levels: @""];
    }
    [_levelsCollectionView reloadData];
    for (BLevelUI* levelUI in self.levels) {
        if ((levelUI.level > 0 && levelUI.level+1 == [BHomeViewController singleton].studyingLevel) || levelUI.level == 1) {
            [self scrollToPosition: levelUI.level];
            break;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.levels = [BLevelUI levels: @"land_"];
    } else {
        self.levels = [BLevelUI levels: @""];
    }
    [_levelsCollectionView reloadData];
    for (BLevelUI* levelUI in self.levels) {
        if ((levelUI.level > 0 && levelUI.level+1 == [BHomeViewController singleton].studyingLevel) || levelUI.level == 1) {
            [self scrollToPosition: levelUI.level];
            break;
        }
    }
}
- (void) scrollToPosition: (int) position {
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow: position inSection: 0];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [_levelsCollectionView scrollToItemAtIndexPath: indexPath atScrollPosition: UICollectionViewScrollPositionLeft animated: YES];
    } else {
        [_levelsCollectionView scrollToItemAtIndexPath: indexPath atScrollPosition: UICollectionViewScrollPositionTop animated: YES];
    }
}

- (int) score: (int) level {
    if (level < 1 || level > 9) {
        return 0;
    }
    int point = 0;
    for (int i = 1; i <= 10; i ++) {
        BScore* score = [[BScore alloc] init: [NSString stringWithFormat: @"%02d", (level-1)*10+i]];
        point += [score stars];
    }
    return point;
}
static int anim_count = 0;
- (void) startAnimation: (UIButton*) button {
    button.hidden = NO;
    button.alpha = 0;
    [UIView animateWithDuration: 0.3
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction
     
                     animations:^{
                         button.alpha = 1.0;
                     }
                     completion: ^(BOOL finished) {
                         button.hidden = YES;
                         
                     }];
    
}
- (void) startAnimation0: (UIButton*) button {
    button.hidden = NO;
    button.alpha = 0;
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         button.alpha = 1.0;
                     }
                     completion: ^(BOOL finished) {
                         
                         
                     }];
    [UIView animateWithDuration:0.3
                          delay:0.3
                        options: UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         button.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         anim_count ++;
                         if (anim_count < 10) {
                             [self startAnimation: button];
                         } else {
                             anim_count = 0;
                             button.hidden = YES;
                         }
                     }];
    
}

- (void) setBright:(UIButton*) button {
    anim_count = 0;
    [self startAnimation: button];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 10) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmptyLevelCell" forIndexPath:indexPath];
        return cell;
    } else {
        BLevelUI* levelUI = nil;
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            levelUI = [BLevelUI level: (int)indexPath.row prefix: @"land_"]; //[BLevelUI levels: @"land_"];
        } else {
            levelUI = [BLevelUI level: (int)indexPath.row prefix: @""];
        }
        if (indexPath.row % 2 == 1) {
            BLevelViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LevelViewCell0" forIndexPath:indexPath];
            cell.levelUI = levelUI;//[_levels objectAtIndex: indexPath.row-1];
            cell.point = [self score: (int)indexPath.row];            
            cell.layer.borderWidth = 0;
            if (cell.levelUI.level == [BHomeViewController singleton].studyingLevel && [BHomeViewController singleton].level == [BHomeViewController singleton].studyingLevel && [BHomeViewController singleton].level != 0) {
                NSLog(@"row1:%ld", (long)indexPath.row);
                [BHomeViewController singleton].level = 0;
                [self setBright: cell.brightButton];
            } else {
                cell.brightButton.hidden = YES;
            }
            return cell;
        } else {
            BLevelViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LevelViewCell1" forIndexPath:indexPath];
            cell.levelUI = levelUI;//[_levels objectAtIndex: indexPath.row-1];
            cell.point = [self score: (int)indexPath.row];
            cell.layer.borderWidth = 0;
            if (cell.levelUI.level == [BHomeViewController singleton].studyingLevel && [BHomeViewController singleton].level == [BHomeViewController singleton].studyingLevel && [BHomeViewController singleton].level != 0) {
                NSLog(@"row2:%ld", (long)indexPath.row);
                [BHomeViewController singleton].level = 0;
                [self setBright: cell.brightButton];
            } else {
                cell.brightButton.hidden = YES;
            }
            return cell;
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 11;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        if (indexPath.row == 0 || indexPath.row == 10) {
            return CGSizeMake(20, _levelsCollectionView.frame.size.height);
        } else {
            CGFloat height = _levelsCollectionView.frame.size.height;
            CGFloat width = height * 512.0 / 1002.0;
            return CGSizeMake(round(width), height);
        }
    } else {
        if (indexPath.row == 0 || indexPath.row == 10) {
            return CGSizeMake(_levelsCollectionView.frame.size.width, 20);
        } else {
            CGFloat width = _levelsCollectionView.frame.size.width;
            CGFloat height = width * 514.0 / 1080.0;
            return CGSizeMake(width, round(height));
        }
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

@end
