//
//  Solver.m
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BSentence.h"

@interface BSentence()

@end

@implementation BSentence

static const NSString* REGULAR_CHARS = @"_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'";
static const NSString* BLANK = @"__________";
static const NSString* SPACE = @"          ";
+ (NSString*) space {
    return (NSString*)SPACE;
}
- (id) init: (NSString*) raw {
    self = [super init];
    _items = [[NSMutableArray alloc] init];
    _raw = [raw stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSArray* tokens = [[_raw stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @" "];
    for (NSString* token in tokens) {
        NSArray* subItems = [BSentence extractWordsAndSpecs: token];
        [_items addObjectsFromArray: subItems];
    }
    for (int i = 0; i < [_items count]; i ++) {
        NSString* item = ((BQuizToken*)[_items objectAtIndex: i]).string;
        if ([BLANK isEqualToString: item]) {
            _posOfBlank = i;
            break;
        }
    }
    return self;
}

+ (NSArray*) extractWordsAndSpecs: (NSString*) string {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    
    if ([string containsString: (NSString*)BLANK] && [string length] == [BLANK length]) {
        [list addObject: [[BQuizToken alloc] initWithString: string]];
        return list;
    } else if (![string containsString: (NSString*)BLANK]) {
        [list addObject: [[BQuizToken alloc] initWithString: string]];
        return list;
    }
    NSRange range = [string rangeOfString: (NSString*)BLANK];
    NSString* string1 = [string substringWithRange: NSMakeRange(0, range.location)];
    NSString* string2 = [string substringWithRange: range];
    NSString* string3 = [string substringWithRange: NSMakeRange(range.location+range.length, [string length]-range.location-range.length)];
    if (![string1 isEqualToString: @""]) {
        BQuizToken* token = [[BQuizToken alloc] initWithString: string1];
        token.spaceRight = NO;
        [list addObject: token];
    }
    [list addObject: [[BQuizToken alloc] initWithString: string2]];
    if (![string3 isEqualToString: @""]) {
        BQuizToken* token = [[BQuizToken alloc] initWithString: string3];
        token.spaceLeft = NO;
        [list addObject: token];
    }
    return list;
}

- (NSString*) stringValue {
    return _raw;
}
@end

@implementation BQuizToken

- (id) initWithString: (NSString*) string {
    self = [super init];
    _string = string;
    _spaceLeft = YES;
    _spaceRight = YES;
    return self;
}

@end
