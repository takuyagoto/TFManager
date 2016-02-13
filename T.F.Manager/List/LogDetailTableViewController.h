//
//  LogDetailTableViewController.h
//  Training Log
//
//  Created by Takuya on 2014/06/10.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputViewController.h"
#import "RecordPeer.h"
#import "Record.h"

@interface LogDetailTableViewController : UITableViewController

@property (nonatomic,strong) NSDate *date;

@end
