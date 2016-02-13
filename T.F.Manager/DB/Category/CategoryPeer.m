//
//  CategoryPeer.m
//  Training Log
//
//  Created by Takuya on 2014/06/08.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "CategoryPeer.h"

@implementation CategoryPeer

+ (id)retrieveByPK:(int)pkey
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]];
    
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM category WHERE id=%d",pkey];
    FMResultSet *results = [db executeQuery:sql];
    
    Category_ *c;
    while ([results next]) {
        c = [[Category_ alloc] initWithFMResults:results];
    }
    
    [results close];
    
    [db close];
    
    if (c != nil) return c;
    
    return nil;
}

+ (NSMutableArray *)getAllCategories
{
    NSMutableArray *c_s = [[NSMutableArray alloc] init] ;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM category ORDER BY id"];
    //FMResultSet *results = [db executeQuery:@"SELECT * FROM category WHERE id=1"];
    
    
    while ([results next]) {
        [c_s addObject:[[Category_ alloc] initWithFMResults:results]];
    }
    
    [results close];
    
    [db close];
    
    return c_s;
}

@end
