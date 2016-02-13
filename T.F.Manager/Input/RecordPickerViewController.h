//
//  RecordPickerViewController.h
//  Training Log
//
//  Created by Takuya on 2014/06/09.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventPeer.h"

@protocol RecordPickerDelegate <NSObject>
- (void)selectRecord:(double)record;
@end

@interface RecordPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    id<RecordPickerDelegate> _delegate;
}
@property (nonatomic) id<RecordPickerDelegate> delegate;
@property (nonatomic) int unit;
@property (nonatomic) double record;

@end
