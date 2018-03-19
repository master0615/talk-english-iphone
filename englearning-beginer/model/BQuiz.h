//
//  BQuiz.h
//  englearning-kids
//
//  Created by sworld on 8/17/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSentence.h"
#import "BBDb.h"

@interface BQuiz : NSObject
@property (nonatomic, assign) int order;
@property (nonatomic, strong) BSentence* sentence;
@property (nonatomic, strong) NSString* answer;
@property (nonatomic, strong) NSString* candidate;
@property (nonatomic, assign) int point;

- (id) init;
- (BOOL) canCheck;
- (BOOL) check;
- (BOOL) isBlank: (int) pos;
- (int) numOfItems;
- (BQuizToken*) itemAt: (int) pos;

+ (BQuiz*) newInstance: (int) session cursor: (BCursor*) cursor;
+ (NSArray*) loadAll: (int) number forSession: (int) session;

@end
