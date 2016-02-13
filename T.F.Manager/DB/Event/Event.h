//
//  Event.h
//  Training Log
//
//  Created by Takuya on 2014/05/22.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "EventPeer.h"

@interface Event : NSObject
{
    int Id;
    NSString *name;
    int category_id;
}

- (id) init;
- (id) initWithFMResults:(FMResultSet *)result;
- (int) Id;
- (void) setId:(int)Id_;
- (NSString *) name;
- (void) setName:(NSString *)name_;
- (int) category_id;
- (void) setCategoryId:(int)category_id_;
- (void) save;
- (void) deleteRecord;

@end
