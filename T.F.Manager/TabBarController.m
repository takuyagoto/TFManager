//
//  TabBarController.m
//  Training Log
//
//  Created by Takuya on 2014/05/19.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

@synthesize logTableViewController;
@synthesize selectFigItemTableViewController;
@synthesize recordPlotTableViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setupTabBar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupTabBar
{
    
    
    logTableViewController = [[LogTableViewController alloc] init];
    selectFigItemTableViewController = [[SelectFigItemTableViewController alloc] init];
    recordPlotTableViewController = [[RecordPlotTableViewController alloc] init];
    
    [logTableViewController setTitle:@"練習日"];
    [selectFigItemTableViewController setTitle:@"バロメータ"];
    [recordPlotTableViewController setTitle:@"グラフ"];
    
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -1)];
    
    UINavigationController *logNavi = [[UINavigationController alloc] initWithRootViewController:logTableViewController];
    [logNavi setTitle:@"リスト"];
    logNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"リスト"
                                                       image:[[UIImage imageNamed:@"non_list.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                selectedImage:[[UIImage imageNamed:@"list.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *selectFigNavi = [[UINavigationController alloc] initWithRootViewController:selectFigItemTableViewController];
    selectFigNavi.navigationItem.rightBarButtonItem = self.editButtonItem;
    selectFigNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"バロメータ"
                                                       image:[[UIImage imageNamed:@"non_chart.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                               selectedImage:[[UIImage imageNamed:@"chart.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *recordPltNavi = [[UINavigationController alloc] initWithRootViewController:recordPlotTableViewController];
    recordPltNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"グラフ"
                                                             image:[[UIImage imageNamed:@"non_recordChart.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                     selectedImage:[[UIImage imageNamed:@"recordChart.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self setViewControllers:[NSArray arrayWithObjects:logNavi, recordPltNavi, selectFigNavi, nil] animated:NO];
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

@end
