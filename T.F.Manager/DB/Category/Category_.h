//
//  Category_.h
//  Training Log
//
//  Created by Takuya on 2014/05/22.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface Category_ : NSObject
{
    int Id;
    NSString *name;
    int unit;
}

- (id) init;
- (id) initWithFMResults:(FMResultSet *)result;
- (int) Id;
- (void) setId:(int)Id_;
- (NSString *) name;
- (void) setName:(NSString *)name_;
- (int) unit;
- (void) setUnit:(int)unit_;
- (void) save;
- (void) deleteRecord;

- (void) insertOnce;

@end
