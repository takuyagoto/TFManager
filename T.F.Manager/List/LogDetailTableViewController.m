//
//  LogDetailTableViewController.m
//  Training Log
//
//  Created by Takuya on 2014/06/10.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "LogDetailTableViewController.h"

@interface LogDetailTableViewController ()
{
    NSArray *records;
    InputViewController *inputVC;
    UIViewController *rootVC;
}
@end

@implementation LogDetailTableViewController

@synthesize date;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    records = [RecordPeer getRecordsByDate:date];
    if (records == nil) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    self.navigationItem.rightBarButtonItem = [self editButtonItem];
    [self setEditing:NO];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (date == nil) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (records == nil) return 0;
    return [records count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifer"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifer"];
    }
    
    Record *r = [records objectAtIndex:indexPath.row];
    NSString *title;
    if (r.category_id == 7) {
        title = [NSString stringWithFormat:@"その他:%@",[r getEventName]];
    } else {
        title = [NSString stringWithFormat:@"%@:%@  %d本目:%@",[r getCategoryName],[r getEventName],r.no,[r getRecordString]];
    }
    cell.textLabel.text = title;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Record *rec = [records objectAtIndex:indexPath.row];
    if (inputVC == nil) {
        inputVC = [[InputViewController alloc] init];
    }
    if (rootVC == nil) {
        rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
        rootVC.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    [inputVC setLbTitle:@"編集"];
    [inputVC setRec:rec];
    [self presentViewController:inputVC animated:YES completion:nil];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:YES];
    
    if(editing){
        self.editButtonItem.title = @"Done";
    }else{
        self.editButtonItem.title = @"削除";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[records objectAtIndex:indexPath.row] deleteRecord];
        records = [RecordPeer getRecordsByDate:date];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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

@end
