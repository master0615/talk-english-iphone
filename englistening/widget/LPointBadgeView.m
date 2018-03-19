//
//  LPointBadgeView.m
//  englistening
//
//  Created by alex on 5/24/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LPointBadgeView.h"
#import "CoreText/CTLine.h"

@implementation LPointBadgeView
{
    NSString* point;
}
- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self baseInit];
    }
    return self;
}

-(void)baseInit
{
    point = @"";
}
- (void) setPoint: (NSString*) point0 {
    point = point0;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIImage* img = [UIImage imageNamed: @"ic_point_bg"];
    [img drawInRect:rect];
    
    CGContextSaveGState(context);
    
    CGRect viewBounds = self.bounds;
    CGContextTranslateCTM(context, 0, viewBounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    UIFont* aFont = [UIFont boldSystemFontOfSize: rect.size.width/16.0*5.0];
//    UIFont* aFont = [UIFont fontWithName: @"Helvetica" size: 12];
    UIColor* aColor = [UIColor whiteColor];
    
    const void * keys[2] = {NSFontAttributeName, NSForegroundColorAttributeName};
    const void * values[2] = {(__bridge const void *)(aFont), (__bridge const void *)aColor};
    CFDictionaryRef attr = CFDictionaryCreate(NULL, keys, values, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    NSString* string = point;
    CFAttributedStringRef text = CFAttributedStringCreate(NULL, (CFStringRef)string, attr);
    CTLineRef line = CTLineCreateWithAttributedString(text);
    CGRect bounds = CTLineGetBoundsWithOptions(line, kCTLineBoundsUseOpticalBounds);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetCharacterSpacing(context, 0);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetTextPosition(context, CGRectGetMidX(rect)-bounds.size.width/2, rect.size.height/4*3 - bounds.size.height/2 + 1);
    CTLineDraw(line, context);
    CFRelease(line);
    CFRelease(text);
    CFRelease(attr);
    CGContextRestoreGState(context);
}
@end
