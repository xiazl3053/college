//
//  PlayViewController.m
//  college
//
//  Created by xiongchi on 15/8/26.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "PlayViewController.h"
#import "PlayViewCell.h"
#import "MJRefresh.h"
#import "Toast+UIView.h"
#import "BaseService.h"
#import "UserInfo.h"
#import "AddPlayViewController.h"
#import "PlayInfoController.h"
#import "PlayCollectCell.h"

@interface PlayViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *colletView;
@property (nonatomic,strong) NSMutableArray *aryData;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger nIndex;

@end

@implementation PlayViewController

-(void)addPlay
{
    AddPlayViewController *addView = [[AddPlayViewController alloc] init];
    [self presentViewController:addView animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _aryData = [NSMutableArray array];
    
    [self setTitleText:@"娱乐"];
    
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnSave setTitle:@"创建" forState:UIControlStateNormal];
    
    [btnSave setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    
    [btnSave setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
    
    btnSave.titleLabel.font = XFONT(12);
    
    [btnSave addTarget:self action:@selector(addPlay) forControlEvents:UIControlEventTouchUpInside];
    
    [self setRightBtn:btnSave];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setItemSize:CGSizeMake(kScreenSourchWidth/2-20, 100)];//设置cell的尺寸
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _colletView = [[UICollectionView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, kScreenSourchHeight-114) collectionViewLayout:flowLayout];
    
    [self.view addSubview:_colletView];
    
    _colletView.delegate = self;
    
    _colletView.dataSource = self;
    
    [_colletView registerClass:[PlayCollectCell class] forCellWithReuseIdentifier:@"kPLAYCOLLECTION"];
    
    __weak PlayViewController *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [__self initData];
    });
    [_tableView addHeaderWithTarget:self action:@selector(initData)];
}

-(void)initData
{
    NSString *strInfo = [NSString stringWithFormat:@"%@party/search?token=%@&keyword=&pageNo=1&pageSize=10",
                         KHttpServer,[UserInfo sharedUserInfo].strToken];
    [_aryData removeAllObjects];
    __weak PlayViewController *__self = self;
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id data)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
         DLog(@"dict:%@",dict);
         if([[dict objectForKey:@"status"] intValue]==200)
         {
             NSArray *aryInfo = [dict objectForKey:@"list"];
             for (NSDictionary *model in aryInfo)
             {
                 PlayModel *play = [[PlayModel alloc] initWithDict:model];
                 [__self.aryData addObject:play];
                 __self.nIndex++;
             }
             dispatch_async(dispatch_get_main_queue(),
            ^{
                 [__self.colletView headerEndRefreshing];
                 [__self.colletView reloadData];
             });
         }
     }
     fail:^(NSError *error)
     {
           dispatch_async(dispatch_get_main_queue(), ^{
                [__self.view makeToast:@"加载失败"];
           });
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _aryData.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayCollectCell *cell= (PlayCollectCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"kPLAYCOLLECTION" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[PlayCollectCell alloc] initWithFrame:Rect(0, 0, kScreenSourchWidth/2-10, kScreenSourchWidth/2-10)];
    }
    [cell.layer setMasksToBounds:YES];
    [cell.layer setCornerRadius:5.0f];
    [cell setPlayModel:[_aryData objectAtIndex:indexPath.row]];
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
    PlayModel *model = [_aryData objectAtIndex:indexPath.row];
    PlayInfoController *playInfo = [[PlayInfoController alloc] initWithModel:model];
    [self presentViewController:playInfo animated:YES completion:nil];
}

@end
