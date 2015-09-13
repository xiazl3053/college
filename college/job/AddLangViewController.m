//
//  AddLangViewController.m
//  college
//
//  Created by xiongchi on 15/9/6.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "AddLangViewController.h"
#import "ResumeModel.h"
#import "Toast+UIView.h"
#import "RsMeSelectCell.h"
#import "RsMeTxtCell.h"
#import "UserInfo.h"

@interface AddLangViewController()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *pickerLevel;
    UIView *viewLevel;
    NSArray *aryLevel;
    
    UIPickerView *pickerType;
    UIView *viewType;
    NSArray *aryType;
    
    NSIndexPath *_indexPath;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) BOOL bAdding;
@property (nonatomic,strong) XLanguage *model;
@property (nonatomic,strong) ResumeModel *resume;

@end

@implementation AddLangViewController

-(id)initWithAdd:(ResumeModel *)model;
{
    self = [super init];
    
    _bAdding = YES;
    _resume = model;
    
    return self;
}

-(id)initWithModel:(XLanguage *)model
{
    self = [super init];
    
    _model = model;
    
    return self;
}

-(void)settingType
{
    NSInteger nRow = [pickerType selectedRowInComponent:0];
    
    NSString *strInfo=[aryType objectAtIndex:nRow];
    
    RsMeSelectCell *cell = (RsMeSelectCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [cell.txtName setText:strInfo];
    
    viewType.hidden = YES;
}

-(void)initPickerType
{
    viewType = [[UIView alloc] initWithFrame:self.view.bounds];
    UIView *headView = [[UIView alloc] initWithFrame:Rect(0, 0,kScreenSourchWidth, kScreenSourchHeight-254)];
    [headView setBackgroundColor:RGB(128, 128, 128)];
    [viewType addSubview:headView];
    headView.alpha = 0.5f;
    UIView *backView = [[UIView alloc] initWithFrame:Rect(0, kScreenSourchHeight-254 , kScreenSourchWidth, 254)];
    [viewType addSubview:backView];
    [backView setBackgroundColor:RGB(255, 255, 255)];
    
    UIButton *btnSex = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:btnSex];
    [btnSex setTitle:@"完成" forState:UIControlStateNormal];
    [btnSex setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    btnSex.titleLabel.font = XFONT(15);
    [btnSex addTarget:self action:@selector(settingType) forControlEvents:UIControlEventTouchUpInside];
    btnSex.frame = Rect(kScreenSourchWidth-50,0, 44,37);
    
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(0, 37, kScreenSourchWidth, 1)];
    [lblContent setBackgroundColor:[UIColor grayColor]];
    [backView addSubview:lblContent];
    
    pickerType = [[UIPickerView alloc] initWithFrame:Rect(0,38, kScreenSourchWidth, 216)];
    pickerType.delegate = self;
    pickerType.dataSource = self;
    
    aryType = [[NSArray alloc] initWithObjects:@"英语",@"法语",@"德语",@"粤语", nil];
    
    [backView addSubview:pickerType];
    
    [self.view addSubview:viewType];
    
    viewType.hidden = YES;
}

-(void)settingLevel
{
    NSInteger nRow = [pickerLevel selectedRowInComponent:0];
    
    NSString *strInfo=[aryLevel objectAtIndex:nRow];
    
    RsMeSelectCell *cell = (RsMeSelectCell *)[_tableView cellForRowAtIndexPath:_indexPath];
    
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
    [btnSex setTitle:@"完成" forState:UIControlStateNormal];
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
    
    aryLevel = [[NSArray alloc] initWithObjects:@"一般",@"良好",@"熟练",@"精通", nil];
    
    [backView addSubview:pickerLevel];
    
    [self.view addSubview:viewLevel];
    
    viewLevel.hidden = YES;
}



-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveStuhor
{
    RsMeSelectCell *cell = (RsMeSelectCell*) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    RsMeSelectCell *cell1 = (RsMeSelectCell*) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    RsMeSelectCell *cell2 = (RsMeSelectCell*) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    RsMeSelectCell *cell3 = (RsMeSelectCell*) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    RsMeTxtCell *cell4 = (RsMeTxtCell*) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    NSString *strType = cell.txtName.text;
    NSString *strChengdu = cell1.txtName.text;
    NSString *strWrite = cell2.txtName.text;
    NSString *strhear = cell3.txtName.text;
    NSString *strLevel = cell4.txtName.text;
    
    if(strType==nil || [strType isEqualToString:@""])
    {
        [self.view makeToast:@"请选择语言类别"];
        return;
    }
    
    if (strChengdu == nil || [strChengdu isEqualToString:@""]) {
        [self.view makeToast:@"请选择掌握程度"];
        return ;
    }
    
    if (strWrite == nil || [strWrite isEqualToString:@""]) {
        [self.view makeToast:@"请选择读写能力"];
        return ;
    }
    
    if (strhear == nil || [strhear isEqualToString:@""]) {
        [self.view makeToast:@"请选择听说能力"];
        return ;
    }
    
    if (_bAdding)
    {
        XLanguage *model = [[XLanguage alloc] init];
        model.strLevel = strLevel;
        model.strWrite = strWrite;
        model.strHear = strhear;
        model.strChengdu = strChengdu;
        model.strType = strType;
       
        [_resume.aryLang addObject:model];
    }
    else
    {
        _model.strLevel = strLevel;
        _model.strWrite = strWrite;
        _model.strHear = strhear;
        _model.strChengdu = strChengdu;
        _model.strType = strType;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_FOR_LANGUGE_VC object:nil];
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
        [self setTitleText:@"添加语言能力"];
    }
    else{
        [self setTitleText:@"修改语言能力"];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, kScreenSourchHeight-64)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    [self initPickerLevel];
    
    [self initPickerType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strAddEvalution = @"kAddSTUHORIDEINTIFIER";
    
    if (indexPath.row<4) {
        
        RsMeSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:strAddEvalution];
        if (cell==nil)
        {
            cell = [[RsMeSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strAddEvalution];
        }
        if (indexPath.row==0)
        {
            [cell.lblName setText:@"语言类别"];
            [cell.txtName setPlaceholder:@"请选择语言类别"];
            if (_model)
            {
                [cell.txtName setText:_model.strType];
            }
        }
        else if (indexPath.row==1)
        {
            [cell.lblName setText:@"掌握程度"];
            [cell.txtName setPlaceholder:@"请选择掌握程度"];
            if (_model)
            {
                [cell.txtName setText:_model.strChengdu];
            }
        }
        else if (indexPath.row==2)
        {
            [cell.lblName setText:@"读写能力"];
            [cell.txtName setPlaceholder:@"请选择读写能力"];
            if (_model)
            {
                [cell.txtName setText:_model.strWrite];
            }
        }
        else if (indexPath.row==3)
        {
            [cell.lblName setText:@"听说能力"];
            [cell.txtName setPlaceholder:@"请选择听说能力"];
            if (_model)
            {
                [cell.txtName setText:_model.strHear];
            }
        }
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
            [cell.lblName setText:@"级   别"];
            [cell.txtName setPlaceholder:@"请输入级别"];
            if (_model)
            {
                [cell.txtName setText:_model.strLevel];
            }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    if (indexPath.row>=1 && indexPath.row <=3)
    {
        viewLevel.hidden = NO;
        return ;
    }
    else if(indexPath.row==0){
        viewType.hidden = NO;
        return ;
    }
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


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView==pickerLevel)
    {
        return 1;
    }
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView==pickerLevel)
    {
        return aryLevel.count;
    }
    return aryType.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView==pickerLevel)
    {
        return [aryLevel objectAtIndex:row];
    }
    return [aryType objectAtIndex:row];
}

@end
