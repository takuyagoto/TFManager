//
//  Record.h
//  Training Log
//
//  Created by Takuya on 2014/06/08.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "EventPeer.h"
#import "CategoryPeer.h"

@interface Record : NSObject
{
    int Id;
    NSDate *date;
    int category_id;
    int event_id;
    int no;
    double record;
}

- (id) init;
- (id) initWithFMResults:(FMResultSet *)result;
- (int) Id;
- (void) setId:(int)Id_;
- (NSDate *) date;
- (void) setDate:(NSDate *)date_;
- (int) category_id;
- (void) setCategoryId:(int)category_id_;
- (int) event_id;
- (void) setEventId:(int)event_id_;
- (int) no;
- (void) setNo:(int)no_;
- (double) record;
- (void) setRecord:(double)record_;
- (void) save;
- (void) deleteRecord;

- (NSString *) getDateString;
+ (NSString *)getDateString:(NSDate *)date_;
+ (NSDate *)getDateFromDateString:(NSString *)dateStr;
- (NSString *)getCategoryName;
- (NSString *)getEventName;
- (NSString *)getRecordString;
- (int)getUnit;

@end
