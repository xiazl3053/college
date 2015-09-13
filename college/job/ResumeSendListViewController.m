//
//  ResumeSendListViewController.m
//  college
//
//  Created by xiongchi on 15/9/10.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "ResumeSendListViewController.h"
#import "UserInfo.h"
#import "JobInfoController.h"
#import "JobViewCell.h"
#import "BaseService.h"
#import "ResumeModel.h"

@interface ResumeSendListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *aryData;

@end

@implementation ResumeSendListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initView
{
    [super viewDidLoad];
    
    _aryData = [NSMutableArray array];
    
    [self setTitleText:@"投过的简历"];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateHighlighted];
    
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftBtn:btnBack];
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, kScreenSourchHeight-114)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self initData];
}

-(void)reloadDict:(NSArray *)aryCount
{
    [_aryData removeAllObjects];
    for (NSDictionary *dict in aryCount)
    {
        JobModel *job = [[JobModel alloc] initWIthDict:dict];
        [_aryData addObject:job];
    }
    __weak ResumeSendListViewController *__self = self;
    dispatch_async(dispatch_get_main_queue()
                   , ^{
                       [__self.tableView reloadData];
                   });
}

-(void)initData
{
    NSString *strInfo = [NSString stringWithFormat:@"%@jianzhi/myApplyList?token=%@&userid=%@&keyword=&pageNo=1&pageSize=10",
                         KHttpServer,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId];
    
    __weak ResumeSendListViewController *__self = self;
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id data)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
         DLog(@"dict:%@",dict);
         if([[dict objectForKey:@"status"] intValue]==200)
         {
             NSArray *aryInfo = [dict objectForKey:@"list"];
             [__self reloadDict:aryInfo];
         }
     } fail:^(NSError *error){
         
     }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strJobIdentifier = @"JOBTABLEVIEWIDENTIFIER";
    JobViewCell *jobCell = [_tableView dequeueReusableCellWithIdentifier:strJobIdentifier];
    
    if (jobCell==nil)
    {
        jobCell = [[JobViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strJobIdentifier];
    }
    
    UIView *selectView = [[UIView alloc] initWithFrame:jobCell.bounds];
    
    [selectView setBackgroundColor:UIColorFromRGB(0xF4F4F4)];
    
    [jobCell setSelectedBackgroundView:selectView];
    
    [jobCell setJobModel:[_aryData objectAtIndex:indexPath.row]];
    
    if (indexPath.row==_aryData.count-1)
    {
        [jobCell setLineFull];
    }
    
    return jobCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobModel *jobModel = [_aryData objectAtIndex:indexPath.row];
    
    JobInfoController *jobInfo = [[JobInfoController alloc] initWIthModel:jobModel];
    
    [self presentViewController:jobInfo animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
