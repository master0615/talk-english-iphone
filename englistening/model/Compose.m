//
//  Compose.m
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "Compose.h"

@implementation Compose

- (id) init: (NSString*) string {
    self = [super init];
    self.isBlank = NO;
    self.string = string;
    self.maxlen = (int) [string length];
    return self;
}
//- (void) setString: (NSString *)compose {
//    int maxlen = 0;
//    maxlen = (int)[_string length];
//    int len = (int)[compose length];
//    int n = maxlen - len;
//    if (n < 0) n = -n;
//    if (maxlen == 0 && n == len) n = 2;
//    NSString* SPACE = @" ";
//    for (int i = 0; i < n/2; i ++) {
//        SPACE = [SPACE stringByAppendingString: @" "];
//    }
//    _string = [NSString stringWithFormat: @"%@%@%@", SPACE, compose, SPACE];
//}

- (NSString*) string {
    if (!self.isBlank) {
        return _string;
    }
    NSString* SPACE = @"";
    NSString* SPACE1 = @"  ";
    int len = (int)[_string length];
    int n = (self.maxlen - len) / 2;
    
    if ([[_string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString: @""]) {
//        SPACE1 = @"   ";
        SPACE = @"";
        for (int i = 0; i < n; i ++) {
            SPACE = [SPACE stringByAppendingString: @" "];
//            SPACE1 = [SPACE1 stringByAppendingString: @" "];
        }
    } else {
        for (int i = 0; i < n; i ++) {
            SPACE = [SPACE stringByAppendingString: @" "];
//            SPACE1 = [SPACE1 stringByAppendingString: @"   "];
        }
    }
    return [NSString stringWithFormat: @"%@%@%@%@", SPACE, _string, SPACE, SPACE];
}
- (NSString*) stringValue {
    return self.string;
}
@end
