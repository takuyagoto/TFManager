//
//  CategoryPeer.h
//  Training Log
//
//  Created by Takuya on 2014/06/08.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Category_.h"

@interface CategoryPeer : NSObject

+ (Category_ *)retrieveByPK:(int)pkey;
+ (NSMutableArray *)getAllCategories;

@end
