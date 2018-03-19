//
//  LUIUtils.h
//  Puchikan
//
//  Created by Yoo YongHa on 2014. 9. 12..
//  Copyright (c) 2014년 Gen X Hippies Company. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r, g, b) [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha: a]

@interface LUIUtils : NSObject

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
