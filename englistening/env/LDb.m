//
//  Db.m
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "LDb.h"
#import "LFileUtils.h"
#import "sqlite3.h"

@interface LCursor ()
{
    sqlite3_stmt *_stmt;
    NSDictionary *_columnMap;
}

- (id)initWithStmt:(sqlite3_stmt*)stmt;

@end

@implementation LCursor

- (id)initWithStmt:(sqlite3_stmt*)stmt {
    self = [super init];
    if(self) {
        _stmt = stmt;
        [self buildColumnMap];
    }
    return self;
}

- (void)buildColumnMap {
    int colCount = sqlite3_column_count(_stmt);
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:colCount];
    for (int col = 0; col < colCount; col++) {
        NSString* name = [NSString stringWithUTF8String:(const char*)sqlite3_column_name(_stmt, col)];
        d[name] = @(col);
    }
    _columnMap = d;
}

- (BOOL)next {
    if(_stmt == NULL) return NO;
    return sqlite3_step(_stmt) == SQLITE_ROW;
}

- (long)getInt32:(NSString*)columnName {
    if(_stmt == NULL) return 0;
    NSNumber *col = _columnMap[columnName];
    if(col == nil) return 0;
    return sqlite3_column_int(_stmt, col.integerValue);
}

- (long long)getInt64:(NSString*)columnName {
    if(_stmt == NULL) return 0;
    NSNumber *col = _columnMap[columnName];
    if(col == nil) return 0;
    return sqlite3_column_int64(_stmt, col.integerValue);
}

- (NSString*)getString:(NSString*)columnName {
    if(_stmt == NULL) return nil;
    NSNumber *col = _columnMap[columnName];
    if(col == nil) return nil;
    if ( sqlite3_column_type(_stmt, col.integerValue) != SQLITE_NULL )
    {
        return @((const char*)sqlite3_column_text(_stmt, col.integerValue));
    }
    return nil;
}

- (void)close {
    sqlite3_finalize(_stmt);
    _stmt = NULL;
    _columnMap = nil;
}

@end


@interface LDb ()
{
    sqlite3 *_datadb;
}

@property (readonly) sqlite3 *datadb;
@end


@implementation LDb

static LDb* _db = nil;

+ (LDb*) db
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _db = [[LDb alloc] init];
    });
    
    return _db;
}

- (id) init
{
    if((self = [super init]) != nil) {
        _datadb = [self openDataDb];
        if(_datadb == nil) return nil;
        
    }
    return self;
}

- (void) close
{
    sqlite3_close(_datadb);
    _datadb = NULL;
}

- (sqlite3*) datadb
{
    return _datadb;
}

- (sqlite3 *) openDataDb
{
    int rc;
    NSString *path = [LFileUtils documentPath: @"ldata.jpg"];
    sqlite3 *db;
    
    NSInteger version = [[NSUserDefaults standardUserDefaults] integerForKey: @"ldb_version"];
    if(version != DB_VERSION) {
        [self copyDb];
        rc = sqlite3_open_v2(path.UTF8String,
                        &db,
                        SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE,
                        NULL);
        
        if(rc) {
            NSLog(@"[DB ERR] DB open: %d, %s\n", sqlite3_errcode(db), sqlite3_errmsg(db));
            return NULL;
        }
    }
    else {
        rc = sqlite3_open_v2(path.UTF8String,
                             &db,
                             SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE,
                             NULL);
        if(rc) {
            [self copyDb];
            sqlite3_open_v2(path.UTF8String,
                            &db,
                            SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE,
                            NULL);
            
            if(rc) {
                NSLog(@"[DB ERR] DB open: %d, %s\n", sqlite3_errcode(db), sqlite3_errmsg(db));
                return NULL;
            }
        }
    }
    sqlite3_exec(db, "PRAGMA foreign_keys = ON", NULL, NULL,  NULL);
    sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS tblBookmark (wordText TEXT PRIMARY KEY, bookmarkTimeStamp INTEGER); ", NULL, NULL, NULL);
    
    [[NSUserDefaults standardUserDefaults] setInteger:DB_VERSION forKey:@"ldb_version"];
    
    return db;
}

- (void) copyDb
{
    
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbSrc = [LFileUtils resourcePath: @"ldata.jpg"];
    NSString *dbDst =  [LFileUtils documentPath: @"ldata.jpg"];
    
    NSLog(@"Copy Database: %@ -> %@\n", dbSrc, dbDst);
   
    success = [fileManager fileExistsAtPath: dbSrc];
    if (success) {
        success = [fileManager fileExistsAtPath: dbDst];
        if(success) {
            success = [fileManager removeItemAtPath: dbDst error:&error];
            //return;
        }
        success = [fileManager copyItemAtPath: dbSrc toPath: dbDst error:&error];
        if (!success)  {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
}

- (LCursor*)prepareCursor:(NSString*)query;
{
    sqlite3_stmt *pStmt = NULL;
    const char* command = [query UTF8String];
    if(sqlite3_prepare_v2(_datadb, command, -1, &pStmt, NULL) == SQLITE_OK) {
        return [[LCursor alloc] initWithStmt:pStmt];
    }
    return NULL;
}

- (BOOL)executeQuery:(NSString*)query
{
    int rc;
    rc = sqlite3_exec(_datadb, query.UTF8String, NULL, NULL,  NULL);
    return rc == SQLITE_OK;
}

@end
