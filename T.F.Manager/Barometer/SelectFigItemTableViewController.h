//
//  SelectFigItemTableViewController.h
//  Training Log
//
//  Created by Takuya on 2014/05/20.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputViewController.h"
#import "RecordPeer.h"
#import "ChartViewController.h"

@interface SelectFigItemTableViewController : UITableViewController <UIActionSheetDelegate>

@property (nonatomic,strong) NSDictionary *eventDic;
@property (nonatomic,strong) ChartViewController *cVC;

@end
