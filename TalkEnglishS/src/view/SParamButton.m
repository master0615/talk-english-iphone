//
//  ParamButton.m
//  Puchikan
//
//  Created by Yoo YongHa on 2014. 9. 5..
//  Copyright (c) 2014년 Gen X Hippies Company. All rights reserved.
//

#import "SParamButton.h"

@interface SParamButton ()
{
    void (^_clickBlock)(id sender);
}
@end

@implementation SParamButton

- (void) setTarget:(id)anObject
{
    //[super setTarget: anObject];
}

- (void (^)(id)) clickBlock
{
    return _clickBlock;
}

- (void)setClickBlock:(void (^)(id))clickBlock
{
    _clickBlock = clickBlock;
    [self addTarget:self
             action:@selector(clicked:)
   forControlEvents:UIControlEventTouchUpInside];
}

- (void)clicked: (id) sender
{
    if(sender != self) return;
    if(_clickBlock != nil) {
        _clickBlock(sender);
    }
}

@end
