//
//  JobViewController.m
//  college
//
//  Created by xiongchi on 15/8/26.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "JobViewController.h"
#import "JobViewCell.h"
#import "MJRefresh.h"
#import "UploadImageService.h"
#import "UserInfo.h"
#import "JobInfoController.h"
#import "Toast+UIView.h"
#import "BaseService.h"

@interface JobViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UploadImageService *uploadService;

}
@property (nonatomic,assign) NSInteger nIndex;
@property (nonatomic,strong) NSMutableArray *aryData;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation JobViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _aryData = [NSMutableArray array];
    [self setTitleText:@"兼职"];
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setTitle:@"简历" forState:UIControlStateNormal];
    btnRight.titleLabel.font = XFONT(14);
    
    [self setRightBtn:btnRight];
    
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, kScreenSourchHeight-114)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [_tableView addHeaderWithTarget:self action:@selector(initData)];
    
    [_tableView addFooterWithTarget:self action:@selector(initMoreData)];
    [self initData];
}

//显示我发布的兼职信息
-(void)showMyJob
{
    NSString *strInfo = [NSString stringWithFormat:@"%@jianzhi/myList?token=%@&userid=%@&pageNo=1&pageSize=10",KHttpServer,[UserInfo sharedUserInfo].strToken,
                         [UserInfo sharedUserInfo].strUserId];
    
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id data){
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
    } fail:^(NSError *error){}];
    
}

-(void)reloadDict:(NSArray *)aryCount
{
    [_aryData removeAllObjects];
    for (NSDictionary *dict in aryCount)
    {
        JobModel *job = [[JobModel alloc] initWIthDict:dict];
        [_aryData addObject:job];
    }
    [_tableView headerEndRefreshing];
    [_tableView reloadData];
}

-(void)initMoreData
{
    NSString *strInfo = [NSString stringWithFormat:@"%@jianzhi/search?token=%@&userid=%@&keyword=&pageNo=%lu&pageSize=10",
                         KHttpServer,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId,_nIndex];
    __weak JobViewController *__self = self;
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id data)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
         DLog(@"dict:%@",dict);
         if([[dict objectForKey:@"status"] intValue]==200)
         {
             NSArray *aryInfo = [dict objectForKey:@"list"];
             for (NSDictionary *dict in aryInfo)
             {
                 JobModel *job = [[JobModel alloc] initWIthDict:dict];
                 [_aryData addObject:job];
                 __self.nIndex++;
             }
             dispatch_async(dispatch_get_main_queue(),
             ^{
                 [__self.tableView footerEndRefreshing];
                 [__self.tableView reloadData];
             });
         }
     } fail:^(NSError *error){
         
     }];
}

-(void)initDataEvent
{
    [self.tableView headerBeginRefreshing];
    NSString *strInfo = [NSString stringWithFormat:@"%@jianzhi/search?token=%@&userid=%@&keyword=&pageNo=1&pageSize=10",
                         KHttpServer,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId];
    __weak JobViewController *__self = self;
    [_aryData removeAllObjects];
    
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id data)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
         DLog(@"dict:%@",dict);
         if([[dict objectForKey:@"status"] intValue]==200)
         {
             NSArray *aryInfo = [dict objectForKey:@"list"];
             for (NSDictionary *dict in aryInfo)
             {
                 JobModel *job = [[JobModel alloc] initWIthDict:dict];
                 [__self.aryData addObject:job];
                 __self.nIndex++;
             }
             dispatch_async(dispatch_get_main_queue(),
            ^{
                [__self.tableView headerEndRefreshing];
                [__self.tableView reloadData];
            });
         }
     } fail:^(NSError *error){
         
     }];
}

-(void)initData
{
    NSString *strInfo = [NSString stringWithFormat:@"%@jianzhi/search?token=%@&userid=%@&keyword=&pageNo=1&pageSize=10",
                         KHttpServer,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId];
    __weak JobViewController *__self = self;
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id data)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        if([[dict objectForKey:@"status"] intValue]==200)
        {
             NSArray *aryInfo = [dict objectForKey:@"list"];
            [__self reloadDict:aryInfo];
            __self.nIndex = 10;
        }
    } fail:^(NSError *error){
        
    }];
}

//更新简历
-(void)updateJianLi:(NSString *)strId
{
    NSString *strInfo = [NSString stringWithFormat:@"%@pub/updateJianLi?token=%@&userid=%@",
                         KHttpServer,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId];
    
    NSDictionary *dict = @{@"jianliid":strId,@"userid":[UserInfo sharedUserInfo].strUserId,@"mobile":@"17727610912",@"sex":@"1",@"title":@"testUpd"};
    
    [BaseService postJSONWithUrl:strInfo parameters:dict success:^(id response)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
         DLog(@"dict:%@",dict);
         if ([[dict objectForKey:@"status"] intValue]==200)
         {
             NSDictionary *info = [dict objectForKey:@"jianli"];
             [info objectForKey:@""];
         }
     
     }
    fail:^(NSError *error)
     {
         DLog(@"失败");
     }];
}

//删除简历
-(void)deleteJianLi:(int)nId
{
    NSString *strInfo = [NSString stringWithFormat:@"%@pub/deleteJianLi?token=%@&userid=%@&jianliid=%d",
                         KHttpServer,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId,nId];
    DLog(@"strInfo:%@",strInfo);
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id response){
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
    } fail:^(NSError *error){
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
