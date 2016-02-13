//
//  RecordPlotTableViewController.h
//  Training Log
//
//  Created by Takuya on 2014/08/01.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputViewController.h"
#import "RecordChartViewController.h"
#import "RecordPeer.h"

@interface RecordPlotTableViewController : UITableViewController

@property (nonatomic,strong) NSDictionary *eventDic;
@property (nonatomic,strong) RecordChartViewController *recordChartVC;

@end
