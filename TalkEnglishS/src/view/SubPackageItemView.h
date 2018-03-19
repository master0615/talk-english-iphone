//
//  PackageItemView.h
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 16..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubPackage.h"

@interface SubPackageItemView : UIControl

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *disclosureView;

@property SubPackage *subPackage;
@property NSInteger section;

@end
