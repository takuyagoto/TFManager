//
//  CategoryPickerViewController.h
//  Training Log
//
//  Created by Takuya on 2014/06/08.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category_.h"
#import "CategoryPeer.h"

@protocol CategoryPickerDelegate <NSObject>
- (void)selectCategory:(int)category_id name:(NSString *)category_name unit:(int)unit_;
@end

@interface CategoryPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    id<CategoryPickerDelegate> _delegate;
}
@property (nonatomic) id<CategoryPickerDelegate> delegate;
@property (nonatomic) int category_id;

@end
