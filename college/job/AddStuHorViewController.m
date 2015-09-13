//
//  AddStuHorViewController.m
//  college
//
//  Created by xiongchi on 15/9/6.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "AddStuHorViewController.h"
#import "ResumeModel.h"
#import "Toast+UIView.h"
#import "RsMeSelectCell.h"
#import "RsMeTxtCell.h"
#import "UserInfo.h"

@interface AddStuHorViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView *viewDate;
    NSIndexPath *_indexPath;
    UIPickerView *datePicker;
    NSMutableArray *years;
    NSMutableArray *months;
    UIButton *btnNow;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) BOOL bAdding;
@property (nonatomic,strong) XStuHor *model;
@property (nonatomic,strong) ResumeModel *resume;

@end

@implementation AddStuHorViewController

-(id)initWithAdd:(ResumeModel *)model;
{
    self = [super init];
    
    _bAdding = YES;
    _resume = model;
    
    return self;
}

-(id)initWithModel:(XStuHor*)model
{
    self = [super init];
    
    _model = model;
    
    return self;
}
-(void)setDateInfo
{
    NSInteger nRowYear = [datePicker selectedRowInComponent:0];
    NSInteger nRowmonth = [datePicker selectedRowInComponent:1];
    
    NSString *strInfo = [NSString stringWithFormat:@"%@/%@",[years objectAtIndex:nRowYear],[months objectAtIndex:nRowmonth]];
    
    RsMeSelectCell *cell = (RsMeSelectCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [cell.txtName setText:strInfo];
    
    viewDate.hidden = YES;
    
}

-(void)initDateView
{
    viewDate = [[UIView alloc] initWithFrame:self.view.bounds];
    UIView *headView = [[UIView alloc] initWithFrame:Rect(0, 0,kScreenSourchWidth, kScreenSourchHeight-254)];
    [headView setBackgroundColor:RGB(128, 128, 128)];
    [viewDate addSubview:headView];
    headView.alpha = 0.5f;
    UIView *backView = [[UIView alloc] initWithFrame:Rect(0, kScreenSourchHeight-254 , kScreenSourchWidth, 254)];
    [viewDate addSubview:backView];
    [backView setBackgroundColor:RGB(255, 255, 255)];
    
    UIButton *btnDate = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:btnDate];
    [btnDate setTitle:@"完成" forState:UIControlStateNormal];
    [btnDate setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    btnDate.titleLabel.font = XFONT(15);
    [btnDate addTarget:self action:@selector(setDateInfo) forControlEvents:UIControlEventTouchUpInside];
    btnDate.frame = Rect(kScreenSourchWidth-50,0, 44,37);
    
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(0,37, kScreenSourchWidth, 1)];
    [lblContent setBackgroundColor:[UIColor grayColor]];
    [backView addSubview:lblContent];
    
    datePicker = [[UIPickerView alloc]initWithFrame:Rect(0, 38, kScreenSourchWidth, 216)];
    
    datePicker.delegate = self;
    datePicker.dataSource = self;
    
    NSDate *date = [NSDate date];
    
    if(years==nil)
    {
        years = [NSMutableArray array];
        for(int year = 2000; year <= date.year ; year++)
        {
            NSString *yearStr = [NSString stringWithFormat:@"%d", year];
            [years addObject:yearStr];
        }
    }
    
    if (months==nil)
    {
        months = [NSMutableArray array];
        
        for (int month=1; month < 12;month++)
        {
            NSString *monthStr = [NSString stringWithFormat:@"%d", month];
            [months addObject:monthStr];
        }
    }
    
    [backView addSubview:datePicker];
    
    [self.view addSubview:viewDate];
    viewDate.hidden = YES;
}

-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveStuhor
{
    RsMeSelectCell *cell = (RsMeSelectCell*) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    RsMeTxtCell *cell1 = (RsMeTxtCell*) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    RsMeTxtCell *cell2 = (RsMeTxtCell*) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    NSString *strTime = cell.txtName.text;
    NSString *strName = cell1.txtName.text;
    NSString *strLevel = cell2.txtName.text;
    
    if(strTime==nil || [strTime isEqualToString:@""])
    {
        [self.view makeToast:@"请选择时间"];
        return;
    }
    
    if (strName == nil || [strName isEqualToString:@""]) {
        [self.view makeToast:@"请输入名称"];
        return ;
    }
    
    if (_bAdding)
    {
        XStuHor *model = [[XStuHor alloc] init];
        if(strLevel==nil)
        {
            model.strLevel = @"";
        }
        else
        {
            model.strLevel = strLevel;
        }
        model.strName = strName;
        model.strTime = strTime;
        [_resume.aryStuHor addObject:model];
    }
    else
    {
        _model.strLevel = strLevel;
        _model.strName = strName;
        _model.strTime = strTime;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_FOR_STUHOR_VC object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateHighlighted];
    
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftBtn:btnBack];
    
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnSave setTitle:@"保存" forState:UIControlStateNormal];
    
    [btnSave setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    
    [btnSave setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
    
    btnSave.titleLabel.font = XFONT(12);
    
    [btnSave addTarget:self action:@selector(saveStuhor) forControlEvents:UIControlEventTouchUpInside];
    
    [self setRightBtn:btnSave];
    
    if (_bAdding)
    {
        [self setTitleText:@"添加学生奖励"];
    }
    else{
        [self setTitleText:@"修改学生奖励"];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, kScreenSourchHeight-64)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self initDateView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strAddEvalution = @"kAddSTUHORIDEINTIFIER";
    
    if (indexPath.row==0) {
        
        RsMeSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:strAddEvalution];
        if (cell==nil)
        {
            cell = [[RsMeSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strAddEvalution];
        }
        
        [cell.lblName setText:@"时   间"];
        [cell.txtName setPlaceholder:@"请选择时间"];
        if (_model)
        {
            [cell.txtName setText:_model.strTime];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        RsMeTxtCell *cell = [tableView dequeueReusableCellWithIdentifier:strAddEvalution];
        if (cell==nil)
        {
            cell = [[RsMeTxtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strAddEvalution];
        }
        if (indexPath.row==1)
        {
            [cell.lblName setText:@"奖   项"];
            [cell.txtName setPlaceholder:@"请输入奖项"];
            if (_model)
            {
                [cell.txtName setText:_model.strName];
            }
        }
        else if(indexPath.row==2)
        {
            [cell.lblName setText:@"级   别"];
            [cell.txtName setPlaceholder:@"请输入级别，如:A级"];
            if (_model)
            {
                [cell.txtName setText:_model.strLevel];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
//        btnNow.hidden = NO;
        viewDate.hidden = NO;
        return ;
    }
}
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView==datePicker)
    {
        return 2;
    }
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView==datePicker) {
        if (component==0)
        {
            return years.count;
        }
        else if(component==1)
        {
            return months.count;
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView==datePicker)
    {
        if (component==0)
        {
            return [years objectAtIndex:row];
        }
        else if(component==1)
        {
            return [months objectAtIndex:row];
        }
    }
    return nil;
}

-(void)closeKeyBoard
{
//    if ([txtTemp isFirstResponder])
//    {
//        [txtTemp resignFirstResponder];
//    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyBoard) name:MESSAGE_FOR_KEYBOARD_INFO object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_FOR_KEYBOARD_INFO object:nil];
}

@end
