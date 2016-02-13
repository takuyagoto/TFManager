//
//  ChartViewController.h
//  Training Log
//
//  Created by Takuya on 2014/07/15.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "RecordPeer.h"

@interface ChartViewController : UIViewController <CPTPlotDataSource,CPTScatterPlotDelegate>
{
@private
    // グラフ表示領域（この領域に円グラフを追加する）
    CPTGraph *graph;
}

// データを表示するEventID
@property (nonatomic, strong) NSArray *selectedEventIdList;
// データを表示するEventName
@property (nonatomic, strong) NSArray *selectedEventNameList;

@end
