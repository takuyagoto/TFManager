//
//  EventPickerViewController.h
//  Training Log
//
//  Created by Takuya on 2014/06/08.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventPeer.h"

@protocol EventPickerDelegate <NSObject>
- (void)selectEvent:(int)event_id name:(NSString *)event_name;
@end

@interface EventPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    id<EventPickerDelegate> _delegate;
}
@property (nonatomic) id<EventPickerDelegate> delegate;
@property (nonatomic) int category_id;
@property (nonatomic) int event_id;

@end
