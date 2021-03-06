//
//  LSQLiteManager.h
//  collections
//
//  Created by Ester Sanchez on 10/03/11.
//  Copyright 2011 Dinamica Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"


enum errorCodes {
	kDBNotExists,
	kDBFailAtOpen, 
	kDBFailAtCreate,
	kDBErrorQuery,
	kDBFailAtClose
};

@interface LSQLiteManager : NSObject {

	sqlite3 *db; // The SQLite db reference
	NSString *databaseName; // The database name
}

@property (nonatomic, strong) NSMutableArray *columnArray;

- (id)initWithDatabaseNamed:(NSString *)name;

// SQLite Operations
- (NSError *) openDatabase;
- (NSError *) doQuery:(NSString *)sql;
- (NSError *) doUpdateQuery:(NSString *)sql withParams:(NSArray *)params;
- (NSArray *) getRowsForQuery:(NSString *)sql;
- (NSError *) closeDatabase;

- (NSString *) getDatabaseDump;

- (void) getColumeInfo:(NSString *)sql;
- (NSInteger) getColumeId:(NSString *)fieldName;

@end
