//
//  RecordPickerViewController.m
//  Training Log
//
//  Created by Takuya on 2014/06/09.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "RecordPickerViewController.h"

@interface RecordPickerViewController ()
{
    float origin_x1;
    float origin_x2;
    float origin_x3;
    
    UIButton *btn;
    
    UIPickerView *pv0;
    UIPickerView *pv1;
    UIPickerView *pv2;
    UIPickerView *pv3;
    float width1;
    float width2;
    float width3;
    
    UILabel *hourLabel;
    UILabel *minLabel;
    UILabel *secLabel;
    UILabel *mLabel;
    UILabel *kgLabel;
    UILabel *pointLabel;
    
    NSArray *numbers;
}
@end

@implementation RecordPickerViewController

@synthesize record;
@synthesize unit;
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
    
    numbers = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    
    float origin_y = self.view.frame.size.height/2 - 111;
    
    width1 = 300;
    width2 = 140;
    width3 = 220;
    
    origin_x1 = (self.view.frame.size.width-width1)/2;
    origin_x2 = (self.view.frame.size.width-width2)/2;
    origin_x3 = (self.view.frame.size.width-width3)/2;
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.backgroundColor = [UIColor darkGrayColor];
    btn.frame = CGRectMake(origin_x1, origin_y, width1, 50);
    [btn setTitle:@"完了" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    hourLabel =  [[UILabel alloc] initWithFrame:CGRectMake(origin_x1+60, origin_y+30, 20, 162)];
    hourLabel.font = [UIFont systemFontOfSize:15.];
    hourLabel.text = @"h";
    hourLabel.textAlignment = NSTextAlignmentCenter;
    hourLabel.textColor = [UIColor whiteColor];
    hourLabel.backgroundColor = [UIColor grayColor];
    
    minLabel =  [[UILabel alloc] initWithFrame:CGRectMake(origin_x1+140, origin_y+30, 20, 162)];
    minLabel.font = [UIFont systemFontOfSize:15.];
    minLabel.text = @"m";
    minLabel.textAlignment = NSTextAlignmentCenter;
    minLabel.textColor = [UIColor whiteColor];
    minLabel.backgroundColor = [UIColor grayColor];
    
    secLabel =  [[UILabel alloc] initWithFrame:CGRectMake(origin_x1+220, origin_y+30, 20, 162)];
    secLabel.font = [UIFont systemFontOfSize:15.];
    secLabel.text = @"s";
    secLabel.textAlignment = NSTextAlignmentCenter;
    secLabel.textColor = [UIColor whiteColor];
    secLabel.backgroundColor = [UIColor grayColor];
    
    mLabel =  [[UILabel alloc] initWithFrame:CGRectMake(origin_x2+60, origin_y+30, 20, 162)];
    mLabel.font = [UIFont systemFontOfSize:15.];
    mLabel.text = @"m";
    mLabel.textAlignment = NSTextAlignmentCenter;
    mLabel.textColor = [UIColor whiteColor];
    mLabel.backgroundColor = [UIColor grayColor];
    
    pointLabel =  [[UILabel alloc] initWithFrame:CGRectMake(origin_x3+120, origin_y+30, 20, 162)];
    pointLabel.font = [UIFont systemFontOfSize:15.];
    pointLabel.text = @".";
    pointLabel.textAlignment = NSTextAlignmentCenter;
    pointLabel.textColor = [UIColor whiteColor];
    pointLabel.backgroundColor = [UIColor grayColor];
    
    kgLabel =  [[UILabel alloc] initWithFrame:CGRectMake(origin_x3+200, origin_y+30, 20, 162)];
    kgLabel.font = [UIFont systemFontOfSize:15.];
    kgLabel.text = @"Kg";
    kgLabel.textAlignment = NSTextAlignmentCenter;
    kgLabel.textColor = [UIColor whiteColor];
    kgLabel.backgroundColor = [UIColor grayColor];
    
    pv3 = [[UIPickerView alloc] initWithFrame:CGRectMake(origin_x1, origin_y+50, 60, 162)];
    pv3.backgroundColor = [UIColor whiteColor];
    pv3.delegate = self;
    pv3.dataSource = self;
    
    pv2 = [[UIPickerView alloc] initWithFrame:CGRectMake(origin_x1, origin_y+50, 60, 162)];
    pv2.backgroundColor = [UIColor whiteColor];
    pv2.delegate = self;
    pv2.dataSource = self;
    
    pv1 = [[UIPickerView alloc] initWithFrame:CGRectMake(origin_x1, origin_y+50, 60, 162)];
    pv1.backgroundColor = [UIColor whiteColor];
    pv1.delegate = self;
    pv1.dataSource = self;
    
    pv0 = [[UIPickerView alloc] initWithFrame:CGRectMake(origin_x1, origin_y+50, 60, 162)];
    pv0.backgroundColor = [UIColor whiteColor];
    pv0.delegate = self;
    pv0.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    float origin_y = self.view.frame.size.height/2 - 81;
    
    [pv0 removeFromSuperview];
    [pv1 removeFromSuperview];
    [pv2 removeFromSuperview];
    [pv3 removeFromSuperview];
    [hourLabel removeFromSuperview];
    [minLabel removeFromSuperview];
    [secLabel removeFromSuperview];
    [mLabel removeFromSuperview];
    [pointLabel removeFromSuperview];
    [kgLabel removeFromSuperview];
    
    if (unit == 1) {
        // 時間
        pv3.frame = CGRectMake(origin_x1,origin_y,60,162);
        pv2.frame = CGRectMake(origin_x1+80,origin_y,60,162);
        pv1.frame = CGRectMake(origin_x1+160,origin_y,60,162);
        pv0.frame = CGRectMake(origin_x1+240,origin_y,60,162);
        [self.view addSubview:pv0];
        [self.view addSubview:pv1];
        [self.view addSubview:pv2];
        [self.view addSubview:pv3];
        [self.view addSubview:hourLabel];
        [self.view addSubview:minLabel];
        [self.view addSubview:secLabel];
        btn.frame = CGRectMake(origin_x1,origin_y-30,width1,30);
    }
    else if (unit == 2) {
        pv2.frame = CGRectMake(origin_x2,origin_y,60,162);
        pv1.frame = CGRectMake(origin_x2+80,origin_y,60,162);
        [self.view addSubview:pv1];
        [self.view addSubview:pv2];
        [self.view addSubview:mLabel];
        btn.frame = CGRectMake(origin_x2,origin_y-30,width2,30);
    }
    else if (unit == 3) {
        pv2.frame = CGRectMake(origin_x3,origin_y,60,162);
        pv1.frame = CGRectMake(origin_x3+60,origin_y,60,162);
        pv0.frame = CGRectMake(origin_x3+140,origin_y,60,162);
        [self.view addSubview:pv0];
        [self.view addSubview:pv1];
        [self.view addSubview:pv2];
        [self.view addSubview:pointLabel];
        [self.view addSubview:kgLabel];
        btn.frame = CGRectMake(origin_x3,origin_y-30,width3,30);
    }
    [self updatePvs];
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
/*
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
- (void)updatePvs
{
    switch (unit) {
        case 1:
            [pv0 selectRow:((int)(record*100)%100)%10 inComponent:1 animated:YES];
            [pv0 selectRow:((int)(record*100)%100)/10 inComponent:0 animated:YES];
            [pv1 selectRow:(int)(((int)record%60)%10) inComponent:1 animated:YES];
            [pv1 selectRow:(int)(((int)record%60)/10) inComponent:0 animated:YES];
            [pv2 selectRow:(int)((((int)record/60)%60)%10) inComponent:1 animated:YES];
            [pv2 selectRow:(int)((((int)record/60)%60)/10) inComponent:0 animated:YES];
            [pv3 selectRow:(int)((((int)record/60)/60)%10) inComponent:1 animated:YES];
            [pv3 selectRow:(int)((((int)record/60)/60)/10) inComponent:0 animated:YES];
            break;
        case 2:
            [pv1 selectRow:(int)(((int)record%100)%10) inComponent:1 animated:YES];
            [pv1 selectRow:(int)(((int)record%100)/10) inComponent:0 animated:YES];
            [pv2 selectRow:(int)(((int)record/100)%10) inComponent:1 animated:YES];
            [pv2 selectRow:(int)(((int)record/100)/10) inComponent:0 animated:YES];
            break;
        case 3:
            [pv0 selectRow:(int)(((int)record*100)%100)%10 inComponent:1 animated:YES];
            [pv0 selectRow:(int)(((int)record*100)%100)/10 inComponent:0 animated:YES];
            [pv1 selectRow:(int)(((int)record%100)%10) inComponent:1 animated:YES];
            [pv1 selectRow:(int)(((int)record%100)/10) inComponent:0 animated:YES];
            break;
                                 
                                 
        default:
            break;
    }
    
    [pv0 reloadAllComponents];
    [pv1 reloadAllComponents];
    [pv2 reloadAllComponents];
    [pv3 reloadAllComponents];
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

- (UIView *)pickerView:(UIPickerView *)pickerView  viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView*)view
{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20*component, 0, 25, [pickerView rowSizeForComponent:component].height)];
    lb.text = [numbers objectAtIndex:row];
    lb.font = [UIFont systemFontOfSize:20];
    lb.textAlignment = NSTextAlignmentCenter;
    return lb;
}

- (void)finish:(UIButton *)btn
{
    record = 0;
    record += [pv1 selectedRowInComponent:0]*10;
    record += [pv1 selectedRowInComponent:1];
    switch (unit) {
        case 1:
            record += (double)[pv0 selectedRowInComponent:0]/10;
            record += (double)[pv0 selectedRowInComponent:1]/100;
            record += [pv2 selectedRowInComponent:0]*600;
            record += [pv2 selectedRowInComponent:1]*60;
            record += [pv3 selectedRowInComponent:0]*36000;
            record += [pv3 selectedRowInComponent:1]*3600;
            break;
        case 2:
            record += [pv2 selectedRowInComponent:0]*1000;
            record += [pv2 selectedRowInComponent:1]*100;
            break;
        case 3:
            record += (double)[pv0 selectedRowInComponent:0]/10;
            record += (double)[pv0 selectedRowInComponent:1]/100;
            record += [pv2 selectedRowInComponent:0]*1000;
            record += [pv2 selectedRowInComponent:1]*100;
            break;
        default:
            record = 0;
            break;
    }
    if ([_delegate respondsToSelector:@selector(selectRecord:)]) {
        [_delegate selectRecord:record];
    }
}


@end
