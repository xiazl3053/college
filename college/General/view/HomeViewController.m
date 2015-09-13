//
//  HomeViewController.m
//  college
//
//  Created by xiongchi on 15/8/29.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "HomeViewController.h"

#import "UserInfo.h"
#import "BaseService.h"
#import "AppDelegate.h"
#import "UIButton+WebCache.h"


@interface HomeViewController ()

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIButton *btnLeft;
@property (nonatomic,strong) UIButton *btnRight;
@property (nonatomic,strong) UILabel *txtTitle;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _headView  = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenAppWidth,64)];
    [self.view addSubview:_headView];
    [_headView setBackgroundColor:RGB(255, 71, 0)];
    _txtTitle = [[UILabel alloc] initWithFrame:Rect(44,33,kScreenAppWidth-88, 20)];
    [_txtTitle setFont:XFONT(15)];
    [_headView addSubview:_txtTitle];
    [_txtTitle setTextAlignment:NSTextAlignmentCenter];
    [_txtTitle setTextColor:[UIColor whiteColor]];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:Rect(10, 30, 17, 22)];
    
    [_headView addSubview:imgView];
    
    [imgView setImage:[UIImage imageNamed:@"more"]];
    
    _btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_headView addSubview:_btnLeft];
    
    _btnLeft.frame = Rect(imgView.x+imgView.width+5, 25, 32, 32);
    
    [_btnLeft.layer setMasksToBounds:YES];
    
    [_btnLeft.layer setCornerRadius:16];
    
    [_btnLeft addTarget:self action:@selector(showLeftView) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage) name:MESSAGE_FOR_UPDATE_USER_INFO object:nil];
}

-(void)updateImage
{
    NSString *strInfo = [NSString stringWithFormat:@"%@pub/downloadUserPicture?token=%@&userid=%@",
                         KHttpServer,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId];
    
    [_btnLeft sd_setBackgroundImageWithURL:[NSURL URLWithString:strInfo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"moren_longin"]];
}

-(void)showLeftView
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showLeftView];
}

-(void)addLeftEvent:(void (^)(id))handler
{
    [_btnLeft bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)setViewBgColor:(UIColor *)bgColor
{
    [_headView setBackgroundColor:bgColor];
}

-(void)setTitleText:(NSString *)strText
{
    [_txtTitle setText:strText];
}
-(void)setLeftBtn:(UIButton *)btnLeft
{
    _btnLeft = btnLeft;
    _btnLeft.frame = Rect(0, 20, 44, 44);
    [_headView addSubview:_btnLeft];
}
-(void)setRightBtn:(UIButton *)btnRight
{
    _btnRight = btnRight;
    _btnRight.frame = Rect(_headView.width-44, 20, 44, 44);
    [_headView addSubview:_btnRight];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
