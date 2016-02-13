//
//  RecordChartViewController.h
//  Training Log
//
//  Created by Takuya on 2014/08/01.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "RecordPeer.h"

@interface RecordChartViewController : UIViewController <CPTPlotDataSource,CPTScatterPlotDelegate>
{
    @private CPTGraph *graph;
}

@property (readwrite, nonatomic) NSMutableArray *scatterPlotData;

@property (nonatomic) int selectedEventId;
@property (nonatomic, strong) NSString *selectedEventName;

@end
