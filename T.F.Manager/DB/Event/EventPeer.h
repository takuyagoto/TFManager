//
//  EventPeer.h
//  Training Log
//
//  Created by Takuya on 2014/06/08.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface EventPeer : NSObject

+ (id)retrieveByPK:(int)pkey;
+ (NSMutableArray *)getAllEvents;
+ (NSMutableArray *)getEventsByCategoryId:(int)category_id;
+ (id)getEventByCategoryId:(int)category_id name:(NSString *)name;

@end
