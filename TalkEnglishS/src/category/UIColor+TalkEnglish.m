//
//  UIColor+TalkEnglish.m
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 16..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "UIColor+TalkEnglish.h"
#import "SEnv.h"
@implementation UIColor (TalkEnglish)

+ (UIColor *) colorWithHex:(int)hex {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

#if PRODUCT_TYPE == PRODUCT_TYPE_OFFLINE

+ (UIColor *)talkEnglishNavigationBar {
    return [UIColor colorWithHex:0x69a3cc];
}

+ (UIColor *)talkEnglishHeaderBackground {
    return [UIColor colorWithHex:0xdbebf7];
}

+ (UIColor *)talkEnglishTouchBackground {
    return [UIColor colorWithHex:0xcbdbe7];
}

#else

+ (UIColor *)talkEnglishNavigationBar {
    return [UIColor colorWithHex:0x76923c];
}

+ (UIColor *)talkEnglishHeaderBackground {
    return [UIColor colorWithHex:0xd5e2ba];
}

+ (UIColor *)talkEnglishTouchBackground {
    return [UIColor colorWithHex:0xc5d2aa];
}

#endif

@end
