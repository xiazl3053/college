//
//  LoginInfoViewController.m
//  college
//
//  Created by xiongchi on 15/8/23.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "LoginInfoViewController.h"
#import "XLoginButton.h"
#import "Toast+UIView.h"
#import "UserInfo.h"
#import "BaseService.h"
#import "UserSettingViewController.h"

@interface LoginInfoViewController ()
{
//    UIImageView *imgStu;
//    UIImageView *imgBus;
    UIButton *btnStudent;
    UIButton *btnBuss;
    UILabel *lblStudent;
    UILabel *lblBuss;
}
@end

@implementation LoginInfoViewController

-(void)initView
{
    btnBuss = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStudent = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnStudent.frame = Rect((kScreenAppWidth/2-104)/2,100, 104 , 115);
    btnBuss.frame = Rect(kScreenAppWidth/2+btnStudent.x, 100, 104, 115);
    
    [btnBuss setImage:[UIImage imageNamed:@"first_busy"] forState:UIControlStateNormal];
    [btnBuss setImage:[UIImage imageNamed:@"first_busy_pressed"] forState:UIControlStateSelected];
    [btnBuss setImage:[UIImage imageNamed:@"first_busy_pressed"] forState:UIControlStateHighlighted];
    
    [btnStudent setImage:[UIImage imageNamed:@"first_school"] forState:UIControlStateNormal];
    [btnStudent setImage:[UIImage imageNamed:@"first_school_pressed"] forState:UIControlStateSelected];
    [btnStudent setImage:[UIImage imageNamed:@"first_school_pressed"] forState:UIControlStateHighlighted];
    
    [self.view addSubview:btnStudent];
    [self.view addSubview:btnBuss];
    [btnBuss addTarget:self action:@selector(tapEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btnStudent addTarget:self action:@selector(tapEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    lblStudent = [[UILabel alloc] initWithFrame:Rect(btnStudent.x, btnStudent.y+btnStudent.height+20, btnStudent.width, 20)];
    [lblStudent setText:@"学生"];
    [lblStudent setTextColor:UIColorFromRGB(0xFFFFFF)];
    [lblStudent setTextAlignment:NSTextAlignmentCenter];
    [lblStudent setFont:XFONT(14)];
    [self.view addSubview:lblStudent];
    
    lblBuss = [[UILabel alloc] initWithFrame:Rect(btnBuss.x, btnBuss.y+btnBuss.height+20, btnBuss.width, 20)];
    [lblBuss setText:@"商家"];
    [lblBuss setTextColor:UIColorFromRGB(0xFFFFFF)];
    [lblBuss setTextAlignment:NSTextAlignmentCenter];
    [lblBuss setFont:XFONT(15)];
    [self.view addSubview:lblBuss];
    
    XLoginButton *btnPress = [[XLoginButton alloc ] initWithFrame:Rect(10, btnStudent.y+btnStudent.height+150, kScreenSourchWidth-20, 45)];
    [btnPress setTitle:@"下一步" forState:UIControlStateNormal];
    btnPress.titleLabel.font = XFONT(15);
    [btnPress setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:btnPress];
    [btnPress addTarget:self action:@selector(enterInfo) forControlEvents:UIControlEventTouchUpInside];
    btnStudent.selected = YES;
}



-(void)enterInfo
{
    [self.view makeToastActivity];
    NSString *strInfo = [NSString stringWithFormat:@"%@pub/updateUser?token=%@",KHttpServer,[UserInfo sharedUserInfo].strToken];
    NSNumber *numberInfo = nil;
    if (btnStudent.selected)
    {
        numberInfo = [[NSNumber alloc] initWithInt:1];
    }
    else
    {
        numberInfo = [[NSNumber alloc] initWithInt:2];
    }
    NSDictionary *parameter = @{@"userid":[UserInfo sharedUserInfo].strUserId,@"type":numberInfo};
    __weak LoginInfoViewController *__self = self;
    [BaseService postJSONWithUrl:strInfo parameters:parameter success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[dict objectForKey:@"status"] intValue]==200) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [__self.view hideToastActivity];
                 UserSettingViewController *userSet = [[UserSettingViewController alloc] init];
                 [__self presentViewController:userSet animated:YES completion:nil];
             });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self.view hideToastActivity];
                [__self.view makeToast:[dict objectForKey:@"msg"]];
            });
        }
    } fail:^(NSError *error){
           dispatch_async(dispatch_get_main_queue(), ^{
               [__self.view hideToastActivity];
               [__self.view makeToast:@"连接服务器错误"];
           });
    }];
//    
//    UserSettingViewController *userSet = [[UserSettingViewController alloc] init];
//    [self presentViewController:userSet animated:YES completion:nil];
}

-(void)tapEvent:(UIButton *)btnSender
{
    btnSender.selected = YES;
    if (btnSender == btnStudent)
    {
        btnBuss.selected = NO;
    }
    else
    {
        btnStudent.selected = NO;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(255, 71, 0)];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
}






@end

