//
//  VUIUtils.h
//  Puchikan
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r, g, b) [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha: a]

@interface VUIUtils : NSObject

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
