//
//  MainCell.h
//  TalkEnglish
//
//  Created by Xander Addison on 11/22/17.
//  Copyright © 2017 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@end
