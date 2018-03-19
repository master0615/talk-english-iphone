//
//  BLevelUI.h
//  englearning-kids
//
//  Created by sworld on 8/20/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLevelUI : NSObject
@property (nonatomic, assign) int level;
@property (nonatomic, strong) NSString* bgImage;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong) NSString* buttonImagePrefix;
@property (atomic, assign) int point;

+ (NSArray*) levels: (NSString*) prefix;
+ (BLevelUI*) level: (int) level prefix: (NSString*) prefix;
@end
