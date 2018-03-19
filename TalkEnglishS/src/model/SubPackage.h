//
//  SubPackage.h
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 16..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDb.h"

@interface SubPackage : NSObject

@property NSInteger packageGroupId;
@property NSInteger subPackageId;
@property NSString *title;
@property NSInteger lessonCount;
@property NSArray *lessons;

+ (NSArray*)loadListWithPackageGroup:(NSInteger)packageGroupId;
+ (SubPackage*)subPackageWithCursor:(SCursor*)cursor;

@end
