//
//  Score.h
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Score : NSObject

- (id) init: (NSString*)suffix point1: (NSString*) point1  point2: (NSString*) point2 point3: (NSString*) point3;
- (int) point;
- (int) repeatCount;
- (NSString*) stringValue;
- (BOOL) taken;
- (void) take;
- (void) increaseRepeatCount;
- (void) decreaseRepeatCount;
@end
