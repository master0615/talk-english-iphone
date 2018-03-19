//
//  LDatabase.m
//  EnglishConversation
//
//  Created by SongJiang on 3/16/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "LDatabase.h"
#import "LSQLiteManager.h"

#define DBName          @"english.db"
@interface LDatabase ()
@property (strong, nonatomic) LSQLiteManager *dbManager;
@end


@implementation LDatabase


+(LDatabase*)sharedInstance{
    static LDatabase* db = nil;
    if (db == nil) {
        db = [[LDatabase alloc] init];
    }
    return db;
}
- (instancetype)init{
    self = [super init];
    [self openDB];
    return self;
}

- (NSString*)databasePath {
    // Get the documents directory
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    NSString* path = [docsDir stringByAppendingPathComponent:DBName];
    return path;
}

#pragma mark - database

- (void)openDB {
    NSString* dbPath = [self databasePath];
    
    if (dbPath) {
        self.dbManager = [[LSQLiteManager alloc] initWithDatabaseNamed:dbPath];
    }
    if (self.dbManager) {
        [self.dbManager openDatabase];
    }
    
}

- (void)closeDB {
    if (self.dbManager)
        [self.dbManager closeDatabase];
}
//sql_stmt = "CREATE TABLE IF NOT EXISTS RECORD (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT, LESSON TEXT, TIME TEXT, FILE TEXT)";
- (BOOL)addRecord:(NSString*)strTitle lessonTitle:(NSString*)strLessonTitle time:(NSString*)strTime{
    NSString *sqlStr = [NSString stringWithFormat:@"insert into RECORD(TITLE,LESSON,TIME) values('%@','%@','%@')", strTitle, strLessonTitle, strTime];
    NSError *error = [self.dbManager doQuery:sqlStr];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
        return NO;
    }
    return YES;
}

- (BOOL)removeRecord:(NSString*)strTime{
    NSString *sqlStr = [NSString stringWithFormat:@"delete from RECORD where TIME='%@'", strTime];
    NSError *error = [self.dbManager doQuery:sqlStr];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
        return NO;
    }
    return YES;
}

- (NSArray*)getRecords{
    NSString *sqlStr = [NSString stringWithFormat:@"select * from RECORD order by ID desc"];
    NSArray* results = [self.dbManager getRowsForQuery:sqlStr];
    
    return results;
}

- (BOOL)addBookmark:(NSString*)strMain sub:(NSString*)strSub title:(NSString*)strTitle{
    NSString *sqlStr = [NSString stringWithFormat:@"insert into BOOKMARK(MAIN,SUB,TITLE) values('%@','%@','%@')", strMain, strSub, strTitle];
    NSError *error = [self.dbManager doQuery:sqlStr];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
        return NO;
    }
    return YES;
}

- (BOOL)isExistBookMark:(NSString*)strMain sub:(NSString*)strSub title:(NSString*)strTitle{
    NSString *sqlStr = [NSString stringWithFormat:@"select count(*) from BOOKMARK where MAIN='%@' and SUB='%@' and TITLE='%@'", strMain, strSub, strTitle];
    NSArray* results = [self.dbManager getRowsForQuery:sqlStr];
    
    NSInteger nResult = 0;
    if (results.count > 0)
    {
        NSDictionary* item = results[0];
        nResult = [[item valueForKey:@"count(*)"] integerValue];
    }
    return nResult > 0 ? YES : NO;
}

- (NSArray*)getBookmark{
    NSString *sqlStr = [NSString stringWithFormat:@"select * from BOOKMARK order by ID desc"];
    NSArray* results = [self.dbManager getRowsForQuery:sqlStr];
    
    return results;
}

- (BOOL)removeBookmark:(NSString*)strMain sub:(NSString*)strSub title:(NSString*)strTitle{
    NSString *sqlStr = [NSString stringWithFormat:@"delete from BOOKMARK where MAIN='%@' and SUB='%@' and TITLE='%@'", strMain, strSub, strTitle];
    NSError *error = [self.dbManager doQuery:sqlStr];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
        return NO;
    }
    return YES;
}


@end
