//
//  InputViewController.h
//  Training Log
//
//  Created by Takuya on 2014/05/20.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Record.h"
#import "Event.h"
#import "Category_.h"
#import "DatePickerViewController.h"
#import "CategoryPickerViewController.h"
#import "EventPickerViewController.h"
#import "AddEventViewController.h"
#import "RecordPickerViewController.h"

@interface InputViewController : UIViewController <DatePickerDelegate, CategoryPickerDelegate, EventPickerDelegate, RecordPickerDelegate>
{
    int unit;
}

@property (nonatomic,strong) Record *rec;
@property (nonatomic,strong) NSString *lbTitle;

@end
