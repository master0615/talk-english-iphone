//
//  GLevelItem.h
//  English Grammar Book
//
//  Created by Jimmy on 9/22/16.
//  Copyright © 2016 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDb.h"
@interface GLevelItem : NSObject
@property (nonatomic, assign) NSInteger nLevel;
@property (nonatomic, strong) NSString* strCategory;
@property (nonatomic, assign) NSInteger nCompleted;
@property (nonatomic, assign) NSInteger nTotal;
+(GLevelItem*) newInstance:(GCursor*) cursor;
- (NSString *) getRankText: (NSInteger) nRank;
- (NSString *) getLevelText;
@end
