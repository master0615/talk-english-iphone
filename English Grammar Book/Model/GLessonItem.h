//
//  GLessonItem.h
//  English Grammar Book
//
//  Created by Jimmy on 9/22/16.
//  Copyright © 2016 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GDb.h"

@interface GLessonItem : NSObject

@property (nonatomic, assign) NSInteger nLevel;
@property (nonatomic, assign) NSInteger nLevelOrder;
@property (nonatomic, assign) NSInteger nQuizId;
@property (nonatomic, assign) float fPointX;
@property (nonatomic, strong) NSString* strCat;
@property (nonatomic, strong) NSString* strTitle;
@property (nonatomic, strong) NSString* strLessonText;
@property (nonatomic, assign) float fMark;
@property (nonatomic, assign) NSInteger nBookmark;
@property (nonatomic, assign) float fTotalPoint;
@property (nonatomic, assign) float fQuiz1Point;

+(GLessonItem*) newInstance:(GCursor*) cursor;

@end
