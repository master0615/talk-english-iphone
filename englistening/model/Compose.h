//
//  Compose.h
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Compose : NSObject {
    
    
}
@property (nonatomic, assign) int maxlen;
@property (nonatomic, strong) NSString* string;
@property (nonatomic, assign) BOOL isBlank;

- (id) init: (NSString*) string;
- (NSString*) stringValue;

@end
