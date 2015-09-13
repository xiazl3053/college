//
//  IdeaViewController.m
//  college
//
//  Created by xiongchi on 15/9/10.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "IdeaViewController.h"
#import "UserInfo.h"
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

@end

@implementation IdeaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
    _aryCollow = [NSMutableArray array];
    _aryNow = [NSMutableArray array];
    
    for (int i=0; i<5; i++)
    {
        IdeaModel *model = [[IdeaModel alloc] init];
        model.strCreateTime = @"2015-9-10";
        model.strTitle = @"关于操你妹";
        model.strCost = @"30";
        model.strIntrol = @"如何约，附近的萨看来放假快乐的撒娇弗兰克的撒娇分开了的撒娇了看法的撒娇了看法啊就是抵抗力发觉卡什莱夫健康的风景都开始垃圾发电卢萨卡激发快乐撒大家快来方式记录看法是打开拉风萨帝撒";
        [_aryNow addObject:model];
    }
    
    for (int i=0; i<5; i++)
    {
        CollowModel *model = [[CollowModel alloc] init];
        model.strCreateTime = @"2015-9-10";
        model.strTitle = @"征收一个帅哥";
        model.strCost = @"30";
        model.strContent = @"如何约，附近的萨看来放假快乐的撒娇弗兰克的撒娇分开了的撒娇了看法的撒娇了看法啊就是抵抗力发觉卡什莱夫健康的风景都开始垃圾发电卢萨卡激发快乐撒大家快来方式记录看法是打开拉风萨帝撒";
        [_aryCollow addObject:model];
    }
    [self initView];
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
        
    }
    else
    {
        
    }
}

@end
