//
//  BLevelViewCellNew.h
//  englearning-kids
//
//  Created by ExpDev on 10/13/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLevelUI.h"

@interface BLevelViewCellNew : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton   *actionButton;
@property (weak, nonatomic) IBOutlet UIView     *activeMark;
@property (weak, nonatomic) IBOutlet UIView     *lockOverlay;
@property (weak, nonatomic) IBOutlet UIImageView *passIcon;
@property (weak, nonatomic) IBOutlet UIImageView *levelIcon;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelTitle;

@property (nonatomic, strong) BLevelUI* levelUI;
@property (nonatomic, assign) int point;

@end
