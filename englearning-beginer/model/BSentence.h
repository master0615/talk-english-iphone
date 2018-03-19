//
//  Solver.h
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BSentence : NSObject
@property (nonatomic, strong) NSString* raw;
@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, assign) int posOfBlank;

- (id) init: (NSString*) raw;
- (NSString*) stringValue;
+ (NSString*) space;
+ (NSArray*) extractWordsAndSpecs: (NSString*) string;
@end

@interface BQuizToken : NSObject
@property (nonatomic, strong) NSString* string;
@property (nonatomic, assign) BOOL spaceLeft;
@property (nonatomic, assign) BOOL spaceRight;

- (id) initWithString: (NSString*) string;

@end
