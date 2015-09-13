//
//  RsMeViewCOntroller.m
//  college
//
//  Created by xiongchi on 15/9/4.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "RsMeViewCOntroller.h"
#import "RsMeTxtCell.h"
#import "BaseService.h"
#import "UserInfo.h"
#import "Toast+UIView.h"
#import "ResumeModel.h"
#import "RsMeSelectCell.h"

@interface RsMeViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *pickerSex;
    UIDatePicker *datePicker;
    UIView *viewSex;
    UIView *viewDate;
    NSArray *arySex;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *aryTxt;
@property (nonatomic,strong) NSArray *arySelect;
@property (nonatomic,strong) ResumeModel *model;

@end

@implementation RsMeViewController

-(id)initWithModel:(ResumeModel *)model
{
    self = [super init];
    _model = model;
    return self;
}

-(void)settingSex
{
    NSInteger nRow = [pickerSex selectedRowInComponent:0];
    NSString *strInfo=nil;
    if (nRow == 0) {
        strInfo = @"男";
    }
    else
    {
        strInfo = @"女";
    }
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:1];
    
    RsMeSelectCell *cell = (RsMeSelectCell *)[_tableView cellForRowAtIndexPath:index];
    
    [cell.txtName setText:strInfo];
    
    viewSex.hidden = YES;
}

-(void)initPickerStamp
{
    viewSex = [[UIView alloc] initWithFrame:self.view.bounds];
    
    UIView *headView = [[UIView alloc] initWithFrame:Rect(0, 0,kScreenSourchWidth, kScreenSourchHeight-254)];
    [headView setBackgroundColor:RGB(128, 128, 128)];
    [viewSex addSubview:headView];
    headView.alpha = 0.5f;
    UIView *backView = [[UIView alloc] initWithFrame:Rect(0, kScreenSourchHeight-254 , kScreenSourchWidth, 254)];
    [viewSex addSubview:backView];
    [backView setBackgroundColor:RGB(255, 255, 255)];
    
    UIButton *btnSex = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:btnSex];
    [btnSex setTitle:@"OK" forState:UIControlStateNormal];
    [btnSex setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    btnSex.titleLabel.font = XFONT(15);
    [btnSex addTarget:self action:@selector(settingSex) forControlEvents:UIControlEventTouchUpInside];
    btnSex.frame = Rect(kScreenSourchWidth-50,0, 44,37);
    
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(0, 37, kScreenSourchWidth, 1)];
    [lblContent setBackgroundColor:[UIColor grayColor]];
    [backView addSubview:lblContent];
    
    pickerSex = [[UIPickerView alloc] initWithFrame:Rect(0,38, kScreenSourchWidth, 216)];
    pickerSex.delegate = self;
    pickerSex.dataSource = self;
    
    arySex = [[NSArray alloc] initWithObjects:@"男",@"女", nil];
    
    [backView addSubview:pickerSex];
    
    [self.view addSubview:viewSex];
    
    viewSex.hidden = YES;
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
    [btnDate setTitle:@"OK" forState:UIControlStateNormal];
    [btnDate setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    btnDate.titleLabel.font = XFONT(15);
    [btnDate addTarget:self action:@selector(setDateInfo) forControlEvents:UIControlEventTouchUpInside];
    btnDate.frame = Rect(kScreenSourchWidth-50,0, 44,37);
    
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(0,37, kScreenSourchWidth, 1)];
    [lblContent setBackgroundColor:[UIColor grayColor]];
    [backView addSubview:lblContent];
    
    datePicker = [[UIDatePicker alloc]initWithFrame:Rect(0, 38, kScreenSourchWidth, 216)];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *dateInfo = [fmt dateFromString:@"1970-01-01"];
    [datePicker setMinimumDate:dateInfo];
    [datePicker setMaximumDate:[NSDate date]];
    [backView addSubview:datePicker];
    
    [self.view addSubview:viewDate];
    viewDate.hidden = YES;
}

-(void)setDateInfo
{
    NSDate *date = datePicker.date;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *strInfo = [fmt stringFromDate:date];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:1];
    
    RsMeSelectCell *cell = (RsMeSelectCell *)[_tableView cellForRowAtIndexPath:index];
    
    [cell.txtName setText:strInfo];
    
    viewDate.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(242, 242, 242)];
    
    
    _aryTxt = [[NSArray alloc] initWithObjects:@"姓  名",@"手机号码",@"居住地",@"身份证",@"邮  箱", nil];
    
    _arySelect = [[NSArray alloc] initWithObjects:@"性  别",@"出生日期", nil];
    
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 74, kScreenSourchWidth, kScreenSourchHeight-74) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateHighlighted];
    
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftBtn:btnBack];
    
    [self setTitleText:@"修改个人信息"];
    
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnSave setTitle:@"保存" forState:UIControlStateNormal];
    
    [btnSave setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    
    [btnSave setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
    
    btnSave.titleLabel.font = XFONT(12);
    
    [btnSave addTarget:self action:@selector(saveResume) forControlEvents:UIControlEventTouchUpInside];
    
    [self setRightBtn:btnSave];
    
    [self initDateView];
    
    [self initPickerStamp];
    
}

-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return _aryTxt.count;
    }
    return _arySelect.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strRsMeIdentifier = @"RESUMEMEIDENTIFIER";
    static NSString *strRsMeTxtIdentifier = @"RSMETXTIDENTIFIER";
    if (indexPath.section==0)
    {
        RsMeTxtCell *cell = [_tableView dequeueReusableCellWithIdentifier:strRsMeIdentifier];
        if(cell==nil)
        {
            cell = [[RsMeTxtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strRsMeTxtIdentifier];
        }
        [cell.lblName setText:[_aryTxt objectAtIndex:indexPath.row]];
        UIColor *color = [UIColor grayColor];
        
        NSString *strPlace = [NSString stringWithFormat:@"请输入%@",[[_aryTxt objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@""]];
        cell.txtName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:strPlace attributes:@{NSForegroundColorAttributeName: color}];
        if (indexPath.row==1)
        {
            [cell.txtName setKeyboardType:UIKeyboardTypeNumberPad];
        }
        else if(indexPath.row==4)
        {
            [cell setLineFull];
        }
        if (_model)
        {
            switch (indexPath.row)
            {
                case 0:
                    [cell.txtName setText:_model.strName];
                    break;
                case 1:
                    [cell.txtName setText:_model.strMobile];
                    break;
                case 2:
                    [cell.txtName setText:_model.strAddress];
                    break;
                case 3:
                    [cell.txtName setText:_model.strCard];
                    break;
                case 4:
                    [cell.txtName setText:_model.strEmail];
                    break;
                default:
                    break;
            }
        }
        return cell;
    }
    RsMeSelectCell *cell = [_tableView dequeueReusableCellWithIdentifier:strRsMeIdentifier];
    if (cell==nil)
    {
        cell = [[RsMeSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strRsMeIdentifier];
    }
    
    [cell.lblName setText:[_arySelect objectAtIndex:indexPath.row]];
    if (indexPath.row==1)
    {
        [cell setLineFull];
    }
    if (_model)
    {
        switch (indexPath.row)
        {
            case 0:
                [cell.txtName setText:_model.strSex];
                break;
            case 1:
                [cell.txtName setText:_model.strBirthDay];
                break;
        }
    }
    
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        if (indexPath.row == 0)
        {
            viewSex.hidden = NO;
        }
        else
        {
            viewDate.hidden = NO;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:Rect(0,0, kScreenSourchWidth, 10)];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 9.5, kScreenSourchWidth, 0.2)];
    line1.backgroundColor = LINE_COLOR;
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 9.7, kScreenSourchWidth ,0.2)] ;
    line2.backgroundColor = [UIColor whiteColor];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [view addSubview:line1];
    [view addSubview:line2];
    
    return view;
}

#pragma mark pickerDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arySex objectAtIndex:row];
}

-(void)saveResume
{
    RsMeTxtCell *txtCell1 = (RsMeTxtCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    RsMeTxtCell *txtCell2 = (RsMeTxtCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    RsMeTxtCell *txtCell3 = (RsMeTxtCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    RsMeTxtCell *txtCell4 = (RsMeTxtCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    RsMeTxtCell *txtCell5 = (RsMeTxtCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    RsMeSelectCell *selectCell1 = (RsMeSelectCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    RsMeSelectCell *selectCell2 = (RsMeSelectCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    
//    NSString *strName = [txtCell1.txtName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *strMobilde = [txtCell2.txtName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *strAddress = [txtCell3.txtName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *strCard = [txtCell4.txtName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *strEmail = [txtCell5.txtName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSString *strSex = [selectCell1.txtName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *strBirthDay = [selectCell2.txtName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *strName = txtCell1.txtName.text ;
    NSString *strMobilde = txtCell2.txtName.text ;
    NSString *strAddress = txtCell3.txtName.text ;
    NSString *strCard = txtCell4.txtName.text ;
    NSString *strEmail = txtCell5.txtName.text ;
    
    NSString *strSex = selectCell1.txtName.text;
    NSString *strBirthDay = selectCell2.txtName.text;
    
    if ([strName isEqualToString:@""])
    {
        [self.view makeToast:@"姓名不能为空"];
        return ;
    }
    
    if ([strMobilde isEqualToString:@""]) {
        [self.view makeToast:@"手机不能为空"];
        return ;
    }
    
    if ([strAddress isEqualToString:@""]) {
        [self.view makeToast:@"地址不能为空"];
        return ;
    }
    
    if ([strSex isEqualToString:@""])
    {
        [self.view makeToast:@"性别不能为空"];
        return ;
    }
    
    if ([strBirthDay isEqualToString:@""])
    {
        [self.view makeToast:@"生日不能为空"];
        return ;
    }
    
    [self.view makeToastActivity];
    
    if (_model==nil)
    {
        //添加
        _model = [[ResumeModel alloc] init];
        _model.strName = strName;
        _model.strMobile = strMobilde;
        _model.strAddress = strAddress;
        if (![strCard isEqualToString:@""]) {
            _model.strCard = strCard;
        }
        if (![strEmail isEqualToString:@""]) {
            _model.strEmail = strEmail;
        }
        _model.strSex = strSex;
        _model.strBirthDay = strBirthDay;
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        _model.strCreateTime = [fmt stringFromDate:[NSDate date]];
        _model.strUpdTime = _model.strCreateTime;
        _model.strTitle = @"未命名的简历";
        [self addResume];
    }
    else
    {
        //修改
        _model.strName = strName;
        _model.strMobile = strMobilde;
        _model.strAddress = strAddress;
        if (![strCard isEqualToString:@""]) {
            _model.strCard = strCard;
        }
        if (![strEmail isEqualToString:@""]) {
            _model.strEmail = strEmail;
        }
        _model.strSex = strSex;
        _model.strBirthDay = strBirthDay;
        [self updateResume];
    }
    
}

-(NSDictionary*)getDict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_model.strName forKey:@"name"];
    [dict setObject:_model.strMobile forKey:@"mobile"];
    [dict setObject:_model.strAddress forKey:@"address"];
    if(_model.strJLId != nil)
    {
        [dict setObject:_model.strJLId forKey:@"jianliid"];
    }
    [dict setObject:[UserInfo sharedUserInfo].strUserId forKey:@"userid"];
    NSString *strSex = [_model.strSex isEqualToString:@"男"]?@"1":@"0";
    [dict setObject:strSex forKey:@"sex"];
   
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *strBirthDay = [NSString stringWithFormat:@"%.0f000",[[fmt dateFromString:_model.strBirthDay] timeIntervalSince1970]];
    [dict setObject:strBirthDay forKey:@"birthdate"];
    
    NSString *strCreateTime = [NSString stringWithFormat:@"%.0f000",[[fmt dateFromString:_model.strCreateTime] timeIntervalSince1970]];
    [dict setObject:strCreateTime forKey:@"createtime"];
    
    NSString *strUpdTime = [NSString stringWithFormat:@"%.0f000",[[fmt dateFromString:_model.strUpdTime] timeIntervalSince1970]];
    [dict setObject:strUpdTime forKey:@"updatetime"];
    
    if (_model.strCard!=nil && ![_model.strCard isEqualToString:@""])
    {
        [dict setObject:_model.strCard forKey:@"card"];
    }
 
    if (_model.strEmail!=nil && ![_model.strEmail isEqualToString:@""]) {
        [dict setObject:_model.strEmail forKey:@"email"];
    }
    
    [dict setObject:_model.strTitle forKey:@"title"];
    
    return dict;
}

-(void)updateResume
{
    NSString *strInfo = [NSString stringWithFormat:@"%@pub/updateJianLi?token=%@&",KHttpServer,[UserInfo sharedUserInfo].strToken];
    __weak RsMeViewController *__self = self;
    NSDictionary *parameters = [self getDict];
    
    [BaseService postJSONWithUrl:strInfo parameters:parameters success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        if([[dict objectForKey:@"status"] intValue]==200)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self.view hideToastActivity];
                [__self.view makeToast:@"修改成功"];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,1.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [__self dismissViewControllerAnimated:YES completion:nil];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self.view hideToastActivity];
                [__self.view makeToast:@"修改失败"];
            });
        }
        
    } fail:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.view hideToastActivity];
            [__self.view makeToast:@"修改失败"];
        });
    }];
}

-(void)addResume
{
    NSString *strInfo = [NSString stringWithFormat:@"%@pub/addJianLi?token=%@",KHttpServer,[UserInfo sharedUserInfo].strToken];
    
    NSDictionary *parameters = [self getDict];
   
    __weak RsMeViewController *__self = self;
    [BaseService postJSONWithUrl:strInfo parameters:parameters success:^(id responseObject)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        if([[dict objectForKey:@"status"] intValue]==200)
        {
            ResumeModel *resume = [[ResumeModel alloc] initWithDict:[dict objectForKey:@"jianli"]];
            [[UserInfo sharedUserInfo].aryResume addObject:resume];
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_FOR_RESUME_UPDATE_VC object:nil];
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__self.view hideToastActivity];
                [__self.view makeToast:@"添加成功"];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)1.5*NSEC_PER_SEC),dispatch_get_main_queue(),
            ^{
                [__self dismissViewControllerAnimated:YES completion:nil];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self.view hideToastActivity];
                [__self.view makeToast:@"保存失败"];
            });
        }
        
    } fail:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.view hideToastActivity];
            [__self.view makeToast:@"保存失败"];
        });
    }];
    
}

@end
