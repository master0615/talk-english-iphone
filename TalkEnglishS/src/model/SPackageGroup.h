//
//  SPackageGroup.h
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 16..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDb.h"

@interface SPackageGroup : NSObject


@property NSInteger packageGroupId;
@property NSString *name;

+ (NSArray*)loadList;
+ (SPackageGroup*)packageGroupWithCursor:(SCursor*)cursor;

@end
