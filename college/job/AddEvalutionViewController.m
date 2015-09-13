//
//  AddEvalutionViewController.m
//  college
//
//  Created by xiongchi on 15/9/6.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "AddEvalutionViewController.h"

#import "UserInfo.h"
#import "ResumeModel.h"
#import "Toast+UIView.h"
#import "RsMeSelectCell.h"
#import "RsMeTxtCell.h"

@interface AddEvalutionViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    UIView *viewDate;
    NSIndexPath *_indexPath;
    UIPickerView *datePicker;
    UIPickerView *pickerLevel;
    UIView *viewLevel;
    NSArray *aryLevel;
    NSMutableArray *years;
    NSMutableArray *months;
    UIButton *btnNow;
    UITextField *txtTemp;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) BOOL bAdding;
@property (nonatomic,strong) XEducation *model;
@property (nonatomic,strong) ResumeModel *resume;

@end

@implementation AddEvalutionViewController

-(id)initWithAdd:(ResumeModel *)model;
{
    self = [super init];
    
    _bAdding = YES;
    _resume = model;
    
    return self;
}

-(id)initWithModel:(XEducation *)model
{
    self = [super init];
    
    _model = model;
    
    return self;
}


-(void)setTimeNow
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:2 inSection:0];
    
    RsMeSelectCell *cell = (RsMeSelectCell *)[_tableView cellForRowAtIndexPath:index];
    
    [cell.txtName setText:@"至今"];
    
    viewLevel.hidden = YES;
}

-(void)settingLevel
{
    NSInteger nRow = [pickerLevel selectedRowInComponent:0];
    
    NSString *strInfo=[aryLevel objectAtIndex:nRow];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:3 inSection:0];
    
    RsMeSelectCell *cell = (RsMeSelectCell *)[_tableView cellForRowAtIndexPath:index];
    
    [cell.txtName setText:strInfo];
    
    viewLevel.hidden = YES;
}

-(void)initPickerLevel
{
    viewLevel = [[UIView alloc] initWithFrame:self.view.bounds];
    UIView *headView = [[UIView alloc] initWithFrame:Rect(0, 0,kScreenSourchWidth, kScreenSourchHeight-254)];
    [headView setBackgroundColor:RGB(128, 128, 128)];
    [viewLevel addSubview:headView];
    headView.alpha = 0.5f;
    UIView *backView = [[UIView alloc] initWithFrame:Rect(0, kScreenSourchHeight-254 , kScreenSourchWidth, 254)];
    [viewLevel addSubview:backView];
    [backView setBackgroundColor:RGB(255, 255, 255)];
    
    UIButton *btnSex = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:btnSex];
    [btnSex setTitle:@"OK" forState:UIControlStateNormal];
    [btnSex setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    btnSex.titleLabel.font = XFONT(15);
    [btnSex addTarget:self action:@selector(settingLevel) forControlEvents:UIControlEventTouchUpInside];
    btnSex.frame = Rect(kScreenSourchWidth-50,0, 44,37);
    
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(0, 37, kScreenSourchWidth, 1)];
    [lblContent setBackgroundColor:[UIColor grayColor]];
    [backView addSubview:lblContent];
    
    pickerLevel = [[UIPickerView alloc] initWithFrame:Rect(0,38, kScreenSourchWidth, 216)];
    pickerLevel.delegate = self;
    pickerLevel.dataSource = self;
    
    aryLevel = [[NSArray alloc] initWithObjects:@"大专",@"本科",@"硕士",@"MBA",@"博士", nil];
    
    [backView addSubview:pickerLevel];
    
    [self.view addSubview:viewLevel];
    
    viewLevel.hidden = YES;
}

-(void)setDateInfo
{
    NSInteger nRowYear = [datePicker selectedRowInComponent:0];
    NSInteger nRowmonth = [datePicker selectedRowInComponent:1];
    
    NSString *strInfo = [NSString stringWithFormat:@"%@/%@",[years objectAtIndex:nRowYear],[months objectAtIndex:nRowmonth]];
    
    RsMeSelectCell *cell = (RsMeSelectCell *)[_tableView cellForRowAtIndexPath:_indexPath];
    
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
    
    btnNow = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:btnNow];
    [btnNow setTitle:@"至今" forState:UIControlStateNormal];
    [btnNow setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    btnNow.titleLabel.font = XFONT(15);
    [btnNow addTarget:self action:@selector(setTimeNow) forControlEvents:UIControlEventTouchUpInside];
    btnNow.frame = Rect(10,0, 44,37);

    
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

-(void)saveEducation
{
    RsMeTxtCell *cell = (RsMeTxtCell*) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    RsMeSelectCell *startCell = (RsMeSelectCell*) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    RsMeSelectCell *endCell = (RsMeSelectCell*) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    RsMeSelectCell *levelCell = (RsMeSelectCell*) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    NSString *strSchool = cell.txtName.text;
    NSString *strStart = startCell.txtName.text;
    
    NSString *strEnd = endCell.txtName.text;
    
    NSString *strLevel = levelCell.txtName.text;
    
    if(strSchool==nil || [strSchool isEqualToString:@""])
    {
        [self.view makeToast:@"学校名称不能为空"];
        
        return;
    }
    
    if (strStart == nil || [strStart isEqualToString:@""]) {
        [self.view makeToast:@"请设置入学日期"];
        return ;
    }
    
    if (strEnd == nil || [strEnd isEqualToString:@""]) {
        [self.view makeToast:@"请设置毕业日期"];
        return ;
    }
    
    if (strLevel == nil || [strLevel isEqualToString:@""]) {
        [self.view makeToast:@"请设置学历"];
        return ;
    }
    
    if (_bAdding)
    {
        XEducation *model = [[XEducation alloc] init];
        model.strLevel = strLevel;
        model.strSchool=strSchool;
        model.strStart = strStart;
        model.strEnd = strEnd;
        [_resume.aryEduca addObject:model];
    }
    else
    {
        _model.strLevel = strLevel;
        _model.strSchool = strSchool;
        _model.strStart = strStart;
        _model.strEnd = strEnd;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_FOR_EVALUTION_VC object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
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
    
    [btnSave addTarget:self action:@selector(saveEducation) forControlEvents:UIControlEventTouchUpInside];
    
    [self setRightBtn:btnSave];
    
    if (_bAdding)
    {
        [self setTitleText:@"添加教育经历"];
    }
    else{
        [self setTitleText:@"修改教育经历"];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, kScreenSourchHeight-64)];
   
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self initDateView];
    
    [self initPickerLevel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strAddEvalution = @"kAddEVALUTIONIDEINTIFIER";
    if (indexPath.row==0) {
        RsMeTxtCell *cell = [tableView dequeueReusableCellWithIdentifier:strAddEvalution];
        
        if (cell==nil)
        {
            cell = [[RsMeTxtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strAddEvalution];
        }
        [cell.lblName setText:@"学   校"];
        [cell.txtName setPlaceholder:@"请输入学校名称"];
        txtTemp = cell.txtName;
        cell.txtName.delegate = self;
        if (_model)
        {
            [cell.txtName setText:_model.strSchool];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        RsMeSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:strAddEvalution];
        if (cell==nil)
        {
            cell = [[RsMeSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strAddEvalution];
        }
        if (indexPath.row==1)
        {
            [cell.lblName setText:@"入学时间"];
            [cell.txtName setPlaceholder:@"请选择入门时间"];
            if (_model)
            {
                [cell.txtName setText:_model.strStart];
            }
        }
        else if(indexPath.row==2)
        {
            [cell.lblName setText:@"毕业时间"];
            [cell.txtName setPlaceholder:@"请选择毕业时间"];
            if (_model)
            {
                [cell.txtName setText:_model.strEnd];
            }
        }
        else if(indexPath.row == 3)
        {
            [cell.lblName setText:@"学历"];
            [cell.txtName setPlaceholder:@"请选择学历"];
            if (_model)
            {
                [cell.txtName setText:_model.strLevel];
            }
        }
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    if (indexPath.row==0) {
        return ;
    }
    else if(indexPath.row==1)
    {
        [datePicker selectRow:8 inComponent:1 animated:YES];
        btnNow.hidden = YES;
        viewDate.hidden = NO;
    }
    else if(indexPath.row==2)
    {
        [datePicker selectRow:6 inComponent:1 animated:YES];
        btnNow.hidden = NO;
        viewDate.hidden = NO;
    }
    else if(indexPath.row == 3)
    {
        viewLevel.hidden = NO;
    }
    [self closeKeyBoard];
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
    return aryLevel.count;
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
    return [aryLevel objectAtIndex:row];
}

-(void)closeKeyBoard
{
    if ([txtTemp isFirstResponder])
    {
        [txtTemp resignFirstResponder];
    }
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
