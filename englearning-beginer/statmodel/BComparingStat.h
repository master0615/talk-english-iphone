//
//  BComparingStat.h
//  englearning-kids
//
//  Created by sworld on 8/31/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BComparingStat : NSObject

@property (nonatomic, assign) int currentPos;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) float listenProgress;
@property (nonatomic, assign) float compareProgress;
@property (nonatomic, assign) int compareCount;
@property (nonatomic, assign) BOOL completed;

- (id) init;
- (void) initByPos: (int) pos;
- (void) next;
+ (int) STAT_Nothing;
+ (int) STAT_Listening;
+ (int) STAT_Recording;
+ (int) STAT_Recorded;
+ (int) STAT_Comparing;
@end
