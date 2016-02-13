//
//  ChartViewController.m
//  Training Log
//
//  Created by Takuya on 2014/07/15.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "ChartViewController.h"

@interface ChartViewController ()
{
    NSDate *firstDate;
    NSDate *lastDate;
    NSMutableArray *recordsArray;
    NSMutableArray *analizeRecordsList;
    NSMutableArray *plotDataList;
    
    CPTLegend *theLegend;
    CPTGraphHostingView *hostingView;
}

@end

@implementation ChartViewController

@synthesize selectedEventIdList;
@synthesize selectedEventNameList;

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
    
    // ホスティングビューを生成
    hostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    // 画面にホスティングビューを追加
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
    
    
    
    // グラフを生成
    graph = [[CPTXYGraph alloc] initWithFrame:hostingView.bounds];
    hostingView.hostedGraph = graph;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setGraph];
    [self setTitle:@"バロメータ"];
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

#pragma mark -
#pragma mark Plot Data Source Methods

// グラフに使用する折れ線グラフのデータ数を返す
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    NSUInteger numRecords = 0;
    NSString *identifier  = (NSString *)plot.identifier;
    
    // 折れ線グラフのidentifierにより返すデータ数を変える（複数グラフを表示する場合に必要）
    NSArray *plotData = [plotDataList objectAtIndex:identifier.intValue];
    if (plotData) numRecords = plotData.count;
    
    return numRecords;
}

// グラフに使用する折れ線グラフのX軸とY軸のデータを返す
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num        = nil;
    NSString *identifier = (NSString *)plot.identifier;
    
    // 折れ線グラフのidentifierにより返すデータ数を変える（複数グラフを表示する場合に必要）
    NSArray *plotData = [plotDataList objectAtIndex:identifier.intValue];
    if (plotData) {
        switch (fieldEnum) {
            case CPTScatterPlotFieldX:  // X軸の場合
                num = [[plotData objectAtIndex:index] valueForKey:@"x"];
                break;
            case CPTScatterPlotFieldY:  // Y軸の場合
                num = [[plotData objectAtIndex:index] valueForKey:@"y"];
                break;
        }
    }
    
    
    return num;
}

- (void)setGraph
{
    recordsArray = [NSMutableArray array];
    analizeRecordsList = [NSMutableArray array];
    plotDataList = [NSMutableArray array];
    
    for (NSNumber *event_id_number in selectedEventIdList) {
        [self makeDataByEventId:event_id_number.intValue];
    }
    
    [self makeDataByEventId:[[selectedEventIdList objectAtIndex:0] intValue]];
    
    // グラフのボーダー設定
    graph.plotAreaFrame.borderLineStyle = nil;
    graph.plotAreaFrame.cornerRadius    = 0.0f;
    graph.plotAreaFrame.masksToBorder   = YES;
    
    // パディング
    graph.paddingLeft   = 0.0f;
    graph.paddingRight  = 0.0f;
    graph.paddingTop    = 0.0f;
    graph.paddingBottom = 0.0f;
    
    graph.plotAreaFrame.paddingLeft   = 45.0f;
    graph.plotAreaFrame.paddingTop    = 0;
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
    float days = [lastDate timeIntervalSinceDate:firstDate] / oneDay;
    float fromDay = -1;
    if (days > 80) {
        fromDay = days - 80;
    }
    // X軸はMM/ddの値で設定
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(oneDay * fromDay) length:CPTDecimalFromFloat(oneDay*days)];
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
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];  // 軸固定
    
    // Y軸のメモリ・ラベルなどの設定
    //Y軸は0〜1.0の値で設定
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.2f) length:CPTDecimalFromInt(1)];
    CPTXYAxis *y = axisSet.yAxis;
    y.axisLineStyle               = lineStyle;      // Y軸の線にラインスタイルを適用
    y.majorTickLineStyle          = lineStyle;      // Y軸の大きいメモリにラインスタイルを適用
    y.minorTickLineStyle          = lineStyle;      // Y軸の小さいメモリにラインスタイルを適用
    y.majorTickLength = 9.0f;                   // Y軸の大きいメモリの長さ
    y.minorTickLength = 5.0f;                   // Y軸の小さいメモリの長さ
    y.majorIntervalLength         = CPTDecimalFromFloat(0.5f);  // Y軸ラベルの表示間隔
    y.minorTicksPerInterval       = 4;  // 目盛りは0.1ごと(majorInterval中に4補助目盛りを追加)
    y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0.0f);  // Y軸のX位置
    y.title                       = @"";
    y.titleTextStyle = textStyle;
    y.titleRotation = M_PI*2;
    y.titleLocation               = CPTDecimalFromFloat(1.2f);
    y.titleOffset                 = 1.5f;
    lineStyle.lineWidth = 0.5f;
    y.majorGridLineStyle = lineStyle;
    y.labelTextStyle = textStyle;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];  // 軸固定
    
    for (CPTScatterPlot *plot in [graph allPlots]) {
        [graph removePlot:plot];
    }
    for (int i = 0; i < selectedEventIdList.count; i++) {
        // 折れ線グラフのインスタンスを生成
        CPTScatterPlot *scatterPlot = [[CPTScatterPlot alloc] init];
        scatterPlot.delegate        = self;
        scatterPlot.identifier      = [NSString stringWithFormat:@"%d",i];;    // 折れ線グラフを識別するために識別子を設定
        scatterPlot.dataSource      = self;     // 折れ線グラフのデータソースを設定
        scatterPlot.title = [selectedEventNameList objectAtIndex:i];
        scatterPlot.plotSymbolMarginForHitDetection = 30.0f;
        
        // 折れ線グラフのスタイルを設定
        CPTMutableLineStyle *graphlineStyle = [scatterPlot.dataLineStyle mutableCopy];
        graphlineStyle.lineWidth = 3;                    // 太さ
        graphlineStyle.lineColor = [CPTColor colorWithComponentRed:(float)(rand()%1000)/1000 green:(float)(rand()%1000)/1000 blue:(float)(rand()%1000)/1000 alpha:1.0f];// 色
        scatterPlot.dataLineStyle = graphlineStyle;
        
        // グラフに折れ線グラフを追加
        [graph addPlot:scatterPlot];
    }
    
    
    theLegend = [CPTLegend legendWithGraph:graph];
    // 凡例の列数を指定
    theLegend.numberOfColumns = 3;
    // 凡例の表示部分の背景色を指定
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    // 凡例の外枠線の表示をする
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    // 凡例の外枠線の角丸の程度
    theLegend.cornerRadius = 5.0;
    
    // 作成した凡例をグラフに追加
    graph.legend = theLegend;
    
    // 凡例の位置をグラフの下側に設定
    // (他にもCPTRectAnchor...で上側や右側などいろいろな場所に配置可能)
    graph.legendAnchor = CPTRectAnchorTopRight;
    // 凡例の位置を調整
    graph.legendDisplacement = CGPointMake(0, -65);
    

}

-(CPTPlotSymbol *)symbolForScatterPlot:(CPTScatterPlot *)plot recordIndex:(NSUInteger)idx
{
    NSArray *plotData = [plotDataList objectAtIndex:[(NSString * )plot.identifier intValue]];
    if ([[[plotData objectAtIndex:idx] allKeys] containsObject:@"recordIndex"]) {
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
    NSArray *plotData = [plotDataList objectAtIndex:[(NSString *)plot.identifier intValue]];
    NSNumber *recordIndex = [[plotData objectAtIndex:idx] objectForKey:@"recordIndex"];
    if (recordIndex) {
        NSNumber *x = [[plotData objectAtIndex:idx] objectForKey:@"x"];
        NSNumber *y = [[plotData objectAtIndex:idx] objectForKey:@"y"];
        
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
        
        Record *r = [[recordsArray objectAtIndex:[(NSString *)plot.identifier intValue]] objectAtIndex:recordIndex.intValue];
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
    NSArray *records = [RecordPeer getRecordsByEventId:event_id];
    [recordsArray addObject:records];
    
    NSMutableArray *analizeRecords = [NSMutableArray array];

    double bestRecord = 0;
    int category_id = [[records firstObject] category_id];
    for (Record *r in records) {
        if (bestRecord == 0) {
            bestRecord = r.record;
        }
        if (((category_id < 4)&&(r.record < bestRecord))||
            ((category_id > 3)&&(r.record > bestRecord))) {
            // 時間競技で　　　　　かつ　より小さい記録　　　　　　　　　　　又は
            // 距離競技で　　　　　かつ　より大きい記録　　　　　　　　　　　の場合
            bestRecord = r.record;
        }
    }
    
    if (bestRecord == 0) bestRecord = 1.0;
    
    for (Record *r in records) {
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        if (category_id < 4) {
            [data setObject:[NSNumber numberWithDouble:(pow(bestRecord/r.record,9))] forKey:@"record"];
        } else {
            [data setObject:[NSNumber numberWithDouble:(pow(r.record/bestRecord,5))] forKey:@"record"];
        }
        [data setObject:r.date forKey:@"date"];
        [analizeRecords addObject:data];
    }
    
    if (firstDate == nil) {
        firstDate = [[analizeRecords firstObject] objectForKey:@"date"];
    } else {
        firstDate = [firstDate earlierDate:[[analizeRecords firstObject] objectForKey:@"date"]];
    }
    if (lastDate == nil) {
        lastDate = [[analizeRecords lastObject] objectForKey:@"date"];
    } else {
        lastDate = [lastDate laterDate:[[analizeRecords lastObject] objectForKey:@"date"]];
    }
    
    
    [analizeRecordsList addObject:analizeRecords];
    
    NSMutableArray *plotData = [NSMutableArray array];
    NSNumber *preX = [NSNumber numberWithDouble:0.0];
    NSNumber *preY = [[analizeRecords objectAtIndex:0] objectForKey:@"record"];
    NSNumber *recordInx = [NSNumber numberWithInt:0];
    [plotData addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:preX, @"x", preY, @"y", recordInx, @"recordIndex", nil]];
    
    NSDate *preDate = [[analizeRecords objectAtIndex:0] objectForKey:@"date"];
    NSTimeInterval oneDay = 24.0f*60.0f*60.0f;
    for (int i = 1; i < analizeRecords.count; i++) {
        NSTimeInterval timeI = [[[analizeRecords objectAtIndex:i] objectForKey:@"date"] timeIntervalSinceDate:preDate];
        int dateLag = (int)timeI / oneDay;
        for (int day = 1; day < dateLag; day++) {
            preX = [NSNumber numberWithDouble:(preX.doubleValue + oneDay)];
            NSNumber *y = [NSNumber numberWithDouble:(preY.doubleValue + (day * ([[[analizeRecords objectAtIndex:i] objectForKey:@"record"] doubleValue] - preY.doubleValue) / dateLag))];
            [plotData addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:preX, @"x", y, @"y", nil]];
        }
        preX = [NSNumber numberWithDouble:(preX.doubleValue + oneDay)];
        preY = [[analizeRecords objectAtIndex:i] objectForKey:@"record"];
        recordInx = [NSNumber numberWithInt:i];
        [plotData addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:preX, @"x", preY, @"y", recordInx, @"recordIndex", nil]];
        preDate = [[analizeRecords objectAtIndex:i] objectForKey:@"date"];
    }
    
    [plotDataList addObject:plotData];
}

@end
