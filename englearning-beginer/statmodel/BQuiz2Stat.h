//
//  Quiz2Stat.h
//  englearning-kids
//
//  Created by sworld on 9/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQuiz2Stat : NSObject

@property (nonatomic, assign) int currentPos;
@property (nonatomic, assign) BOOL busy;
- (id) init;
- (void) next;
@end
