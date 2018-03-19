//
//  Lesson.m
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 18..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SLesson.h"

NSString *const kNotificationFavoriteUpdated = @"kNotificationFavoriteUpdated";

@implementation SLesson

+ (SLesson*)loadLesson:(NSInteger)lessonId {
    
    NSString *query = [NSString stringWithFormat:
                       @"SELECT PackGroupID, PackID, ID, Title, Content, FavTimeStamp "
                       @" FROM tblDetail "
                       @" WHERE ID=%ld",
                       (long)lessonId];
    SCursor *cursor = [[SDb db] prepareCursor:query];
    if(cursor == NULL) return NULL;
    
    SLesson *item = nil;
    if ([cursor next]) {
        item = [SLesson lessonWithCursor:cursor];
    }
    [cursor close];
    return item;
    
}

+ (SLesson*)lessonWithCursor:(SCursor*)cursor {
    SLesson *item = [[SLesson alloc] init];
    
    item.packageGroupId = [cursor getInt32:@"PackGroupID"];
    item.subPackageId = [cursor getInt32:@"PackID"];
    item.lessonId = [cursor getInt32:@"ID"];
    item.title = [cursor getString:@"Title"];
    item.contentHtml = [[[cursor getString:@"Content"]
                         stringByReplacingOccurrencesOfString:@"<!--"
                         withString:@"\n<!--\n"]
                        stringByReplacingOccurrencesOfString:@"//-->"
                        withString:@"\n//-->\n"];
    item.favorite = [cursor getInt64:@"FavTimeStamp"] > 0;

    return item;
}

- (void)notifyUpdateFavorite {
    unsigned long long time = _favorite ? (unsigned long long)[[NSDate date] timeIntervalSince1970] : 0L;
    [[SDb db] executeQuery:
     [NSString stringWithFormat:
      @"UPDATE tblDetail SET FavTimeStamp=%llu WHERE ID=%u ",
      time, _lessonId]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFavoriteUpdated
                                                            object:self];
    });

}

@end
