//
//  LUnderlineLabel.h
//  englistening
//
//  Created by alex on 5/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LUnderlineLabel : UILabel
@property (nonatomic, strong) NSString* caption;
- (void) drawUnderline: (BOOL) willDrawUnderline;
@end
