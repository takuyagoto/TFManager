//
//  RecordPeer.m
//  Training Log
//
//  Created by Takuya on 2014/06/10.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "RecordPeer.h"

@implementation RecordPeer

+ (id)retrieveByPK:(int)pkey
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]];
    
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM record WHERE id=%d",pkey];
    FMResultSet *results = [db executeQuery:sql];
    
    Record *r;
    while ([results next]) {
        r = [[Record alloc] initWithFMResults:results];
    }
    
    [results close];
    
    [db close];
    
    if (r != nil) return r;
    
    return nil;
}


+ (NSMutableArray *)getDateList
{
    NSMutableArray *dateList = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]];
    
    [db open];
    
    NSString *sql = @"SELECT * FROM record ORDER BY date";
    FMResultSet *results = [db executeQuery:sql];
    
    double tempDate = 0;
    while ([results next]) {
        if (tempDate != [results doubleForColumn:@"date"]) {
            tempDate = [results doubleForColumn:@"date"];
            [dateList addObject:[Record getDateString:[results dateForColumn:@"date"]]];
        }
    }
    [results close];
    
    [db close];
    
    if (dateList != nil) return dateList;
    
    return nil;
}

+ (NSMutableArray *)getRecordsByDate:(NSDate *)date
{
    NSMutableArray *records = [[NSMutableArray alloc] init];
    
    double dateEpoch = [date timeIntervalSince1970];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]];
    
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM record WHERE date=%f ORDER BY category_id,event_id,no",dateEpoch];
    FMResultSet *results = [db executeQuery:sql];
    
    while ([results next]) {
        [records addObject:[[Record alloc] initWithFMResults:results]];
    }
    
    [results close];
    [db close];
    
    if (records != nil) return records;
    
    return nil;
}

// カテゴリーをkeyとしてデータのあるイベント名をNSArrayにして返す。
/*
 データベースを開いた状態のままでは他のModelメソッドが使えない（ModelメソッドそれぞれでDBを開いて閉じているため
 一度Recordオブジェクトとして重複しないように取得してからそれぞれのnameを検索し、Dictionaryに入れている。
*/
+ (NSMutableDictionary *)getEventDic
{
    NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *records = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]];
    
    [db open];
    
    NSString *sql = @"SELECT * FROM record ORDER BY category_id asc,event_id asc";
    FMResultSet *results = [db executeQuery:sql];
    
    int tempCategoryId = 0;
    int tempEventId = 0;
    while ([results next]) {
        if ([results intForColumn:@"category_id"] > 6) break;
        if (tempEventId != [results intForColumn:@"event_id"]) {
            tempEventId = [results intForColumn:@"event_id"];
            [records addObject:[[Record alloc] initWithFMResults:results]];
        }
    }
    
    [results close];
    [db close];
    
    tempCategoryId = 0;
    NSString *categoryName;
    NSMutableArray *events;
    for (Record *r in records) {
        if (tempCategoryId != r.category_id) {
            events = [[NSMutableArray alloc] init];
            tempCategoryId = r.category_id;
            categoryName = [[CategoryPeer retrieveByPK:tempCategoryId] name];
        }
        NSDictionary *event = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:r.event_id],[r getEventName]] forKeys:@[@"id", @"name"]];
        [events addObject:event];
        [eventDic setObject:events forKey:categoryName];
    }
    
    if (eventDic != nil) return eventDic;
    
    return nil;
}

+ (NSMutableArray *)getRecordsByEventId:(int)event_id
{
    NSMutableArray *records = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]];
    
    [db open];
    
    NSString *sql;
    if (event_id < 4) {
        sql = [NSString stringWithFormat:@"SELECT id,date,category_id,event_id,no,min(record) as record FROM record WHERE event_id=%d GROUP BY date ORDER BY date ASC,no ASC",event_id];
    } else {
        sql = [NSString stringWithFormat:@"SELECT id,date,category_id,event_id,no,max(record) as record FROM record WHERE event_id=%d GROUP BY date ORDER BY date ASC,no ASC",event_id];
    }
    FMResultSet *results = [db executeQuery:sql];
    
    while ([results next]) {
        Record *r = [[Record alloc] initWithFMResults:results];
        [records addObject:r];
    }
    
    [results close];
    [db close];
    
    if (records != nil) return records;
    
    return nil;
}

@end
