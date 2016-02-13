//
//  CategoryPickerViewController.m
//  Training Log
//
//  Created by Takuya on 2014/06/08.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "CategoryPickerViewController.h"

@interface CategoryPickerViewController ()
{
    NSMutableArray *names;
    NSMutableArray *ids;
    NSMutableArray *units;
    NSArray *categories;
    UIPickerView *pv;
}
@end

@implementation CategoryPickerViewController

@synthesize category_id;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    names = [[NSMutableArray alloc] init];
    ids = [[NSMutableArray alloc] init];
    units = [[NSMutableArray alloc] init];
    
    categories = [CategoryPeer getAllCategories];
    
    for (Category_ *c in categories) {
        [names addObject:c.name];
        [ids addObject:[NSNumber numberWithInt:c.Id]];
        [units addObject:[NSNumber numberWithInt:c.unit]];
    }
    
    float origin_y = self.view.frame.size.height/2 - 125;
    float origin_x = 0;
    float width = self.view.frame.size.width;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.backgroundColor = [UIColor darkGrayColor];
    btn.frame = CGRectMake(origin_x, origin_y, width, 50);
    [btn setTitle:@"完了" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    pv = [[UIPickerView alloc] initWithFrame:CGRectMake(origin_x, origin_y+50, width, 200)];
    pv.backgroundColor = [UIColor whiteColor];
    pv.delegate = self;
    pv.dataSource = self;
    if (category_id > 0) {
        [pv selectRow:(category_id-1) inComponent:0 animated:YES];
    } else {
        [pv selectRow:0 inComponent:0 animated:YES];
    }
    [self.view addSubview:pv];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [names count];
}

-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [names objectAtIndex:row];
}

- (void)finish:(UIButton *)btn
{
    if ([_delegate respondsToSelector:@selector(selectCategory:name:unit:)]) {
        [_delegate selectCategory:[[ids objectAtIndex:[pv selectedRowInComponent:0]] intValue] name:[names objectAtIndex:[pv selectedRowInComponent:0]] unit:[[units objectAtIndex:[pv selectedRowInComponent:0]] intValue]];
    }
}

@end
