//
//  LeftViewController.m
//  college
//
//  Created by xiongchi on 15/7/16.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "LeftViewController.h"
#import "Common.h"
#import "ResumeSendListViewController.h"
#import "MyPlayViewController.h"
#import "AppDelegate.h"
#import "ResumeModel.h"
#import "BaseService.h"
#import "ResumeViewController.h"
#import "UserInfo.h"
#import "UIImageView+WebCache.h"
#import "PersonViewCell.h"
#import "Toast+UIView.h"
#import "RSKImageCropper.h"
#import "UIView+Extension.h"
#import "UserInfo.h"
#import "UserInfoVIewController.h"
#import "UIView+BlocksKit.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *aryObj;
    UILabel *lblNick;
    UILabel *lblScohool;
    UIImageView *imgView;
}
@property (nonatomic,strong) UIView *hiddenView;
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *itemList;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) UIImagePickerController *camrePicker;
@end
@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

-(void)getAllResume
{
    NSString *strInfo = [NSString stringWithFormat:@"%@pub/getJianLiByUser?token=%@&userid=%@",KHttpServer
                         ,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId];
    DLog(@"strInfo:%@",strInfo);
    
    if ([UserInfo sharedUserInfo].aryResume==nil)
    {
        [UserInfo sharedUserInfo].aryResume = [NSMutableArray array];
    }
    
    [[UserInfo sharedUserInfo].aryResume removeAllObjects];
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id response)
    {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
         DLog(@"dict:%@",dict);
         if ([[dict objectForKey:@"status"] intValue]==200)
         {
             NSArray *ary = [dict objectForKey:@"jianliList"];
             for (NSDictionary *resume in ary)
             {
                 ResumeModel *model = [[ResumeModel alloc] initWithDict:resume];
                 [[UserInfo sharedUserInfo].aryResume addObject:model];
                 [UserInfo sharedUserInfo].strJianliId = model.strJLId;
                 model = nil;
             }
         }
         else
         {
             if([[dict objectForKey:@"status"] intValue]==500)
             {
                 [[UIApplication sharedApplication].keyWindow makeToast:@"登录信息已过期,重新登录"];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                 ^{
                     [(AppDelegate*)[UIApplication sharedApplication].delegate showLoginView];
                 });
             }
         }
     } fail:^(NSError *error){
         DLog(@"error:%@",error);
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:UIColorFromRGB(0x050e1d)];
    
    __weak LeftViewController *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [__self getAllResume];
    });
    
    _array = [NSMutableArray array];
    
    [_array addObject:[[LeftCellInfo alloc] initWithTitle:@"简历管理" normal:@"icon_job"]];
    [_array addObject:[[LeftCellInfo alloc] initWithTitle:@"投过的简历" normal:@"icon_jobed"]];
    [_array addObject:[[LeftCellInfo alloc] initWithTitle:@"我的活动" normal:@"icon_myworke"]];
    [_array addObject:[[LeftCellInfo alloc] initWithTitle:@"我的想法" normal:@"icon_myidea"]];
    [_array addObject:[[LeftCellInfo alloc] initWithTitle:@"我的问题" normal:@"icon_myquestion"]];
    [_array addObject:[[LeftCellInfo alloc] initWithTitle:@"设置" normal:@"icon_setting"]];
    
    imgView = [[UIImageView alloc] initWithFrame:Rect(10, 64,60, 60)];
    
    
    NSString *strInfo = [NSString stringWithFormat:@"%@pub/downloadUserPicture?token=%@&userid=%@",
                         KHttpServer,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId];
    
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:strInfo] placeholderImage:[UIImage imageNamed:@"moren_longin"]];
    
    
    [imgView.layer setMasksToBounds:YES];
    
    [imgView.layer setCornerRadius:30.0f];
    
    [self.view addSubview:imgView];
    
    [imgView setUserInteractionEnabled:YES];
    
    [imgView bk_whenTouches:1 tapped:1 handler:^{
        [__self setUserInfo];
    }];
    
    lblNick = [[UILabel alloc] initWithFrame:Rect(imgView.x+imgView.width+14,imgView.y+15,200,18)];
    
    [lblNick setTextColor:UIColorFromRGB(0xFFFFFF)];
    
    [lblNick setText:@"小志"];
    
    [lblNick setFont:XFONT(16)];
    
    [self.view addSubview:lblNick];
    
    lblScohool = [[UILabel alloc] initWithFrame:Rect(lblNick.x, lblNick.y+lblNick.height+10, 200, 15)];
    
    [lblScohool setTextColor:UIColorFromRGB(0xFFFFFF)];
    
    [lblScohool setFont:XFONT(12)];
    
    [lblScohool setText:@"广州科技园"];
    
    [self.view addSubview:lblScohool];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.y+imgView.height+19, kScreenSourchWidth, 0.2)];
    
    line1.backgroundColor = [UIColor colorWithRed:198/255.0
                                            green:198/255.0
                                             blue:198/255.0
                                            alpha:1.0];
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.y+imgView.height+19.2, kScreenSourchWidth ,0.2)] ;
    
    line2.backgroundColor = [UIColor whiteColor];
    
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    [self.view addSubview:line1];
    
    [self.view addSubview:line2];
    
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, imgView.y+imgView.height+20,kScreenSourchWidth,280)];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_tableView];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIImageView *imgDown = [[UIImageView alloc] initWithFrame:Rect(0, kScreenSourchHeight-120,kScreenSourchWidth, 120)];
    
    [self.view addSubview:imgDown];
    
    [imgDown setImage:[UIImage imageNamed:@"icon_down"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImgView) name:MESSAGE_FOR_UPDATE_USER_INFO object:nil];
}

-(void)setUserInfo
{
    UserInfoVIewController *userView = [[UserInfoVIewController alloc] init];
    
    [self presentViewController:userView animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strLeftDentify = @"LEFTVIEWCONTROLLERDENTIFY";
    PersonViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strLeftDentify];
    if (cell==nil)
    {
        cell = [[PersonViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strLeftDentify];
    }
    
    UIView *bgColcor = [[UIView alloc] initWithFrame:cell.bounds];
    
    [bgColcor setBackgroundColor:UIColorFromRGB(0x050e1d)];
    
    [cell setBackgroundColor:UIColorFromRGB(0x050e1d)];
    
    UIView *selectView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenSourchWidth, 45)];
    
    [selectView setBackgroundColor:UIColorFromRGB(0x141b26)];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0,44.5, kScreenSourchWidth, 0.2)];
    line1.backgroundColor = LINE_COLOR;
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0,44.7, kScreenSourchWidth ,0.2)] ;
    line2.backgroundColor = [UIColor whiteColor];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    [selectView addSubview:line1];
    [selectView addSubview:line2];
    
    [cell setSelectedBackgroundView:selectView];
    
    LeftCellInfo *info =[_array objectAtIndex:indexPath.row];
    
    [cell setCellInfo:info.strNorImg name:info.strTitle];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            ResumeViewController *resume = [[ResumeViewController alloc] init];
            [self presentViewController:resume animated:YES completion:nil];
        }
        break;
        case 1:
        {
            ResumeSendListViewController *resume = [[ResumeSendListViewController alloc] init];
            [self presentViewController:resume animated:YES completion:nil];
        }
        break;
        case 2:
        {
            MyPlayViewController *playView = [[MyPlayViewController alloc] init];
            [self presentViewController:playView animated:YES completion:nil];
        }
        break;
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(void)updateImgView
{
    
    NSString *strInfo = [NSString stringWithFormat:@"%@pub/downloadUserPicture?token=%@&userid=%@",
                         KHttpServer,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId];
    [[SDImageCache sharedImageCache] removeImageForKey:strInfo];
    [imgView sd_setImageWithURL:[NSURL URLWithString:strInfo] placeholderImage:[UIImage imageNamed:@"moren_longin"]];
}

@end

@implementation LeftCellInfo

-(id)initWithTitle:(NSString *)strTitle normal:(NSString *)strNormal
{
    self = [super init];
    _strTitle = strTitle;
    _strNorImg = strNormal;
    
    return self;
}
@end
