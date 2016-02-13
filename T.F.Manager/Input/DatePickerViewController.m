//
//  DatePickerViewController.m
//  Training Log
//
//  Created by Takuya on 2014/06/08.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()
{
    UIDatePicker *dp;
}
@end

@implementation DatePickerViewController

@synthesize delegate = _delegate;
@synthesize date;

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
    
    float origin_y = self.view.frame.size.height/2 - 125;
    float origin_x = 40;
    float width = self.view.frame.size.width - 80;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.backgroundColor = [UIColor darkGrayColor];
    btn.frame = CGRectMake(origin_x, origin_y, width, 50);
    [btn setTitle:@"完了" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    
    dp = [[UIDatePicker alloc] init];
    dp.datePickerMode = UIDatePickerModeDate;
    dp.frame = CGRectMake(origin_x, origin_y+50, width, 200);
    dp.backgroundColor = [UIColor whiteColor];
    dp.maximumDate = [NSDate date];
    [self.view addSubview:dp];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (date) {
        dp.date = date;
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)finish:(UIButton *)btn
{
    if ([_delegate respondsToSelector:@selector(selectDate:)]){
        [_delegate selectDate:dp.date];
    }
}

@end
