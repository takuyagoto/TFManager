//
//  AddEventViewController.m
//  Training Log
//
//  Created by Takuya on 2014/06/08.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "AddEventViewController.h"

@interface AddEventViewController ()
{
    UIButton *categoryBtn;
    UITextField *tf;
    
    CategoryPickerViewController *cpVC;
}
@end

@implementation AddEventViewController

@synthesize category_name;
@synthesize category_id;
@synthesize name;

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
    float origin_y = self.view.frame.size.height/2 - 200;
    float origin_x = 40;
    float width = self.view.frame.size.width - 80;
    
    UILabel *categoryLable = [[UILabel alloc] initWithFrame:CGRectMake(origin_x, origin_y, width, 30)];
    categoryLable.font = [UIFont systemFontOfSize:12.];
    categoryLable.text = @"カテゴリー：";
    categoryLable.textAlignment = NSTextAlignmentLeft;
    categoryLable.backgroundColor = [UIColor grayColor];
    categoryLable.textColor = [UIColor whiteColor];
    [self.view addSubview:categoryLable];
    
    categoryBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    categoryBtn.backgroundColor = [UIColor whiteColor];
    categoryBtn.frame = CGRectMake(origin_x, origin_y+30, width, 50);
    categoryBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [categoryBtn addTarget:self action:@selector(showCategoryPicker:) forControlEvents:UIControlEventTouchUpInside];
    [categoryBtn setTitle:category_name forState:UIControlStateNormal];
    [self.view addSubview:categoryBtn];
    
    UILabel *eventLable = [[UILabel alloc] initWithFrame:CGRectMake(origin_x, origin_y+80, width, 30)];
    eventLable.font = [UIFont systemFontOfSize:12.];
    eventLable.text = @"新規種目名：";
    eventLable.textAlignment = NSTextAlignmentLeft;
    eventLable.backgroundColor = [UIColor grayColor];
    eventLable.textColor = [UIColor whiteColor];
    [self.view addSubview:eventLable];
    
    tf = [[UITextField alloc] initWithFrame:CGRectMake(origin_x, origin_y+110, width, 50)];
    tf.delegate = self;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.font = [UIFont systemFontOfSize:15];
    tf.placeholder = @"ここに入力してください";
    tf.returnKeyType = UIReturnKeyDone;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tf];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(origin_x, origin_y+160, width/2, 40);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"キャンセル" forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor darkGrayColor];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[cancelBtn layer] setBorderWidth:1.0f];
    [[cancelBtn layer] setBorderColor:[UIColor whiteColor].CGColor];
    [self.view addSubview:cancelBtn];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addBtn.frame = CGRectMake(origin_x+width/2, origin_y+160, width/2, 40);
    addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [addBtn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitle:@"追加" forState:UIControlStateNormal];
    addBtn.backgroundColor = [UIColor darkGrayColor];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[addBtn layer] setBorderWidth:1.0f];
    [[addBtn layer] setBorderColor:[UIColor whiteColor].CGColor];
    [self.view addSubview:addBtn];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [categoryBtn setTitle:category_name forState:UIControlStateNormal];
    tf.text = nil;
    name = nil;
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

-(BOOL)textFieldShouldEndEditing:(UITextField*)textField
{
    if ([textField.text length] > 0) {
        name = textField.text;
    } else {
        name = nil;
    }
    [tf resignFirstResponder];
    NSLog(@"%@",name);
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField*)textField
{
    if ([textField.text length] > 0) {
        name = textField.text;
    } else {
        name = nil;
    }
    [tf resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    name = nil;
    [tf resignFirstResponder];
    return YES;
}

- (void) showCategoryPicker:(UIButton *)btn
{
    if (cpVC == nil) {
        cpVC = [[CategoryPickerViewController alloc] init];
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        cpVC.delegate = self;
    }
    [cpVC setCategory_id:category_id];
    [self presentViewController:cpVC animated:YES completion:nil];
}

- (void)cancel:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)add:(UIButton *)btn
{
    if ([tf.text length] > 0) {
        name = tf.text;
    } else {
        name = nil;
    }
    if (category_id && name) {
        Event *e = [[Event alloc] init];
        [e setName:name];
        [e setCategoryId:category_id];
        [e save];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectCategory:(int)category_id_ name:(NSString *)category_name_ unit:(int)unit_
{
    category_id = category_id_;
    category_name = category_name_;
    [categoryBtn setTitle:category_name forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
