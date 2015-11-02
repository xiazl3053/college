//
//  StudyViewController.m
//  college
//
//  Created by xiongchi on 15/9/9.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "StudyViewController.h"
#import "AddBBSViewController.h"
#import "BBSViewController.h"
#import "MJRefresh.h"
#import "AddTeachingViewController.h"
#import "UserInfo.h"
#import "TeachViewCell.h"
#import "BBSViewCell.h"
#import "TeachModel.h"
#import "BBSModel.h"
#import "TeachViewController.h"
#import "BaseService.h"

@interface StudyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *lblMove;
    UIButton *btnBBS;
    CGSize retSize;
    UIButton *btnTeach;
}
@property (nonatomic,strong) UITableView *tableBBS;
@property (nonatomic,strong) UITableView *tableTeach;
@property (nonatomic,strong) NSMutableArray *aryBBS;
@property (nonatomic,strong) NSMutableArray *aryTeach;
@property (nonatomic,assign) NSInteger nBBsCount;
@property (nonatomic,assign) NSInteger nTeachCount;

@end

@implementation StudyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
    _aryBBS = [NSMutableArray array];
    _aryTeach = [NSMutableArray array];
    [self initView];
    [self initBBsData];
    [self initTeachData];
    
    [_tableBBS addHeaderWithTarget:self action:@selector(initBBsData)];
    [_tableTeach addHeaderWithTarget:self action:@selector(initTeachData)];
    [_tableBBS addFooterWithTarget:self action:@selector(initMoreBBS)];
    [_tableTeach addFooterWithTarget:self action:@selector(initMoreTeach)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)createEvent
{
    if(_tableBBS.hidden==NO)
    {
        AddBBSViewController *addView = [[AddBBSViewController alloc] init];
        [self presentViewController:addView animated:YES completion:nil];
    }
    else
    {
        AddTeachingViewController *addView = [[AddTeachingViewController alloc] init];
        [self presentViewController:addView animated:YES completion:nil];
    }
}

-(void)initView
{
    [self setTitleText:@"学术"];
    
    UIButton *btnCreate = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCreate setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [btnCreate setTitle:@"创建" forState:UIControlStateNormal];
    btnCreate.titleLabel.font = XFONT(12);
    [self setRightBtn:btnCreate];
    [btnCreate addTarget:self action:@selector(createEvent) forControlEvents:UIControlEventTouchUpInside];
    
    lblMove = [[UILabel alloc] initWithFrame:Rect(0, 0, 10, 2)];
    btnBBS = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTeach = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBBS setTitle:@"论坛" forState:UIControlStateNormal];
    [btnTeach setTitle:@"授课" forState:UIControlStateNormal];
    
    NSDictionary *attribute = @{NSFontAttributeName:XFONT(14)};
        
    retSize = [@"论坛" boundingRectWithSize:CGSizeMake(100, 0)
                                                 options:\
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                              attributes:attribute
                                                 context:nil].size;
    
    
    [btnBBS setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    [btnBBS setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
    [btnBBS setTitleColor:RGB(128, 128, 128) forState:UIControlStateHighlighted];
    
    btnBBS.titleLabel.font = XFONT(14);
    
    [btnTeach setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    [btnTeach setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
    [btnTeach setTitleColor:RGB(128, 128, 128) forState:UIControlStateHighlighted];
    
    btnTeach.titleLabel.font = XFONT(14);

    UIView *headView = [[UIView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, 40)];;
    [headView setBackgroundColor:RGB(255, 245, 240)];
    [self.view addSubview:headView];
    [headView addSubview:btnBBS];
    [headView addSubview:btnTeach];
    btnBBS.selected = YES;
    [lblMove setBackgroundColor:MAIN_COLOR];
    [headView addSubview:lblMove];
    
    btnBBS.frame = Rect(0, 10, kScreenSourchWidth/2, 20);
    btnTeach.frame = Rect(kScreenSourchWidth/2, 10, kScreenSourchWidth/2, 20);
    lblMove.frame = Rect(btnBBS.width/2-retSize.width/2,33, retSize.width, 2);
    
    _tableBBS = [[UITableView alloc] initWithFrame:Rect(0, 104, kScreenSourchWidth, kScreenSourchHeight-154)];
    [self.view addSubview:_tableBBS];
    _tableBBS.delegate = self;
    _tableBBS.dataSource = self;
    
    _tableTeach = [[UITableView alloc] initWithFrame:Rect(0, 104, kScreenSourchWidth, kScreenSourchHeight-154)];
    [self.view addSubview:_tableTeach];
    _tableTeach.delegate = self;
    _tableTeach.dataSource  = self;
    _tableTeach.hidden = YES;
    _tableTeach.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableBBS.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [btnTeach addTarget:self action:@selector(setEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnBBS addTarget:self action:@selector(setEvent:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setEvent:(UIButton *)btnSender
{
    lblMove.frame = Rect(btnSender.x+btnSender.width/2-retSize.width/2, 33, retSize.width,2);
    if (btnBBS == btnSender)
    {
        btnBBS.selected = YES;
        btnTeach.selected = NO;
        _tableBBS.hidden = NO;
        _tableTeach.hidden = YES;
    }
    else
    {
        btnBBS.selected = NO;
        btnTeach.selected = YES;
        _tableBBS.hidden = YES;
        _tableTeach.hidden = NO;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableBBS == tableView) {
        return _aryBBS.count;
    }
    return _aryTeach.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strIdentifier = @"kUITABLEVIEWIDENTIFIER";
    if (_tableTeach == tableView)
    {
        TeachViewCell *cell = [_tableTeach dequeueReusableCellWithIdentifier:strIdentifier];
        if (cell==nil) {
            cell = [[TeachViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
        }
        [cell setModel:[_aryTeach objectAtIndex:indexPath.row]];
        return cell;
    }
    else if(_tableBBS == tableView)
    {
        BBSViewCell *cell = [_tableBBS dequeueReusableCellWithIdentifier:strIdentifier];
        if (cell==nil) {
            cell = [[BBSViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
        }
        [cell setModel:[_aryBBS objectAtIndex:indexPath.row]];
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableTeach == tableView)
    {
        return  kTEACHVIEWTABLEVIEWHEIGHT;
    }
    
    return kTEACHVIEWTABLEVIEWHEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_tableBBS==tableView)
    {
        BBSViewController *bbsView = [[BBSViewController alloc] initWithModel:[_aryBBS objectAtIndex:indexPath.row]];
        [self presentViewController:bbsView animated:YES completion:nil];
    }
    else
    {
        TeachViewController *teachView = [[TeachViewController alloc] initWithModel:[_aryTeach objectAtIndex:indexPath.row]];
        [self presentViewController:teachView animated:YES completion:nil];
    }
}

-(void)initBBsData
{
    NSString *strUrl = [NSString stringWithFormat:@"%@bbs/search?token=%@&keyword=&type=1&pageNo=1&pageSize=10",KHttpServer,
                        [UserInfo sharedUserInfo].strToken];
    __weak StudyViewController *__self = self;
    _nBBsCount = 0;
    [BaseService postJSONWithUrl:strUrl parameters:nil success:^(id responseObject)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        if ([[dict objectForKey:@"status"] intValue]==200) {
            NSArray *array = [dict objectForKey:@"list"];
            [__self.aryBBS removeAllObjects];
            for (NSDictionary *temp in array)
            {
                BBSModel *bbs = [[BBSModel alloc] initWithDict:temp];
                if([[temp objectForKey:@"type"] intValue]==1)
                {
                    [__self.aryBBS addObject:bbs];
                }
                __self.nBBsCount++;
            }
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__self.tableBBS headerEndRefreshing];
                [__self.tableBBS reloadData];
            });
        }
    } fail:^(NSError *error) {
        
    }];
}

-(void)initTeachData
{
    __weak StudyViewController *__self = self;
    NSString *strTeach = [NSString stringWithFormat:@"%@bbs/search?token=%@&keyword=&type=2&pageNo=1&pageSize=10",KHttpServer,
                        [UserInfo sharedUserInfo].strToken];
    _nTeachCount=0;
    [BaseService postJSONWithUrl:strTeach parameters:nil success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        if ([[dict objectForKey:@"status"] intValue]==200) {
            NSArray *array = [dict objectForKey:@"list"];
            [__self.aryTeach removeAllObjects];
            for (NSDictionary *temp in array)
            {
                TeachModel *bbs = [[TeachModel alloc] initWithDict:temp];
                if([[temp objectForKey:@"type"] intValue]==2)
                {
                    [__self.aryTeach addObject:bbs];
                }
                __self.nTeachCount ++;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self.tableTeach headerEndRefreshing];
                [__self.tableTeach reloadData];
            });
        }
    } fail:^(NSError *error) {
        
    }];
}

-(void)initMoreBBS
{
    if (_nBBsCount%10!=0)
    {
        [_tableBBS footerEndRefreshing];
        return ;
    }
    NSString *strUrl = [NSString stringWithFormat:@"%@bbs/search?token=%@&keyword=&type=1&pageNo=%zi&pageSize=10",KHttpServer,
                        [UserInfo sharedUserInfo].strToken,_nBBsCount+1];
    __weak StudyViewController *__self = self;
  
    [BaseService postJSONWithUrl:strUrl parameters:nil success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        if ([[dict objectForKey:@"status"] intValue]==200) {
            NSArray *array = [dict objectForKey:@"list"];
            for (NSDictionary *temp in array)
            {
                BBSModel *bbs = [[BBSModel alloc] initWithDict:temp];
                if([[temp objectForKey:@"type"] intValue]==1)
                {
                    [__self.aryBBS addObject:bbs];
                }
                __self.nBBsCount++;
            }
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [__self.tableBBS footerEndRefreshing];
                               [__self.tableBBS reloadData];
                           });
        }
    } fail:^(NSError *error) {
        
    }];
}
-(void)initMoreTeach
{
    if (_nTeachCount%10!=0)
    {
        [_tableTeach footerEndRefreshing];
        return ;
    }
    __weak StudyViewController *__self = self;
    NSString *strTeach = [NSString stringWithFormat:@"%@bbs/search?token=%@&keyword=&type=2&pageNo=%zi&pageSize=10",KHttpServer,
                          [UserInfo sharedUserInfo].strToken,_nTeachCount+1];
    [BaseService postJSONWithUrl:strTeach parameters:nil success:^(id responseObject)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        if ([[dict objectForKey:@"status"] intValue]==200)
        {
            NSArray *array = [dict objectForKey:@"list"];
            for (NSDictionary *temp in array)
            {
                TeachModel *bbs = [[TeachModel alloc] initWithDict:temp];
                if([[temp objectForKey:@"type"] intValue]==2)
                {
                    [__self.aryTeach addObject:bbs];
                }
                __self.nTeachCount ++;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self.tableTeach footerEndRefreshing];
                [__self.tableTeach reloadData];
            });
        }
    } fail:^(NSError *error) {
        
    }];
}

@end
