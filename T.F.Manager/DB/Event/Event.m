//
//  Event.m
//  Training Log
//
//  Created by Takuya on 2014/05/22.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "Event.h"

@implementation Event

- (id)init
{
    self = [super init];
    return self;
}

- (id)initWithFMResults:(FMResultSet *)result
{
    self = [super init];
    if (self) {
        [self setId:[result intForColumn:@"id"]];
        [self setName:[result stringForColumn:@"name"]];
        [self setCategoryId:[result intForColumn:@"category_id"]];
    }
    return self;
}

- (int)Id
{
    return Id;
}

- (void)setId:(int)Id_
{
    Id = Id_;
}

- (NSString *) name
{
    return name;
}

- (void) setName:(NSString *)name_
{
    name = name_;
}

- (int) category_id
{
    return category_id;
}

- (void) setCategoryId:(int)category_id_
{
    category_id = category_id_;
}

- (void) save
{
    //　カテゴリーIDが1~7以外、名前が無い場合には保存しない
    if (self.category_id < 1 || self.category_id > 7 || name==nil) return;
    
    // 同じカテゴリーに既に同じ種目がある場合には保存しない
    if ([EventPeer getEventByCategoryId:self.category_id name:self.name] != nil) {
        return;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]];
    
    [db open];
    
    NSString *sql;
    if (self.Id > 0) {
        sql = [NSString stringWithFormat:@"UPDATE event SET name='%@',category_id=%d WHERE id=%d",self.name,self.category_id,self.Id];
    } else {
        sql = [NSString stringWithFormat:@"INSERT INTO event (name,category_id) VALUES ('%@',%d)",self.name,self.category_id];
    }
    [db executeUpdate:sql];
    
    [db close];
}

- (void)deleteRecord
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]];
    
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM event WHERE id=%d,name='%@',category_id=%d",self.Id,self.name,self.category_id];
    [db executeUpdate:sql];
    
    [db close];
}

@end
