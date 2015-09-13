//
//  ResumeViewController.m
//  college
//
//  Created by xiongchi on 15/8/31.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "ResumeViewController.h"
#import "BaseService.h"
#import "QueryResumeViewController.h"
#import "ResumeHeadCell.h"
#import "ResumeEditViewController.h"
#import "ResumeModel.h"
#import "Toast+UIView.h"
#import "RsMeViewController.h"

#import "PubNotification.h"
#import "UserInfo.h"

@interface ResumeViewController()<UITableViewDataSource,UITableViewDelegate,ResumeHeadDelegate>
{
    ResumeModel *_model;
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ResumeViewController

//姓名:
//年龄:
//性别:
//身份证:
//出生年月
//email
//学校
//工作经历
//个人优势
//自我评价
//简历头像
//附件

-(void)initView
{
    [self setTitleText:@"我的简历"];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateHighlighted];
    
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftBtn:btnBack];
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnRight setTitle:@"创建" forState:UIControlStateNormal];
    
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btnRight setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
    
    [btnRight addTarget:self action:@selector(testEvent) forControlEvents:UIControlEventTouchUpInside];
    
    btnRight.titleLabel.font = XFONT(12);
    
    [self setRightBtn:btnRight];
}


-(void)testEvent
{
    if ([UserInfo sharedUserInfo].aryResume.count>=1)
    {
        ResumeModel *resume = [[ResumeModel alloc] init];
        ResumeModel *resumeOld = [[UserInfo sharedUserInfo].aryResume objectAtIndex:0];
        resume.strName = resumeOld.strName;
        resume.strSex = resumeOld.strSex;
        resume.strBirthDay = resumeOld.strBirthDay;
        resume.strEmail = resumeOld.strEmail;
        resume.strCard = resumeOld.strCard;
        resume.strAddress =resumeOld.strAddress;
        resume.strMobile = resumeOld.strMobile;
        
        ResumeEditViewController *editView = [[ResumeEditViewController alloc] initWithNewModel:resume];
        [self presentViewController:editView animated:YES completion:nil];
        return ;
    }
    ResumeEditViewController *editView = [[ResumeEditViewController alloc] init];
    [self presentViewController:editView animated:YES completion:nil];
}

-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateLoad
{
    __weak ResumeViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [__self.tableView reloadData];
    });
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLoad) name:MESSAGE_FOR_RESUME_UPDATE_VC object:nil];
    
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, kScreenSourchHeight-74) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionFooterHeight = 10.0;
    _tableView.sectionHeaderHeight = 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [UserInfo sharedUserInfo].aryResume.count==0?0:1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strResumeViewController = @"ResumeViewController";
    
    ResumeHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:strResumeViewController];
    
    if (cell==nil)
    {
        cell = [[ResumeHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strResumeViewController];
    }
    
    ResumeModel *model = [[UserInfo sharedUserInfo].aryResume objectAtIndex:indexPath.section];
    cell.delegate = self;
    
    [cell setResumeInfo:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeModel *resume = [[UserInfo sharedUserInfo].aryResume objectAtIndex:indexPath.section];
    QueryResumeViewController *queryView = [[QueryResumeViewController alloc] initWIthModel:resume];
    [self presentViewController:queryView animated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [UserInfo sharedUserInfo].aryResume.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if([UserInfo sharedUserInfo].aryResume.count==0)
    {
        return nil;
    }
    UIView *footView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenSourchWidth, 10)];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 9.5, kScreenSourchWidth, 0.2)];
    line1.backgroundColor = LINE_COLOR;
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 9.7, kScreenSourchWidth ,0.2)] ;
    line2.backgroundColor = [UIColor whiteColor];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [footView addSubview:line1];
    [footView addSubview:line2];
    
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(void)resumeEdit:(ResumeModel *)model
{
    ResumeEditViewController *editView = [[ResumeEditViewController alloc] initWithModel:model];
    
    [self presentViewController:editView animated:YES completion:nil];
}

-(void)resumeDelete:(ResumeModel *)model
{
    _model = model;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认删除此简历" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
    [alert show];

}

-(void)deleteResume
{
    NSString *strInfo = [NSString stringWithFormat:@"%@pub/deleteJianLi?jianliid=%@&token=%@&userid=%@",KHttpServer,
                         _model.strJLId,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId];
    __weak NSMutableArray *__aryMe = [UserInfo sharedUserInfo].aryResume;
    __weak ResumeViewController *__self = self;
    __weak ResumeModel *__model = _model;
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id responseObject)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        
        if ([[dict objectForKey:@"status"] intValue]==200)
        {
            [__aryMe removeObject:__model];
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__self.view hideToastActivity];
                [__self.view makeToast:@"删除成功"];
                [__self.tableView reloadData];
            });
        }
        else
        {
             dispatch_async(dispatch_get_main_queue(),
            ^{
                [__self.view hideToastActivity];
                [__self.view makeToast:@"删除失败"];
            });
        }
        
    } fail:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [__self.view hideToastActivity];
                           [__self.view makeToast:@"删除失败"];
                       });
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self.view makeToastActivity];
            __weak ResumeViewController *__self = self;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [__self deleteResume];
            });
        }
        break;
        default:
        {
            
        }
            break;
    }
}


@end
