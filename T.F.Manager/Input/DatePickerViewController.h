//
//  DatePickerViewController.h
//  Training Log
//
//  Created by Takuya on 2014/06/08.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerDelegate <NSObject>
- (void)selectDate:(NSDate *)date;
@end

@interface DatePickerViewController : UIViewController
{
    id<DatePickerDelegate> _delegate;
}
@property (nonatomic) id<DatePickerDelegate> delegate;
@property (nonatomic) NSDate *date;

@end
