//
//  RecordPlotTableViewController.m
//  Training Log
//
//  Created by Takuya on 2014/08/01.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "RecordPlotTableViewController.h"

@interface RecordPlotTableViewController ()
{
    UIBarButtonItem *inputBtn;
    InputViewController *inputVC;
    UIViewController *rootVC;
}
@end

@implementation RecordPlotTableViewController

@synthesize eventDic;
@synthesize recordChartVC;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    inputBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(editInput)];
    self.navigationItem.rightBarButtonItem = inputBtn;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    eventDic = [RecordPeer getEventDic];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (eventDic == nil) return 0;
    return [[eventDic allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (eventDic == nil) return 0;
    return [[eventDic objectForKey:[[eventDic allKeys] objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[eventDic allKeys] objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifer"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifer"];
    }
    
    cell.textLabel.text = [[[eventDic objectForKey:[[eventDic allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (recordChartVC == nil) {
        recordChartVC = [[RecordChartViewController alloc] init];
    }
    NSDictionary *e = [[eventDic objectForKey:[[eventDic allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [recordChartVC setSelectedEventId:[[e objectForKey:@"id"] intValue]];
    [recordChartVC setSelectedEventName:[e objectForKey:@"name"]];
    [self.navigationController pushViewController:recordChartVC animated:YES];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)editInput
{
    if (inputVC == nil) {
        inputVC = [[InputViewController alloc] init];
        if (rootVC == nil) rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
        rootVC.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    [inputVC setLbTitle:@"新規入力"];
    [self presentViewController:inputVC animated:YES completion:nil];
}

@end
