//
//  AddEventViewController.h
//  Training Log
//
//  Created by Takuya on 2014/06/08.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryPickerViewController.h"
#import "Event.h"

@interface AddEventViewController : UIViewController <CategoryPickerDelegate>

@property (nonatomic) int category_id;
@property (strong,nonatomic) NSString *category_name;
@property (strong,nonatomic) NSString *name;

@end
