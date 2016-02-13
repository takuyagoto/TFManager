//
//  TabBarController.h
//  Training Log
//
//  Created by Takuya on 2014/05/19.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogTableViewController.h"
#import "SelectFigItemTableViewController.h"
#import "RecordPlotTableViewController.h"

@interface TabBarController : UITabBarController

@property (strong, nonatomic) LogTableViewController *logTableViewController;
@property (strong, nonatomic) SelectFigItemTableViewController *selectFigItemTableViewController;
@property (strong, nonatomic) RecordPlotTableViewController *recordPlotTableViewController;

@end
