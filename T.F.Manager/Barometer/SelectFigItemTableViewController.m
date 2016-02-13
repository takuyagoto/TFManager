//
//  SelectFigItemTableViewController.m
//  Training Log
//
//  Created by Takuya on 2014/05/20.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "SelectFigItemTableViewController.h"

@interface SelectFigItemTableViewController ()
{
    UIBarButtonItem *inputBtn;
    InputViewController *inputVC;
    UIViewController *rootVC;
    
    
    NSMutableDictionary *selectedIndexList;
    int selectCount;
    
    UIActionSheet *showAS;
    UIAlertView *showAlert;
    UIBarButtonItem *showButton;
    UIBarButtonItem *clearButton;
}
@end

@implementation SelectFigItemTableViewController

@synthesize eventDic;
@synthesize cVC;

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
    
    selectedIndexList = [NSMutableDictionary dictionary];
    selectCount = 0;
    
    inputBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(editInput)];
    self.navigationItem.rightBarButtonItem = inputBtn;
    
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                               target:nil action:nil];
    
    showButton = [[UIBarButtonItem alloc] initWithTitle:@"表示" style:UIBarButtonItemStyleBordered target:self action:@selector(showChart)];
    
    clearButton = [[UIBarButtonItem alloc] initWithTitle:@"クリア" style:UIBarButtonItemStyleBordered target:self action:@selector(selectClear)];
    
    NSArray *items =
    [NSArray arrayWithObjects:spacer, showButton, spacer, clearButton, spacer, nil];
    self.toolbarItems = items;
    
    self.tableView.allowsMultipleSelection = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
    eventDic = [RecordPeer getEventDic];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
    
    if ([[selectedIndexList objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]] containsObject:[NSString stringWithFormat:@"%d",indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    NSString *section = [NSString stringWithFormat:@"%d",indexPath.section];
    NSString *row = [NSString stringWithFormat:@"%d",indexPath.row];
    
    NSMutableArray *indexRowList = [selectedIndexList objectForKey:section];
    if (!indexRowList) {
        indexRowList = [NSMutableArray array];
        [indexRowList addObject:row];
        selectCount++;
    } else {
        if ([indexRowList containsObject:row]) {
            [indexRowList removeObject:row];
            selectCount--;
        } else {
            [indexRowList addObject:row];
            selectCount++;
        }
    }
    [selectedIndexList setObject:indexRowList forKey:section];
    
    [self.tableView reloadData];
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

- (void) showChart
{
    if (selectCount > 0) {
        if (showAS == nil) {
            showAS = [[UIActionSheet alloc] init];
            showAS.delegate = self;
            showAS.title = [NSString stringWithFormat:@"%d項目を表示します。よろしいですか。",selectedIndexList.count];
            [showAS addButtonWithTitle:@"表示"];
            [showAS addButtonWithTitle:@"キャンセル"];
            showAS.cancelButtonIndex = 1;
            showAS.destructiveButtonIndex = 0;
        }
        [showAS showFromBarButtonItem:showButton animated:YES];
    } else {
        if (showAlert == nil) {
            showAlert = [[UIAlertView alloc] initWithTitle:@"１項目以上選択してください"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil
                         ];
            
        }
        [showAlert show];
    }
}

- (void) selectClear
{
    [selectedIndexList removeAllObjects];
    selectCount = 0;
    [self.tableView reloadData];
}

-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
        {
            if (cVC == nil) {
                cVC = [[ChartViewController alloc] init];
            }
            
            NSMutableArray *eventIdList = [NSMutableArray array];
            NSMutableArray *eventNameList = [NSMutableArray array];
            
            for (NSString *section in [selectedIndexList allKeys]) {
                NSArray *rowArray = [selectedIndexList objectForKey:section];
                for (NSString *row in rowArray) {
                    NSNumber *selectedEventId = [[[eventDic objectForKey:[[eventDic allKeys] objectAtIndex:section.intValue]] objectAtIndex:row.intValue] objectForKey:@"id"];
                    NSString *selectedEventName = [[[eventDic objectForKey:[[eventDic allKeys] objectAtIndex:section.intValue]] objectAtIndex:row.intValue] objectForKey:@"name"];
                    [eventIdList addObject:selectedEventId];
                    [eventNameList addObject:selectedEventName];
                }
            }
            [cVC setSelectedEventIdList:eventIdList];
            [cVC setSelectedEventNameList:eventNameList];
            [self.navigationController pushViewController:cVC animated:YES];
            break;
        }
        case 1:
        default:
            break;
    }
    
}

@end
