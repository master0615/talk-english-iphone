//
//  ECCategoryManager.h
//  EnglishConversation
//
//  Created by SongJiang on 3/7/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECCategoryManager : NSObject
@property (nonatomic, assign) int isPurchased;
@property (nonatomic, assign) int isPurchasedOffline;
@property (nonatomic, assign) int isOfflineMode;
+ (ECCategoryManager*)sharedInstance;
- (NSArray*) getCategoryArray:(int) mode;
- (NSArray*) getCategoryImageNameArray:(int) mode;
- (NSDictionary*) getLessonDictionary;
- (NSDictionary*) getQuizDictionary;
@end
