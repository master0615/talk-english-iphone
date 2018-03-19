//
//  Database.h
//  EnglishConversation
//
//  Created by SongJiang on 3/16/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDatabase : NSObject

+(BDatabase*)sharedInstance;
- (BOOL)addBookmark:(NSString*)strMain sub:(NSString*)strSub title:(NSString*)strTitle;
- (BOOL)isExistBookMark:(NSString*)strMain sub:(NSString*)strSub title:(NSString*)strTitle;
- (BOOL)removeBookmark:(NSString*)strMain sub:(NSString*)strSub title:(NSString*)strTitle;
- (NSArray*)getBookmark;

- (BOOL)addRecord:(NSString*)strTitle lessonTitle:(NSString*)strLessonTitle time:(NSString*)strTime;
- (BOOL)removeRecord:(NSString*)strTime;
- (NSArray*)getRecords;

@end
