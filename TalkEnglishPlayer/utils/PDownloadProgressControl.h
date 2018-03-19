//
//  ProgressControl.h
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PDownloadProgressControl : UIControl

@property (readwrite) float progress;
@property (readwrite, strong) UIColor *bgColor;
@property (readwrite, strong) UIColor *progressColor;

@end
