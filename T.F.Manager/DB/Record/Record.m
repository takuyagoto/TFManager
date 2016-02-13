//
//  Record.m
//  Training Log
//
//  Created by Takuya on 2014/06/08.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "Record.h"

@implementation Record

- (id)init
{
    self = [super init];
    if (self) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
        date = [dateFormatter dateFromString:dateStr];
        no = 1;
    }
    return self;
}

- (id)initWithFMResults:(FMResultSet *)result
{
    self = [super init];
    if (self) {
        [self setId:[result intForColumn:@"id"]];
        [self setDate:[result dateForColumn:@"date"]];
        [self setCategoryId:[result intForColumn:@"category_id"]];
        [self setEventId:[result intForColumn:@"event_id"]];
        [self setNo:[result intForColumn:@"no"]];
        [self setRecord:[result doubleForColumn:@"record"]];
    }
    return self;
}

- (int) Id
{
    return Id;
}

- (void) setId:(int)Id_
{
    Id = Id_;
}

- (NSDate *) date
{
    return date;
}

- (void) setDate:(NSDate *)date_
{
    //　データベース上ではエポックタイムの小数型
    // Model以外の場合はこの事を考えなくていいようにNSDateとして扱う。
    date = date_;
}

- (int) category_id
{
    return category_id;
}

- (void) setCategoryId:(int)category_id_;
{
    category_id = category_id_;
}

- (int) event_id
{
    return event_id;
}

- (void) setEventId:(int)event_id_
{
    event_id = event_id_;
}

- (int) no
{
    return no;
}

- (void) setNo:(int)no_
{
    no = no_;
}

- (double) record
{
    return record;
}

- (void) setRecord:(double)record_
{
    record = record_;
}

- (void) save
{
    double dateEpoch = [date timeIntervalSince1970];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]];
    
    [db open];
    NSString *sql;
    if (self.Id > 0) {
        sql = [NSString stringWithFormat:@"UPDATE record SET date=%f,category_id=%d,event_id=%d,no=%d,record=%f WHERE id=%d",dateEpoch,self.category_id,self.event_id,self.no,self.record,self.Id];
    } else {
        sql = [NSString stringWithFormat:@"INSERT INTO record (date,category_id,event_id,no,record) VALUES (%f,%d,%d,%d,%f)",dateEpoch,self.category_id,self.event_id,self.no,self.record];
    }
    [db executeUpdate:sql];
    
    [db close];
}

- (void) deleteRecord
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]];
    
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM record WHERE id=%d",self.Id];
    [db executeUpdate:sql];
    
    [db close];
}

- (NSString *)getDateString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat  = @"yyyy/MM/dd";
    NSString *dateStr = [df stringFromDate:date];
    return dateStr;
}

+ (NSString *)getDateString:(NSDate *)date_
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat  = @"yyyy/MM/dd";
    NSString *dateStr = [df stringFromDate:date_];
    return dateStr;
}

+ (NSDate *)getDateFromDateString:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date__ = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",dateStr]];
    return date__;
}

- (NSString *)getCategoryName
{
    return [[CategoryPeer retrieveByPK:category_id] name];
}

- (NSString *)getEventName
{
    return [[EventPeer retrieveByPK:event_id] name];
}

- (NSString *)getRecordString
{
    NSString *returnStr;
    int unit = [[CategoryPeer retrieveByPK:category_id] unit];
    if (unit == 1) {
        int csec = (int)(record*100)%100;
        int sec = (int)record%60;
        int min = (int)record/60;
        int hour = (int)min/60;
        min = min%60;
        if (hour > 0) {
            returnStr = [NSString stringWithFormat:@"%2d時間%02d分%02d秒%02d",hour,min,sec,csec];
            return returnStr;
        }
        if (min > 0) {
            returnStr = [NSString stringWithFormat:@"%2d分%02d秒%02d",min,sec,csec];
            return returnStr;
        }
        returnStr = [NSString stringWithFormat:@"%2d秒%02d",sec,csec];
        return returnStr;
    }
    else if (unit == 2) {
        int m = (int)record/100;
        int cm = (int)record%100;
        returnStr = [NSString stringWithFormat:@"%dm%02d",m,cm];
        return returnStr;
    }
    else if (unit == 3) {
        returnStr = [NSString stringWithFormat:@"%.02fKg",record];
        return returnStr;
    }
    return nil;
}

- (int)getUnit
{
    return [[CategoryPeer retrieveByPK:category_id] unit];
}

@end
