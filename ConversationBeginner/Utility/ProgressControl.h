//
//  ProgressControl.h
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 18..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchProgressDelegate <NSObject>
- (void)didTouchProgress:(float)progress;
@end


@interface ProgressControl : UIControl

@property (readwrite) float progress;
@property (readwrite) float barHeight;
@property (readwrite, strong) UIColor *bgColor;
@property (readwrite, strong) UIColor *progressColor;
@property (weak) IBOutlet id<TouchProgressDelegate> progressDelegate;

@end
