//
//  Category_.m
//  Training Log
//
//  Created by Takuya on 2014/05/22.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "Category_.h"

@implementation Category_

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithFMResults:(FMResultSet *)result
{
    self = [super init];
    if (self) {
        [self setId:[result intForColumn:@"id"]];
        [self setName:[result stringForColumn:@"name"]];
        [self setUnit:[result intForColumn:@"unit"]];
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

- (NSString *)name
{
    return name;
}

- (void) setName:(NSString *)name_
{
    name = name_;
}

- (int) unit
{
    /*
     1: 時間
     2: 距離
     3: 重さ
     4: なし
    */
    return unit;
}

- (void) setUnit:(int)unit_
{
    unit = unit_;
}

- (void) save
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:STRING_PATH_FOR_DB]];
    
    [db open];
    
    NSString *sql;
    if (self.Id > 0) {
        sql = [NSString stringWithFormat:@"UPDATE category SET name='%@',unit=%d WHERE id=%d",self.name,self.unit,self.Id];
    } else {
        sql = [NSString stringWithFormat:@"INSERT INTO category (name,unit) VALUES ('%@',%d)",self.name,self.unit];
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
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM category WHERE id=%d,name='%@',unit=%d",self.Id,self.name,self.unit];
    [db executeUpdate:sql];
    
    [db close];
}

@end
