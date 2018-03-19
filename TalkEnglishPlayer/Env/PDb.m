//
//  PDb.m
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "PDb.h"
#import "PFileUtils.h"
#import "sqlite3.h"
#import "PPlayListDataItem.h"

@interface PCursor ()
{
    sqlite3_stmt *_stmt;
    NSDictionary *_columnMap;
}

- (id)initWithStmt:(sqlite3_stmt*)stmt;

@end

@implementation PCursor

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


@interface PDb ()
{
    sqlite3 *_datadb;
}

@property (readonly) sqlite3 *datadb;
@end


@implementation PDb

static PDb* _db = nil;

+ (PDb*) db
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _db = [[PDb alloc] init];
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
    NSString *path = [PFileUtils documentPath: @"pdata.db"];
    sqlite3 *db;
    
    NSInteger version = [[NSUserDefaults standardUserDefaults] integerForKey: @"pdb_version"];
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
    
    [[NSUserDefaults standardUserDefaults] setInteger:DB_VERSION forKey:@"pdb_version"];
    
    return db;
}

- (void) copyDb
{
    
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbSrc = [PFileUtils resourcePath: @"pdata.db"];
    NSString *dbDst =  [PFileUtils documentPath: @"pdata.db"];
    
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

- (PCursor*)prepareCursor:(NSString*)query;
{
    sqlite3_stmt *pStmt = NULL;
    const char* command = [query UTF8String];
    if(sqlite3_prepare_v2(_datadb, command, -1, &pStmt, NULL) == SQLITE_OK) {
        return [[PCursor alloc] initWithStmt:pStmt];
    }
    return NULL;
}

- (BOOL)executeQuery:(NSString*)query
{
    int rc;
    rc = sqlite3_exec(_datadb, query.UTF8String, NULL, NULL,  NULL);
    return rc == SQLITE_OK;
}

- (BOOL)insertPlayListData:(NSInteger)nPlayListNum item:(PPlayListDataItem*)item {
//    NSString stringWithFormat:@"INSERT INTO playlist_user_data (playListName, first, second, gender, audio_slow_type, slow_type, audio_normal, normal_time, album, track, dialogue, images) values('%@', '%@', '%@', '%@', '%@', '%@', '%@', %ld, '%@', '%@', '%@', '%@')", strPlayListName, item.strFirst, item.strSecond, item.strGender, item.strAudioSlowType, item.strSlowType, item.strAudioNormal, item.mNormalTime, item.strAlbumName, item.strTrackName, strDialog, item.strTrackImage];
    sqlite3_stmt *pStmt = NULL;
    const char* sql = "INSERT INTO playlist_user_data (playListNo, first, second, gender, audio_slow_type, slow_type, audio_normal, normal_time, album, track, dialogue, images) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    if (sqlite3_prepare_v2(_datadb, sql, -1, &pStmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(pStmt, 1, (int)nPlayListNum);
        sqlite3_bind_text(pStmt, 2, [item.strFirst UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(pStmt, 3, [item.strSecond UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(pStmt, 4, [item.strGender UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(pStmt, 5, [item.strAudioSlowType UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(pStmt, 6, [item.strSlowType UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(pStmt, 7, [item.strAudioNormal UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(pStmt, 8, (int)item.mNormalTime);
        sqlite3_bind_text(pStmt, 9, [item.strAlbumName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(pStmt, 10, [item.strTrackName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(pStmt, 11, [item.strDialog UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(pStmt, 12, [item.strTrackImage UTF8String], -1, SQLITE_TRANSIENT);
        if (sqlite3_step(pStmt) != SQLITE_DONE) {
            NSLog(@"SQL execution failed: %s", sqlite3_errmsg(_datadb));
            return NO;
        }
    } else {
        NSLog(@"SQL prepare failed: %s", sqlite3_errmsg(_datadb));
        return NO;
    }
    sqlite3_finalize(pStmt);
    return YES;
}

@end
