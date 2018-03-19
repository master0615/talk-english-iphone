//
//  BExerciseStat.h
//  englearning-kids
//
//  Created by sworld on 9/1/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BExerciseStat : NSObject

@property (nonatomic, assign) int currentPos;
@property (nonatomic, assign) int selected;
@property (nonatomic, assign) BOOL busy;
@property (nonatomic, assign) BOOL correct;
@property (nonatomic, assign) BOOL completed;

- (id) init;
- (void) next;

@end
