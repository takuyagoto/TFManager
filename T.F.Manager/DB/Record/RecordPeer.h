//
//  RecordPeer.h
//  Training Log
//
//  Created by Takuya on 2014/06/10.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Record.h"

@interface RecordPeer : NSObject

+ (Record *)retrieveByPK:(int)pkey;
+ (NSMutableArray *)getDateList;
+ (NSMutableArray *)getRecordsByDate:(NSDate *)date;
+ (NSMutableDictionary *)getEventDic;
+ (NSMutableArray *)getRecordsByEventId:(int)event_id;

@end
