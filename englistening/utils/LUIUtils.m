//
//  LUIUtils.m
//  Puchikan
//
//  Created by Yoo YongHa on 2014. 9. 12..
//  Copyright (c) 2014년 Gen X Hippies Company. All rights reserved.
//

#import "LUIUtils.h"

@implementation LUIUtils

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
