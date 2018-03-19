//
//  GAllLessonItem.h
//  English Grammar Book
//
//  Created by Jimmy on 9/22/16.
//  Copyright © 2016 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDb.h"
@interface GAllLessonItem : NSObject
@property (nonatomic, strong) NSString* strCat;
@property (nonatomic, assign) NSInteger nLessonNum;
@property (nonatomic, strong) NSString* mark;
+(GAllLessonItem*) newInstance:(GCursor*) cursor;
@end
