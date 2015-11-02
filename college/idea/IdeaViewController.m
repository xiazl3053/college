//
//  IdeaViewController.m
//  college
//
//  Created by xiongchi on 15/9/10.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "IdeaViewController.h"
#import "UserInfo.h"
#import "CollowViewController.h"
#import "MJRefresh.h"
#import "IdeaDetailViewController.h"
#import "AddCollowViewController.h"
#import "AddIdeaViewController.h"
#import "IdeaViewCell.h"
#import "TeachViewCell.h"
#import "BBSViewCell.h"
#import "TeachModel.h"
#import "BBSModel.h"
#import "BaseService.h"
#import "IdeaModel.h"
#import "CollowViewCell.h"
#import "CollowModel.h"

@interface IdeaViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *lblMove;
    UIButton *btnNow;
    CGSize retSize;
    UIButton *btnCollow;
}
@property (nonatomic,strong) UITableView *tableNow;
@property (nonatomic,strong) UITableView *tableCollow;
@property (nonatomic,strong) NSMutableArray *aryNow;
@property (nonatomic,strong) NSMutableArray *aryCollow;

@property (nonatomic,assign) NSInteger nIdeaIndex;
@property (nonatomic,assign) NSInteger nCollowIndex;

@end

@implementation IdeaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
    _aryCollow = [NSMutableArray array];
    _aryNow = [NSMutableArray array];
    
//    for (int i=0; i<5; i++)
//    {
//        CollowModel *model = [[CollowModel alloc] init];
//        model.strCreateTime = [NSString stringWithFormat:@"2015-9-1%d",i];
//        model.strTitle = @"快速编码";
//        model.strCost = @"30";
//        model.strContent = @"这是一条征收创意的测试信息";
//        [_aryCollow addObject:model];
//    }
    [self initView];
    [self initIdeaData];
    [self initCollowData];
    [_tableCollow addHeaderWithTarget:self action:@selector(initCollowData)];
//    [self ini];
    [_tableNow addHeaderWithTarget:self action:@selector(initIdeaData)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)createEvent
{
    if(_tableNow.hidden==NO)
    {
        AddIdeaViewController *addView = [[AddIdeaViewController alloc] init];
        [self presentViewController:addView animated:YES completion:nil];
    }
    else
    {
        AddCollowViewController *addView = [[AddCollowViewController alloc] init];
        [self presentViewController:addView animated:YES completion:nil];
    }
}

-(void)initCollowData
{
    NSString *strUrl = [NSString stringWithFormat:@"%@zhengji/search?token=%@&keyword=&pageNo=1&pageSize=10",KHttpServer,
                        [UserInfo sharedUserInfo].strToken];
    __weak IdeaViewController *__self = self;
    _nCollowIndex = 0;
    [__self.aryCollow removeAllObjects];
    [BaseService postJSONWithUrl:strUrl parameters:nil success:^(id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         DLog(@"dict:%@",dict);
         if ([[dict objectForKey:@"status"] intValue]==200) {
             NSArray *array = [dict objectForKey:@"list"];
             for (NSDictionary *temp in array)
             {
                 CollowModel *collow = [[CollowModel alloc] initWithDict:temp];
                 [__self.aryCollow addObject:collow];
                 __self.nCollowIndex++;
             }
             dispatch_async(dispatch_get_main_queue(),
                            ^{
                                [__self.tableCollow headerEndRefreshing];
                                [__self.tableCollow reloadData];
                            });
         }
     } fail:^(NSError *error) {
         
     }];
}

-(void)initIdeaData
{
    NSString *strUrl = [NSString stringWithFormat:@"%@idea/search?token=%@&keyword=&pageNo=1&pageSize=10",KHttpServer,
                        [UserInfo sharedUserInfo].strToken];
    __weak IdeaViewController *__self = self;
    _nIdeaIndex = 0;
    [__self.aryCollow removeAllObjects];
    [BaseService postJSONWithUrl:strUrl parameters:nil success:^(id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         DLog(@"dict:%@",dict);
         if ([[dict objectForKey:@"status"] intValue]==200) {
             NSArray *array = [dict objectForKey:@"list"];
             for (NSDictionary *temp in array)
             {
                 IdeaModel *idea = [[IdeaModel alloc] initWithDict:temp];
                 [__self.aryNow addObject:idea];
                 __self.nIdeaIndex++;
             }
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__self.tableNow headerEndRefreshing];
                [__self.tableNow reloadData];
            });
         }
     } fail:^(NSError *error) {
         
     }];
}

-(void)initMoreIdea
{
    if (_nIdeaIndex%10!=0)
    {
        [_tableNow footerEndRefreshing];
        return ;
    }
    NSString *strUrl = [NSString stringWithFormat:@"%@idea/search?token=%@&keyword=&pageNo=%zi&pageSize=10",KHttpServer,
                        [UserInfo sharedUserInfo].strToken,_nIdeaIndex/10+1];
    __weak IdeaViewController *__self = self;
    
    [BaseService postJSONWithUrl:strUrl parameters:nil success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        if ([[dict objectForKey:@"status"] intValue]==200) {
            NSArray *array = [dict objectForKey:@"list"];
            for (NSDictionary *temp in array)
            {
                IdeaModel *bbs = [[IdeaModel alloc] initWithDict:temp];
                [__self.aryNow addObject:bbs];
                __self.nIdeaIndex++;
            }
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [__self.tableNow footerEndRefreshing];
                               [__self.tableNow reloadData];
                           });
        }
    } fail:^(NSError *error) {
        
    }];
}

-(void)initMoreCollow
{
    if (_nCollowIndex%10!=0)
    {
        [_tableCollow footerEndRefreshing];
        return ;
    }
    NSString *strUrl = [NSString stringWithFormat:@"%@zhengji/search?token=%@&keyword=&pageNo=%zi&pageSize=10",KHttpServer,
                        [UserInfo sharedUserInfo].strToken,_nCollowIndex/10+1];
    __weak IdeaViewController *__self = self;
    
    [BaseService postJSONWithUrl:strUrl parameters:nil success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        if ([[dict objectForKey:@"status"] intValue]==200) {
            NSArray *array = [dict objectForKey:@"list"];
            for (NSDictionary *temp in array)
            {
                CollowModel *bbs = [[CollowModel alloc] initWithDict:temp];
                [__self.aryCollow addObject:bbs];
                __self.nCollowIndex++;
            }
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [__self.tableCollow footerEndRefreshing];
                               [__self.tableCollow reloadData];
                           });
        }
    } fail:^(NSError *error) {
        
    }];
}

-(void)initView
{
    [self setTitleText:@"创意"];
    lblMove = [[UILabel alloc] initWithFrame:Rect(0, 0, 10, 2)];
    btnNow = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCollow = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnNow setTitle:@"已有创意" forState:UIControlStateNormal];
    [btnCollow setTitle:@"创意征集" forState:UIControlStateNormal];
    
    UIButton *btnCreate = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCreate setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [btnCreate setTitle:@"创建" forState:UIControlStateNormal];
    btnCreate.titleLabel.font = XFONT(12);
    [self setRightBtn:btnCreate];
    [btnCreate addTarget:self action:@selector(createEvent) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *attribute = @{NSFontAttributeName:XFONT(14)};
    
    retSize = [@"已有创意" boundingRectWithSize:CGSizeMake(100, 0)
                                  options:\
               NSStringDrawingTruncatesLastVisibleLine |
               NSStringDrawingUsesLineFragmentOrigin |
               NSStringDrawingUsesFontLeading
                               attributes:attribute
                                  context:nil].size;
    
    [btnNow setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    [btnNow setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
    [btnNow setTitleColor:RGB(128, 128, 128) forState:UIControlStateHighlighted];
    
    btnNow.titleLabel.font = XFONT(14);
    
    [btnCollow setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    [btnCollow setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
    [btnCollow setTitleColor:RGB(128, 128, 128) forState:UIControlStateHighlighted];
    
    btnCollow.titleLabel.font = XFONT(14);
    
    UIView *headView = [[UIView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, 40)];;
    [headView setBackgroundColor:RGB(255, 245, 240)];
    [self.view addSubview:headView];
    [headView addSubview:btnNow];
    [headView addSubview:btnCollow];
    btnNow.selected = YES;
    //    btnTeach.selected = YES;
    [lblMove setBackgroundColor:MAIN_COLOR];
    [headView addSubview:lblMove];
    
    btnNow.frame = Rect(0, 10, kScreenSourchWidth/2, 20);
    btnCollow.frame = Rect(kScreenSourchWidth/2, 10, kScreenSourchWidth/2, 20);
    lblMove.frame = Rect(btnNow.width/2-retSize.width/2,33, retSize.width, 2);
    
    _tableNow = [[UITableView alloc] initWithFrame:Rect(0, 104, kScreenSourchWidth, kScreenSourchHeight-104)];
    [self.view addSubview:_tableNow];
    _tableNow.delegate = self;
    _tableNow.dataSource = self;
    
    _tableCollow = [[UITableView alloc] initWithFrame:Rect(0, 104, kScreenSourchWidth, kScreenSourchHeight-104)];
    [self.view addSubview:_tableCollow];
    _tableCollow.delegate = self;
    _tableCollow.dataSource  = self;
    _tableCollow.hidden = YES;
    _tableCollow.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableNow.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [btnNow addTarget:self action:@selector(setEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnCollow addTarget:self action:@selector(setEvent:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setEvent:(UIButton *)btnSender
{
    lblMove.frame = Rect(btnSender.x+btnSender.width/2-retSize.width/2, 33, retSize.width,2);
    if (btnNow == btnSender)
    {
        btnNow.selected = YES;
        btnCollow.selected = NO;
        _tableNow.hidden = NO;
        _tableCollow.hidden = YES;
    }
    else
    {
        btnNow.selected = NO;
        btnCollow.selected = YES;
        _tableNow.hidden = YES;
        _tableCollow.hidden = NO;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableNow == tableView) {
        DLog(@"size:%zi",_aryNow.count);
        return _aryNow.count;
    }
    return _aryCollow.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strIdentifier = @"kUITABLEVIEWIDENTIFIER";
    if (_tableCollow == tableView)
    {
        CollowViewCell *cell = [_tableCollow dequeueReusableCellWithIdentifier:strIdentifier];
        if (cell==nil) {
            cell = [[CollowViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
        }
        [cell setModel:[_aryCollow objectAtIndex:indexPath.row]];
        return cell;
    }
    else if(_tableNow == tableView)
    {
        IdeaViewCell *cell = [_tableNow dequeueReusableCellWithIdentifier:strIdentifier];
        if (cell==nil)
        {
            cell = [[IdeaViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
        }
        [cell setModel:[_aryNow objectAtIndex:indexPath.row]];
        if(_aryNow.count == indexPath.row+1)
        {
            [cell setLineFull];
        }
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableCollow == tableView)
    {
        return  kIDEAVIEWCONTROLLER;
    }
    
    return kIDEAVIEWCONTROLLER;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableNow == tableView)
    {
        IdeaDetailViewController *ideaView = [[IdeaDetailViewController alloc] initWithModel:[_aryNow objectAtIndex:indexPath.row]];
        [self presentViewController:ideaView animated:YES completion:nil];
    }
    else
    {
        CollowViewController *collowView = [[CollowViewController alloc] initWithModel:[_aryCollow objectAtIndex:indexPath.row]];
        [self presentViewController:collowView animated:YES completion:nil];
    }
}

@end
