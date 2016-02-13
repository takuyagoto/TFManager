//
//  InputDateViewController.m
//  Training Log
//
//  Created by Takuya on 2014/05/20.
//  Copyright (c) 2014年 Takuya. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController ()
{
    UILabel *titleLb;
    UIButton *cancelBtn;
    UIButton *clearBtn;
    
    UIButton *dateBtn;
    UIButton *categoryBtn;
    UIButton *eventBtn;
    UIButton *addEventBtn;
    UIButton *noBtn;
    UIButton *recordBtn;
    UIButton *subNoBtn;
    UIButton *addNoBtn;
    
    DatePickerViewController *dpVC;
    CategoryPickerViewController *cpVC;
    EventPickerViewController *epVC;
    AddEventViewController *addEVC;
    RecordPickerViewController *rpVC;
    
    UIAlertView *savedAV;
    UIAlertView *validateAV;
}

@end

@implementation InputViewController

@synthesize rec;
@synthesize lbTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    rec = [[Record alloc] init];
    unit = 0;
    
    float origin_x = 70;
    float height = (self.view.frame.size.height - origin_x - 50)/4;
    float viewWidth = self.view.frame.size.width;
    
    if (titleLb == nil) {
        UILabel *naviBarLb = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, viewWidth+10, origin_x)];
        naviBarLb.backgroundColor = [UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1.0];
        naviBarLb.layer.borderColor = [UIColor lightGrayColor].CGColor;
        naviBarLb.layer.borderWidth = 0.5;
        [self.view addSubview:naviBarLb];
        titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, viewWidth, origin_x-10)];
        titleLb.font = [UIFont boldSystemFontOfSize:17];
        titleLb.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:titleLb];
    }
    
    if (cancelBtn == nil) {
        cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelBtn.frame = CGRectMake(0, 10, 90, origin_x-10);
        [cancelBtn setTitle:@"キャンセル" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancelBtn];
    }
    
    if (clearBtn == nil) {
        clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        clearBtn.frame = CGRectMake(viewWidth-origin_x, 10, 90, origin_x-10);
        [clearBtn setTitle:@"クリア" forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:clearBtn];
    }
    
    UILabel *dateLable = [[UILabel alloc] initWithFrame:CGRectMake(0, origin_x, 100, 30)];
    dateLable.font = [UIFont systemFontOfSize:15.];
    dateLable.text = @"練習日：";
    dateLable.textAlignment = NSTextAlignmentRight;
    dateLable.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dateLable];
    
    dateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    dateBtn.frame = CGRectMake(0, 70, viewWidth, height-30);
    dateBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    [dateBtn setTitle:[rec getDateString] forState:UIControlStateNormal];
    [dateBtn addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dateBtn];
    
    UILabel *categoryLable = [[UILabel alloc] initWithFrame:CGRectMake(0, origin_x+height, 100, 30)];
    categoryLable.font = [UIFont systemFontOfSize:15.];
    categoryLable.text = @"カテゴリー：";
    categoryLable.textAlignment = NSTextAlignmentRight;
    categoryLable.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:categoryLable];
    
    categoryBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    categoryBtn.frame = CGRectMake(0, 70+height, viewWidth, height-30);
    categoryBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    [categoryBtn addTarget:self action:@selector(showCategoryPicker:) forControlEvents:UIControlEventTouchUpInside];
    [categoryBtn setTitle:@"選択してください" forState:UIControlStateNormal];
    [self.view addSubview:categoryBtn];
    
    UILabel *eventLable = [[UILabel alloc] initWithFrame:CGRectMake(0, origin_x+height*2, 100, 30)];
    eventLable.font = [UIFont systemFontOfSize:15.];
    eventLable.text = @"種目：";
    eventLable.textAlignment = NSTextAlignmentRight;
    eventLable.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:eventLable];
    
    eventBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    eventBtn.frame = CGRectMake(0, 10+origin_x+height*2, viewWidth-50, height-30);
    eventBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    [eventBtn addTarget:self action:@selector(showEventPicker:) forControlEvents:UIControlEventTouchUpInside];
    [eventBtn setTitle:@"選択してください" forState:UIControlStateNormal];
    [self.view addSubview:eventBtn];
    
    addEventBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addEventBtn.frame = CGRectMake(viewWidth-50, 10+origin_x+height*2, 50, height-30);
    [addEventBtn addTarget:self action:@selector(showAdd:) forControlEvents:UIControlEventTouchUpInside];
    [addEventBtn setTitle:@"" forState:UIControlStateNormal];
    [self.view addSubview:addEventBtn];
    
    UILabel *recordLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 60+height*3, 100, 30)];
    recordLable.font = [UIFont systemFontOfSize:15.];
    recordLable.text = @"記録：";
    recordLable.textAlignment = NSTextAlignmentRight;
    recordLable.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:recordLable];
    
    subNoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    subNoBtn.frame = CGRectMake(0, 20+origin_x+height*3, viewWidth/3, (height-30)/3);
    subNoBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    [subNoBtn addTarget:self action:@selector(subNo:) forControlEvents:UIControlEventTouchUpInside];
    [subNoBtn setTitle:@"-" forState:UIControlStateNormal];
    [subNoBtn setTitle:@"" forState:UIControlStateDisabled];
    [subNoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    subNoBtn.enabled = NO;
    subNoBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:subNoBtn];

    noBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    noBtn.frame = CGRectMake(0, 20+origin_x+height*3+(height-30)/3, viewWidth/3, (height-30)/3);
    noBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    [noBtn setTitle:@"1本目" forState:UIControlStateNormal];
    [noBtn setTitle:@"" forState:UIControlStateDisabled];
    noBtn.enabled = NO;
    [self.view addSubview:noBtn];
    
    addNoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addNoBtn.frame = CGRectMake(0, 90+height*3+2*(height-30)/3, viewWidth/3, (height-30)/3);
    addNoBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    [addNoBtn addTarget:self action:@selector(addNo:) forControlEvents:UIControlEventTouchUpInside];
    [addNoBtn setTitle:@"+" forState:UIControlStateNormal];
    [addNoBtn setTitle:@"" forState:UIControlStateDisabled];
    [addNoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    addNoBtn.enabled = NO;
    addNoBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addNoBtn];
    
    recordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    recordBtn.frame = CGRectMake(viewWidth/3, 20+origin_x+height*3, viewWidth/2, height-30);
    recordBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    recordBtn.titleLabel.numberOfLines = 0;
    recordBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [recordBtn setTitle:@"" forState:UIControlStateDisabled];
    [recordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [recordBtn setTitle:@"記録入力" forState:UIControlStateNormal];
    [recordBtn addTarget:self action:@selector(showRecordPicker:) forControlEvents:UIControlEventTouchUpInside];
    recordBtn.enabled = NO;
    [self.view addSubview:recordBtn];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame = CGRectMake(0, origin_x+height*4, self.view.frame.size.width, 50);
    [submitButton setTitle:@"保存" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:submitButton];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (lbTitle == nil) {
        self.title = @"新規入力";
    }
    if (rec.Id > 0) {
        [clearBtn setTitle:@"削除" forState:UIControlStateNormal];
        [dateBtn setTitle:[rec getDateString] forState:UIControlStateNormal];
        [categoryBtn setTitle:[rec getCategoryName] forState:UIControlStateNormal];
        [eventBtn setTitle:[rec getEventName] forState:UIControlStateNormal];
        unit = [rec getUnit];
        [self updateNo];
        if (rec.category_id < 7) {
            recordBtn.enabled = YES;
        }
        [self updateRecordBtn];
    } else {
        [clearBtn setTitle:@"クリア" forState:UIControlStateNormal];
    }
    titleLb.text = lbTitle;
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

- (void) resetEventBtn
{
    [rec setEventId:0];
    [eventBtn setTitle:@"選択してください" forState:UIControlStateNormal];
}

- (void) resetRecordUI
{
    if (unit < 4 && unit > 0) {
        noBtn.enabled = YES;
        recordBtn.enabled = YES;
        [rec setNo:1];
        [rec setRecord:0];
    } else {
        noBtn.enabled = NO;
        recordBtn.enabled = NO;
        [rec setNo:0];
        [rec setRecord:0];
    }
    [recordBtn setTitle:@"" forState:UIControlStateDisabled];
    [recordBtn setTitle:@"記録入力" forState:UIControlStateNormal];
    [self updateNo];
}

- (void)updateRecordBtn
{
    if (unit < 4 && unit > 0) {
        NSString *recordStr = [rec getRecordString];
        [recordBtn setTitle:recordStr forState:UIControlStateNormal];
        return;
    }
    else {
        [rec setRecord:0];
        [recordBtn setTitle:@"記録入力" forState:UIControlStateNormal];
        [recordBtn setTitle:@"" forState:UIControlStateDisabled];
        return;
    }
}

- (void) updateNo
{
    if (rec.no == 1) {
        addNoBtn.enabled = YES;
        subNoBtn.enabled = NO;
        noBtn.enabled = YES;
    }
    else if (rec.no == 0) {
        addNoBtn.enabled = NO;
        subNoBtn.enabled = NO;
        noBtn.enabled = NO;
    }
    else {
        addNoBtn.enabled = YES;
        subNoBtn.enabled = YES;
        noBtn.enabled = YES;
    }
    [noBtn setTitle:[NSString stringWithFormat:@"%d本目",rec.no] forState:UIControlStateNormal];
}

- (void) showDatePicker:(UIButton *)btn
{
    if (dpVC == nil) {
        dpVC = [[DatePickerViewController alloc] init];
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        dpVC.delegate = self;
    }
    [dpVC setDate:[rec date]];
    [self presentViewController:dpVC animated:YES completion:nil];
}

- (void)selectDate:(NSDate *)date
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [rec setDate:date];
    [dateBtn setTitle:[rec getDateString] forState:UIControlStateNormal];
}

- (void) showCategoryPicker:(UIButton *)btn
{
    if (cpVC == nil) {
        cpVC = [[CategoryPickerViewController alloc] init];
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        cpVC.delegate = self;
    }
    [cpVC setCategory_id:[rec category_id]];
    [self presentViewController:cpVC animated:YES completion:nil];
}

- (void)selectCategory:(int)category_id name:(NSString *)category_name unit:(int)unit_
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [rec setCategoryId:category_id];
    [categoryBtn setTitle:category_name forState:UIControlStateNormal];
    unit = unit_;
    [self resetEventBtn];
    [self resetRecordUI];
    [self updateNo];
}

- (void) showEventPicker:(UIButton *)btn
{
    if (epVC == nil) {
        epVC = [[EventPickerViewController alloc] init];
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        epVC.delegate = self;
    }
    [epVC setCategory_id:[rec category_id]];
    [epVC setEvent_id:[rec event_id]];
    [self presentViewController:epVC animated:YES completion:nil];
}

- (void) selectEvent:(int)event_id name:(NSString *)event_name
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [rec setEventId:event_id];
    [eventBtn setTitle:event_name forState:UIControlStateNormal];
    [self resetRecordUI];
}

- (void)showAdd:(UIButton *)btn
{
    if (addEVC == nil ) {
        addEVC = [[AddEventViewController alloc] init];
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    [addEVC setCategory_id:rec.category_id];
    [addEVC setCategory_name:[categoryBtn currentTitle]];
    [self presentViewController:addEVC animated:YES completion:nil];
}

- (void)subNo:(UIButton *)btn
{
    int no_ = rec.no;
    [rec setNo:--no_];
    [self updateNo];
}

- (void)addNo:(UIButton *)btn
{
    int no_ = rec.no;
    [rec setNo:++no_];
    [self updateNo];
}

- (void)showRecordPicker:(UIButton *)btn
{
    if (rpVC == nil) {
        rpVC = [[RecordPickerViewController alloc] init];
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        rpVC.delegate = self;
    }
    [rpVC setUnit:unit];
    [rpVC setRecord:[rec record]];
    [self presentViewController:rpVC animated:YES completion:nil];
}

- (void)selectRecord:(double)record
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [rec setRecord:record];
    [self updateRecordBtn];
}

- (void) submit:(UIButton *) btn
{
    if ([rec category_id] > 0 && [rec event_id] > 0) {
        if ([rec category_id] == 7) {
            [rec setNo:0];
            [rec setRecord:0];
        }
        [rec save];
        if (savedAV == nil) {
            savedAV = [[UIAlertView alloc] initWithTitle:@"記録を保存しました" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        [savedAV show];
        if (rec.category_id != 7) {
            int no = rec.no + 1;
            [rec setNo:no];
        }
        [self updateNo];
    } else {
        if (validateAV == nil) {
            validateAV = [[UIAlertView alloc] initWithTitle:@"全てを入力したください" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        [validateAV show];
    }
}

- (void)cancel:(UIButton *) btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clear:(UIButton *)btn
{
    if (rec.Id > 0) {
        // 削除
        UIAlertView *deleteAV = [[UIAlertView alloc] initWithTitle:@"削除しても良いですか?" message:nil delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"削除", nil];
        [deleteAV show];
    }
    else {
        [self clearAll];
    }
}

- (void)clearAll
{
    unit = 0;
    rec = [[Record alloc] init];
    [dateBtn setTitle:[rec getDateString] forState:UIControlStateNormal];
    [categoryBtn setTitle:@"選択してください" forState:UIControlStateNormal];
    [self resetEventBtn];
    [self resetRecordUI];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            // 削除
            [rec deleteRecord];
            [self clearAll];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
    }
    
}

@end
