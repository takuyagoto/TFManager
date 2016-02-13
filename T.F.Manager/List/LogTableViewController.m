//
//  LogTableViewController.m
//  Training Log
//
//  Created by Takuya on 2014/05/20.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "LogTableViewController.h"

@interface LogTableViewController ()
{
    UIBarButtonItem *inputBtn;
    InputViewController *inputVC;
    UIViewController *rootVC;
    LogDetailTableViewController *ldTVC;
    DatePickerViewController *dpVC;
    
    NSArray *dateList;
}
@end

@implementation LogTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    inputBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(editInput)];
    self.navigationItem.rightBarButtonItem = inputBtn;
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
    self.navigationItem.leftBarButtonItem = searchBtn;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self tableReload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dateList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifer"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifer"];
    }
    
    cell.textLabel.text = [dateList objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ldTVC == nil) {
        ldTVC = [[LogDetailTableViewController alloc] init];
    }
    [ldTVC setDate:[Record getDateFromDateString:[dateList objectAtIndex:indexPath.row]]];
    [ldTVC setTitle:[dateList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:ldTVC animated:YES];
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

- (void)tableReload
{
    dateList = [RecordPeer getDateList];
    [self.tableView reloadData];
}

- (void)search
{
    if (dpVC == nil) {
        dpVC = [[DatePickerViewController alloc] init];
        if (rootVC == nil) rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
        rootVC.modalPresentationStyle = UIModalPresentationCurrentContext;
        dpVC.delegate = self;
    }
    [dpVC setDate:[NSDate date]];
    [self presentViewController:dpVC animated:YES completion:nil];
}

- (void)selectDate:(NSDate *)date
{
    [self dismissViewControllerAnimated:NO completion:nil];
    NSString *searchDate;
    for (NSString *dateStr in dateList) {
        if ([date compare:[Record getDateFromDateString:dateStr]] == NSOrderedDescending) {
            continue;
        } else {
            searchDate = dateStr;
            break;
        }
    }
    int row = 0;
    if (searchDate == nil) {
        row = dateList.count - 1;
    } else {
        row = [dateList indexOfObject:searchDate];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

@end
