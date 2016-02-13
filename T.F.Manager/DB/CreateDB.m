//
//  CreateDB.m
//  Training Log
//
//  Created by Takuya on 2014/05/22.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "CreateDB.h"
#import "Category_.h"

@implementation CreateDB

+ (void)createDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    //DBファイルがあるかどうか確認
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]])
    {
        //なければ新規作成
        FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]];
        
        [db open];
        
        NSString *sql = @"CREATE TABLE IF NOT EXISTS record (id INTEGER PRIMARY KEY AUTOINCREMENT,date REAL,category_id INTEGER,event_id INTEGER,no INTEGER,record REAL);";
        [db executeUpdate:sql];
        
        sql = @"CREATE TABLE IF NOT EXISTS category (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,unit INTEGER);";
        [db executeUpdate:sql];
        
        sql = @"CREATE TABLE IF NOT EXISTS event(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,category_id INTEGER);";
        if ([db executeUpdate:sql]) NSLog(@"true");
        
        sql = @"INSERT INTO category (name,unit) VALUES ('短距離',1);";
        [db executeUpdate:sql];
        sql = @"INSERT INTO category (name,unit) VALUES ('中距離',1);";
        [db executeUpdate:sql];
        sql = @"INSERT INTO category (name,unit) VALUES ('長距離',1);";
        [db executeUpdate:sql];
        sql = @"INSERT INTO category (name,unit) VALUES ('跳躍',2);";
        [db executeUpdate:sql];
        sql = @"INSERT INTO category (name,unit) VALUES ('投擲',2);";
        [db executeUpdate:sql];
        sql = @"INSERT INTO category (name,unit) VALUES ('ウェイト',3);";
        [db executeUpdate:sql];
        sql = @"INSERT INTO category (name,unit) VALUES ('その他',4);";
        [db executeUpdate:sql];
                
        [db close]; //DB閉じる
    }
}

@end
