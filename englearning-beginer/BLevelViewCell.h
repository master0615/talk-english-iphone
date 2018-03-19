//
//  BLevelViewCell.h
//  englearning-kids
//
//  Created by sworld on 8/19/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLevelUI.h"

@interface BLevelViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *brightButton;
@property (nonatomic, strong) BLevelUI* levelUI;
@property (nonatomic, assign) int point;

@end
