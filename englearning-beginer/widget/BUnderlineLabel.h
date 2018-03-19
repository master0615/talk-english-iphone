//
//  BUnderlineLabel.h
//  englistening
//
//  Created by alex on 5/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BUnderlineLabel : UILabel
@property (nonatomic, strong) NSString* caption;
@property (nonatomic, assign) int status;

+ (int) STATUS_NOTHING;
+ (int) STATUS_NORMAL;
+ (int) STATUS_CORRECT;
+ (int) STATUS_INCORRECT;
+ (int) STATUS_AVAILABLE;

@end
