//
//  BBookmark.h
//  englearning-kids
//
//  Created by sworld on 9/12/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BLesson.h"

@interface BBookmark : NSObject
@property (nonatomic, strong) BLesson* lesson;
@property (nonatomic, assign) int type;

- (id) init: (BLesson*) lesson type: (int) type;
- (NSString*) string;
- (NSString*) title;
- (UIImage*) typeImage;
- (UIImage*) mainImage;

@end
