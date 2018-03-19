//
//  ProgressControl.h
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchProgressDelegate <NSObject>
- (void)didTouchProgress:(float)progress;
@end


@interface VProgressControl : UIControl

@property (readwrite) float progress;
@property (readwrite) float barHeight;
@property (readwrite, strong) UIColor *bgColor;
@property (readwrite, strong) UIColor *progressColor;
@property (weak) IBOutlet id<TouchProgressDelegate> progressDelegate;

@end
