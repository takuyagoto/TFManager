//
//  EventPeer.m
//  Training Log
//
//  Created by Takuya on 2014/06/08.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "EventPeer.h"

@implementation EventPeer

+ (id)retrieveByPK:(int)pkey
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]];
    
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM event WHERE id=%d",pkey];
    FMResultSet *results = [db executeQuery:sql];
    
    
    Event *e;
    while ([results next]) {
        e = [[Event alloc] initWithFMResults:results];
    }
    
    [results close];
    
    [db close];
    
    if (e != nil) return e;
    
    return nil;
}

+ (NSMutableArray *)getAllEvents
{
    NSMutableArray *e_s = [[NSMutableArray alloc] init] ;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM event ORDER BY id"];
    
    
    while ([results next]) {
        [e_s addObject:[[Event alloc] initWithFMResults:results]];
    }
    
    [results close];
    
    [db close];
    
    return e_s;
}

+ (NSMutableArray *)getEventsByCategoryId:(int)category_id
{
    NSMutableArray *e_s = [[NSMutableArray alloc] init] ;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]];
    
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM event WHERE category_id=%d ORDER BY id",category_id];
    FMResultSet *results = [db executeQuery:sql];
    
    while ([results next]) {
        [e_s addObject:[[Event alloc] initWithFMResults:results]];
    }
    
    [results close];
    
    [db close];
    
    return e_s;
}

+ (Event *)getEventByCategoryId:(int)category_id name:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]];
    
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM event WHERE name='%@',category_id=%d ORDER BY id",name,category_id];
    FMResultSet *results = [db executeQuery:sql];
    
    Event *e;
    while ([results next]) {
        e = [[Event alloc] initWithFMResults:results];
    }
    
    [results close];
    
    [db close];
    
    if (e != nil)return e;
    return nil;
}

@end
