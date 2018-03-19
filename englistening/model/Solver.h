//
//  Solver.h
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Compose.h"

@interface Solver : NSObject
@property (nonatomic, strong) NSString* sentence;
@property (nonatomic, strong) NSArray* completed;
@property (nonatomic, strong) NSMutableArray* composed;
@property (nonatomic, strong) NSArray* choices;
@property (nonatomic, strong) NSArray* posOfBlanks;


- (id) init: (NSString*) sentence posOfBlanks: (NSString*) posOfBlanks choices: (NSString*) choices;
- (id) init: (NSString*) sentence;
+ (NSArray*) extractWordsOnly: (NSString*) string;

- (BOOL) canCheck;
- (BOOL) checkAnswer;
- (NSString*) stringValue;
@end
