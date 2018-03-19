//
//  BMultipleAudioPlayer.h
//  englearning-kids
//
//  Created by sworld on 8/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BComparingProgressUpdateDelegate <NSObject>

- (void) comparingProgress: (float) progress;
- (void) comparingCompleted;

@end

@interface BAudioComparator : NSObject

@property(nonatomic, strong) id<BComparingProgressUpdateDelegate> delegate;

+ (BAudioComparator*) play: (NSURL*) url1 url2: (NSURL*) url2 delegate: (id<BComparingProgressUpdateDelegate>) delegate;
+ (void) stop: (BAudioComparator*) comparator;

@end
