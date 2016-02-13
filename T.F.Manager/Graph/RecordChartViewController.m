//
//  RecordChartViewController.m
//  Training Log
//
//  Created by Takuya on 2014/08/01.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "RecordChartViewController.h"

@interface RecordChartViewController ()
{
    NSString *plotId;
    
    NSDate *firstDate;
    NSDate *lastDate;
    double biggestRecord;
    double smallestRecord;
    
    NSArray *records;
}
@end

@implementation RecordChartViewController

@synthesize scatterPlotData;
@synthesize selectedEventId;
@synthesize selectedEventName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CPTGraphHostingView *hostingView =
    [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:hostingView];
    
    [hostingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [hostingView addConstraint:[NSLayoutConstraint constraintWithItem:hostingView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1.0
                                                             constant:self.view.frame.size.width]];
    
    [hostingView addConstraint:[NSLayoutConstraint constraintWithItem:hostingView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:1.0
                                                             constant:self.view.frame.size.height]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:hostingView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:hostingView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:hostingView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:hostingView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    graph = [[CPTXYGraph alloc] initWithFrame:hostingView.bounds];
    hostingView.hostedGraph = graph;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    plotId = [NSString stringWithFormat:@"%d",selectedEventId];
    
    [self setGraph];
    
    [self setTitle:selectedEventName];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// グラフに使用する折れ線グラフのデータ数を返す
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    NSUInteger numRecords = 0;
    NSString *identifier  = (NSString *)plot.identifier;
    
    // 折れ線グラフのidentifierにより返すデータ数を変える（複数グラフを表示する場合に必要）
    if ([identifier isEqualToString:plotId]) {
        numRecords = scatterPlotData.count;
    }
    
    return numRecords;
}

// グラフに使用する折れ線グラフのX軸とY軸のデータを返す
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num        = nil;
    NSString *identifier = (NSString *)plot.identifier;
    
    // 折れ線グラフのidentifierにより返すデータ数を変える（複数グラフを表示する場合に必要）
    if ([identifier isEqualToString:plotId]) {
        switch (fieldEnum) {
            case CPTScatterPlotFieldX:  // X軸の場合
                num = [[scatterPlotData objectAtIndex:index] valueForKey:@"x"];
                break;
            case CPTScatterPlotFieldY:  // Y軸の場合
                num = [[scatterPlotData objectAtIndex:index] valueForKey:@"y"];
                break;
        }
    }
    
    
    return num;
}

- (void)setGraph
{
    [self makeDataByEventId:selectedEventId];
    
    // グラフのボーダー設定
    graph.plotAreaFrame.borderLineStyle = nil;
    graph.plotAreaFrame.cornerRadius    = 0.0f;
    graph.plotAreaFrame.masksToBorder   = NO;
    
    // パディング
    graph.paddingLeft   = 0.0f;
    graph.paddingRight  = 0.0f;
    graph.paddingTop    = 0.0f;
    graph.paddingBottom = 0.0f;
    
    graph.plotAreaFrame.paddingLeft   = 45.0f;
    graph.plotAreaFrame.paddingTop    = 0.0f;
    graph.plotAreaFrame.paddingRight  = 10.0f;
    graph.plotAreaFrame.paddingBottom = 75.0f;
    
    //プロット間隔の設定
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    plotSpace.allowsUserInteraction = YES;
    
    // テキストスタイル
    CPTMutableTextStyle *textStyle = [CPTTextStyle textStyle];
    textStyle.color                = [CPTColor colorWithComponentRed:0.447f green:0.443f blue:0.443f alpha:1.0f];
    textStyle.fontSize             = 13.0f;
    textStyle.textAlignment        = CPTTextAlignmentCenter;
    
    // ラインスタイル
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor            = [CPTColor colorWithComponentRed:0.788f green:0.792f blue:0.792f alpha:1.0f];
    lineStyle.lineWidth            = 2.0f;
    
    // X軸のメモリ・ラベルなどの設定
    NSTimeInterval oneDay = 24.0f * 60.0f * 60.0f;
    float days = ([lastDate timeIntervalSinceDate:firstDate] / oneDay) + 1;
    float fromDay = -1;
    if (days > 60) {
        fromDay = days - 60;
    }
    // X軸はMM/ddの値で設定
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(oneDay * fromDay) length:CPTDecimalFromFloat(oneDay*days)];
    // X軸はMM/ddの値で設定
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(oneDay * -1.0f) length:CPTDecimalFromFloat(oneDay*(days+1))];
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
	x.majorIntervalLength = CPTDecimalFromFloat(oneDay*14.0f);  // ２週間ごとにラベル表示
	x.minorTicksPerInterval = 13;  // 目盛りは１日ごと(majorInterval中に13補助目盛りを追加
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd"];
	CPTTimeFormatter *timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    timeFormatter.referenceDate = firstDate;
    x.labelFormatter = timeFormatter;
    x.axisLineStyle               = lineStyle;      // X軸の線にラインスタイルを適用
    x.majorTickLineStyle          = lineStyle;      // X軸の大きいメモリにラインスタイルを適用
    x.minorTickLineStyle          = lineStyle;      // X軸の小さいメモリにラインスタイルを適用
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // X軸のY位置
    x.labelTextStyle = textStyle;
    lineStyle.lineWidth = 1.0f;
    x.majorGridLineStyle = lineStyle;
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];  // 軸固定
    
    // Y軸のメモリ・ラベルなどの設定
    NSNumber *numberValue = [[NSNumber alloc] initWithInt:biggestRecord];
    NSInteger digits = (int)log10([numberValue doubleValue]) - 1;
    float majorTicker = pow(10,digits);
    float sub = biggestRecord - smallestRecord;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat((float)smallestRecord - sub*0.25) length:CPTDecimalFromFloat(sub * 1.5)];
    CPTXYAxis *y = axisSet.yAxis;
    lineStyle.lineWidth = 2.0f;
    y.axisLineStyle               = lineStyle;      // Y軸の線にラインスタイルを適用
    y.majorTickLineStyle          = lineStyle;      // Y軸の大きいメモリにラインスタイルを適用
    y.minorTickLineStyle          = lineStyle;      // Y軸の小さいメモリにラインスタイルを適用
    y.majorTickLength = 9.0f;                   // Y軸の大きいメモリの長さ
    y.minorTickLength = 5.0f;                   // Y軸の小さいメモリの長さ
    y.majorIntervalLength         = CPTDecimalFromFloat(majorTicker);  // Y軸ラベルの表示間隔
    y.minorTicksPerInterval       = 9;  // 目盛りは0.1ごと(majorInterval中に9補助目盛りを追加)
    y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0.0f);  // Y軸のX位置
    y.title                       = @"";
    y.titleTextStyle = textStyle;
    y.titleRotation = M_PI*2;
    y.titleLocation               = CPTDecimalFromFloat(1.2f);
    y.titleOffset                 = 1.5f;
    lineStyle.lineWidth = 1.0f;
    y.majorGridLineStyle = lineStyle;
    lineStyle.lineWidth = 0.5f;
    y.minorGridLineStyle = lineStyle;
    y.labelTextStyle = textStyle;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];  // 軸固定
    
    CPTScatterPlot *scatterPlot = [[CPTScatterPlot alloc] init];
    scatterPlot.delegate        = self;
    scatterPlot.identifier      = plotId;    // 折れ線グラフを識別するために識別子を設定
    scatterPlot.dataSource      = self;     // 折れ線グラフのデータソースを設定
    scatterPlot.plotSymbolMarginForHitDetection = 20.0f;
    
    // 折れ線グラフのスタイルを設定
    CPTMutableLineStyle *graphlineStyle = [scatterPlot.dataLineStyle mutableCopy];
    graphlineStyle.lineWidth = 3;      // 太さ
    graphlineStyle.lineColor = [CPTColor colorWithComponentRed:(float)(rand()%1000)/1000 green:(float)(rand()%1000)/1000 blue:(float)(rand()%1000)/1000 alpha:1.0f];// 色
    scatterPlot.dataLineStyle = graphlineStyle;
    
    
    // グラフに折れ線グラフを追加
    [graph addPlot:scatterPlot];
}

// CPTScatterPlotDelegateメソッド
// シンボル点付加
-(CPTPlotSymbol *)symbolForScatterPlot:(CPTScatterPlot *)plot recordIndex:(NSUInteger)idx
{
    if ([[[scatterPlotData objectAtIndex:idx] allKeys] containsObject:@"recordIndex"]) {
        CPTPlotSymbol *oneSymbol = [CPTPlotSymbol ellipsePlotSymbol];
        oneSymbol.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
        CPTMutableLineStyle *symbolLineStyle = [plot.dataLineStyle mutableCopy];
        symbolLineStyle.lineWidth = 2;
        oneSymbol.lineStyle = symbolLineStyle;
        oneSymbol.size = CGSizeMake(5.0f, 5.0f);
        return oneSymbol;
    }
    return nil;
}

// CPTScatterPlotDelegateメソッド
// タップで記録表示、再タップで非表示
-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)idx
{
    NSNumber *recordIndex = [[scatterPlotData objectAtIndex:idx] objectForKey:@"recordIndex"];
    if (recordIndex) {
        NSNumber *x = [[scatterPlotData objectAtIndex:idx] objectForKey:@"x"];
        NSNumber *y = [[scatterPlotData objectAtIndex:idx] objectForKey:@"y"];
        
        for (CPTPlotSpaceAnnotation *a in [graph.plotAreaFrame.plotArea annotations]) {
            if ( [[a.anchorPlotPoint objectAtIndex:0] doubleValue] == x.doubleValue
                && [[a.anchorPlotPoint objectAtIndex:1] doubleValue] == y.doubleValue ){
                // 既に表示されているものは消す
                [graph.plotAreaFrame.plotArea removeAnnotation:a];
                return;
            }
        }
        
        NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
        CPTPlotSpaceAnnotation* symbolAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:graph.defaultPlotSpace anchorPlotPoint:anchorPoint];
        
        Record *r = [records objectAtIndex:recordIndex.intValue];
        NSString *anotationText = [NSString stringWithFormat:@"%@-%d本目%@",[[r getDateString] substringFromIndex:5],r.no,[r getRecordString]];
        CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:anotationText style:[CPTTextStyle textStyle]];
        
        // annotation作成
        symbolAnnotation.contentLayer = textLayer;
        symbolAnnotation.displacement = CGPointMake(0.0f, -10.0f);     // 設定したアンカーからどれだけずれて表示させるか
        [graph.plotAreaFrame.plotArea addAnnotation:symbolAnnotation];
    }
}

- (void)makeDataByEventId:(int)event_id
{
    
    records = [RecordPeer getRecordsByEventId:event_id];
    
    biggestRecord = 0;
    smallestRecord = 0;
    
    for (Record *r in records) {
        if (biggestRecord == 0) {
            biggestRecord = r.record;
        }
        if (smallestRecord == 0) {
            smallestRecord = r.record;
        }
        if (r.record > biggestRecord) {
            biggestRecord = r.record;
        }
        if (r.record < smallestRecord) {
            smallestRecord = r.record;
        }
    }
    
    if (biggestRecord == 0) biggestRecord = 1.0;
    
    if (firstDate == nil) {
        firstDate = [[records firstObject] date];
    } else {
        firstDate = [firstDate earlierDate:[[records firstObject] date]];
    }
    if (lastDate == nil) {
        lastDate = [[records lastObject] date];
    } else {
        lastDate = [lastDate laterDate:[[records lastObject] date]];
    }
    
    scatterPlotData = [NSMutableArray array];
    NSNumber *preX = [NSNumber numberWithDouble:0.0];
    NSNumber *preY = [NSNumber numberWithDouble:[[records objectAtIndex:0] record]];
    NSNumber *recordInx = [NSNumber numberWithInt:0];
    [scatterPlotData addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:preX, @"x", preY, @"y", recordInx,@"recordIndex", nil]];
    
    NSDate *preDate = [[records objectAtIndex:0] date];
    NSTimeInterval oneDay = 24.0f*60.0f*60.0f;
    for (int i = 1; i < records.count; i++) {
        NSTimeInterval timeI = [[[records objectAtIndex:i] date] timeIntervalSinceDate:preDate];
        int dateLag = (int)timeI / oneDay;
        for (int day = 1; day < dateLag; day++) {
            preX = [NSNumber numberWithDouble:(preX.doubleValue + oneDay)];
            NSNumber *y = [NSNumber numberWithDouble:(preY.doubleValue + (day * ([[records objectAtIndex:i] record] - preY.doubleValue) / dateLag))];
            [scatterPlotData addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:preX, @"x", y, @"y", nil]];
        }
        preX = [NSNumber numberWithDouble:(preX.doubleValue + oneDay)];
        preY = [NSNumber numberWithDouble:[[records objectAtIndex:i] record]];
        recordInx = [NSNumber numberWithInt:i];
        [scatterPlotData addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:preX, @"x", preY, @"y", recordInx, @"recordIndex", nil]];
        preDate = [[records objectAtIndex:i] date];
    }
}

@end
