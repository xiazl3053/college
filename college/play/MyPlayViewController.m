//
//  MyPlayViewController.m
//  college
//
//  Created by xiongchi on 15/9/9.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "MyPlayViewController.h"
#import "UserInfo.h"
#import "PlayModel.h"
#import "BaseService.h"
#import "PlayViewCell.h"
#import "Toast+UIView.h"
#import "PlayInfoController.h"
#import "PlayCollectCell.h"

@interface MyPlayViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UILabel *lblMove;
    UIButton *btnCreate;
    CGSize retSize;
    UIButton *btnJoin;
}
@property (nonatomic,strong) UICollectionView *tableCreate;
@property (nonatomic,strong) UICollectionView *tableJoin;
@property (nonatomic,strong) NSMutableArray *aryCreate;
@property (nonatomic,strong) NSMutableArray *aryJoin;
@end

@implementation MyPlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
    
    _aryCreate = [NSMutableArray array];
    _aryJoin = [NSMutableArray array];
    
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
    [self setTitleText:@"我的活动"];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateHighlighted];
    
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftBtn:btnBack];
    
    lblMove = [[UILabel alloc] initWithFrame:Rect(0, 0, 10, 2)];
    btnCreate = [UIButton buttonWithType:UIButtonTypeCustom];
    btnJoin = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnCreate setTitle:@"创建" forState:UIControlStateNormal];
    [btnJoin setTitle:@"参与" forState:UIControlStateNormal];
    
    NSDictionary *attribute = @{NSFontAttributeName:XFONT(14)};
    
    retSize = [@"创建" boundingRectWithSize:CGSizeMake(100, 0)
                                  options:\
               NSStringDrawingTruncatesLastVisibleLine |
               NSStringDrawingUsesLineFragmentOrigin |
               NSStringDrawingUsesFontLeading
                               attributes:attribute
                                  context:nil].size;
    
    
    [btnCreate setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    [btnCreate setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
    [btnCreate setTitleColor:RGB(128, 128, 128) forState:UIControlStateHighlighted];
    
    btnCreate.titleLabel.font = XFONT(14);
    
    [btnJoin setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    [btnJoin setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
    [btnJoin setTitleColor:RGB(128, 128, 128) forState:UIControlStateHighlighted];
    
    btnJoin.titleLabel.font = XFONT(14);
    
    UIView *headView = [[UIView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, 40)];;
    [headView setBackgroundColor:RGB(255, 245, 240)];
    [self.view addSubview:headView];
    [headView addSubview:btnCreate];
    [headView addSubview:btnJoin];
    btnCreate.selected = YES;
    //    btnTeach.selected = YES;
    [lblMove setBackgroundColor:MAIN_COLOR];
    [headView addSubview:lblMove];
    
    btnCreate.frame = Rect(0, 10, kScreenSourchWidth/2, 20);
    btnJoin.frame = Rect(kScreenSourchWidth/2, 10, kScreenSourchWidth/2, 20);
    lblMove.frame = Rect(btnCreate.width/2-retSize.width/2,33, retSize.width, 2);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setItemSize:CGSizeMake(kScreenSourchWidth/2-20, 100)];//设置cell的尺寸
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _tableCreate = [[UICollectionView alloc] initWithFrame:Rect(0, 104, kScreenSourchWidth, kScreenSourchHeight-104) collectionViewLayout:flowLayout];
    
    [self.view addSubview:_tableCreate];
    
    _tableCreate.delegate = self;
    
    _tableCreate.dataSource = self;
    
    [_tableCreate registerClass:[PlayCollectCell class] forCellWithReuseIdentifier:@"kCREATEPLAYCOLLECTION"];
    
    UICollectionViewFlowLayout *joinLayout = [[UICollectionViewFlowLayout alloc]init];
    [joinLayout setItemSize:CGSizeMake(kScreenSourchWidth/2-20, 100)];//设置cell的尺寸
    [joinLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
    joinLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _tableJoin = [[UICollectionView alloc] initWithFrame:Rect(0, 104, kScreenSourchWidth, kScreenSourchHeight-104) collectionViewLayout:joinLayout];

    [self.view addSubview:_tableJoin];

    _tableJoin.delegate = self;

    _tableJoin.dataSource = self;

    [_tableJoin registerClass:[PlayCollectCell class] forCellWithReuseIdentifier:@"kCREATEPLAYCOLLECTION"];
    
    _tableJoin.hidden = YES;
    
    [btnJoin addTarget:self action:@selector(setEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnCreate addTarget:self action:@selector(setEvent:) forControlEvents:UIControlEventTouchUpInside];
    __weak MyPlayViewController *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [__self initData];
    });
}

-(void)initData
{
    NSString *strInfo = [NSString stringWithFormat:@"%@party/myList?token=%@&userid=%@&pageNo=1&pageSize=10",
                         KHttpServer,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId];
    __weak MyPlayViewController *__self = self;
    [_aryCreate removeAllObjects];
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[dict objectForKey:@"status"] intValue]==200) {
            NSArray *array = [dict objectForKey:@"list"];
            for (NSDictionary *diction in array) {
                PlayModel *model = [[PlayModel alloc] initWithDict:diction];
                [__self.aryCreate addObject:model];
            }
            DLog(@"count:%d",(int)__self.aryCreate.count);
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self.tableCreate reloadData];
            });
        }
        
    } fail:^(NSError *error) {
        
    }];
    [_aryJoin removeAllObjects];
    NSString *strUrl = [NSString stringWithFormat:@"%@party/myApplyList?token=%@&userid=%@&pageNo=1&pageSize=10",
                        KHttpServer,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId];
    [BaseService postJSONWithUrl:strUrl parameters:nil success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[dict objectForKey:@"status"] intValue]==200) {
            NSArray *array = [dict objectForKey:@"list"];
            for (NSDictionary *diction in array) {
                PlayModel *model = [[PlayModel alloc] initWithDict:diction];
                [__self.aryJoin addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__self.tableJoin reloadData];
            });
        }
        
    }
    fail:^(NSError *error)
    {
        
    }];
}


-(void)setEvent:(UIButton *)btnSender
{
    lblMove.frame = Rect(btnSender.x+btnSender.width/2-retSize.width/2, 33, retSize.width,2);
    if (btnCreate == btnSender)
    {
        btnCreate.selected = YES;
        btnJoin.selected = NO;
        _tableCreate.hidden = NO;
        _tableJoin.hidden = YES;
    }
    else
    {
        btnCreate.selected = NO;
        btnJoin.selected = YES;
        _tableCreate.hidden = YES;
        _tableJoin.hidden = NO;
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_tableJoin == collectionView)
    {
        return _aryJoin.count;
    }
    if (_tableCreate == collectionView) {
        return _aryCreate.count;
    }
    return _aryCreate.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
 
    PlayCollectCell *cell = (PlayCollectCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"kCREATEPLAYCOLLECTION" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[PlayCollectCell alloc] initWithFrame:Rect(0, 0, kScreenSourchWidth/2-10, kScreenSourchWidth/2-10)];
    }
    [cell.layer setMasksToBounds:YES];
    [cell.layer setCornerRadius:5.0f];
    if (collectionView==_tableCreate)
    {
        [cell setPlayModel:[_aryCreate objectAtIndex:indexPath.row]];
    }
    else
    {
        [cell setPlayModel:[_aryJoin objectAtIndex:indexPath.row]];
    }
    return cell;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenSourchWidth/2-10, 145);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayModel *model = nil;
//    [_aryData objectAtIndex:indexPath.row];
    if (_tableJoin==collectionView)
    {
        model = [_aryJoin objectAtIndex:indexPath.row];
    }
    else
    {
        model = [_aryCreate objectAtIndex:indexPath.row];
    }
    
    PlayInfoController *playInfo = [[PlayInfoController alloc] initWithModel:model];
    [self presentViewController:playInfo animated:YES completion:nil];
}

@end
