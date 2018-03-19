//
//  LUnderlineLabel.h
//  englistening
//
//  Created by alex on 5/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWordOptionButton : UIButton
@property (nonatomic, assign) CGPoint initCenter;
- (void) drawBackground: (BOOL) willDraw;
@end
