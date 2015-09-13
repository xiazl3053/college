//
//  NewViewController.m
//  college
//
//  Created by xiongchi on 15/8/26.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "NewViewController.h"
#import "NewViewCell.h"
#import "AppDelegate.h"

@interface NewViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *aryData;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation NewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _aryData = [NSMutableArray array];
    
    [self setTitleText:@"新闻"];
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, kScreenSourchHeight-114)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [_tableView reloadData];
    
    NewModel *newM1 = [[NewModel alloc] initWithItem:@[@"天津爆炸",@"新华网天津8月",@"2015-08-15"]];
    NewModel *newM2 = [[NewModel alloc] initWithItem:@[@"天津爆炸",@"新华网天津8月",@"2015-08-15"]];
    NewModel *newM3 = [[NewModel alloc] initWithItem:@[@"天津爆炸",@"新华网天津8月",@"2015-08-15"]];
    NewModel *newM4 = [[NewModel alloc] initWithItem:@[@"天津爆炸",@"新华网天津8月",@"2015-08-15"]];
    NewModel *newM5 = [[NewModel alloc] initWithItem:@[@"天津爆炸",@"新华网天津8月",@"2015-08-15"]];
    
    [_aryData addObject:newM1];
    [_aryData addObject:newM2];
    [_aryData addObject:newM3];
    [_aryData addObject:newM4];
    [_aryData addObject:newM5];
//    
//    [self addLeftEvent:^(id sender)
//    {
//        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    }];
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
    return _aryData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strJobIdentifier = @"NEWTABLEVIEWIDENTIFIER";
    NewViewCell *jobCell = [_tableView dequeueReusableCellWithIdentifier:strJobIdentifier];
    
    if (jobCell==nil)
    {
        jobCell = [[NewViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strJobIdentifier];
    }
    
    UIView *selectView = [[UIView alloc] initWithFrame:jobCell.bounds];
    
    [selectView setBackgroundColor:UIColorFromRGB(0xF4F4F4)];
    
    [jobCell setSelectedBackgroundView:selectView];
    
    [jobCell setNewModel:[_aryData objectAtIndex:indexPath.row]];
    
    return jobCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
