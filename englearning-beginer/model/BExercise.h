//
//  Listen.h
//  englearning-kids
//
//  Created by sworld on 8/16/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BStudy.h"

@interface BExercise : BStudy

+ (BExercise*) newInstance: (int) session cursor: (BCursor*) cursor;
+ (NSArray*) loadAll: (int) number forSession: (int) session;

@end
