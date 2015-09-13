//
//  LoginViewController.m
//  college
//
//  Created by xiongchi on 15/8/22.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "LoginViewController.h"
#import "XLoginTextField.h"
#import "LoginUserDB.h"
#import "UserModel.h"
#import "LoginInfoViewController.h"
#import "RegViewController.h"
#import "AppDelegate.h"
#import "XLoginButton.h"
#import "Toast+UIView.h"
#import "BaseService.h"
#import "UserInfo.h"

//255,71,0
@interface LoginViewController ()<UITextFieldDelegate>
{
    UIImageView *imgHead;
    XLoginTextField *xtxUser;
    XLoginTextField *xtxPwd;
    UITextField *_txtFieldView;
}

@end

@implementation LoginViewController

-(void)initView
{
    imgHead = [[UIImageView alloc] initWithFrame:Rect(kScreenSourchWidth/2-64,150,128,48)];
    [self.view addSubview:imgHead];
    [imgHead setImage:[UIImage imageNamed:@"logo_school"]];
    
    UIView *bodyView = [[UIView alloc] initWithFrame:Rect(10, 280, kScreenSourchWidth-20, 160)];
    [bodyView setBackgroundColor:UIColorFromRGB(0xfff6f1)];
    [bodyView.layer setMasksToBounds:YES];
    [bodyView.layer setCornerRadius:5.0f];
    
    xtxUser = [[XLoginTextField alloc] initWithFrame:Rect(10, 49,bodyView.width-20, 45) leftView:@"login_user_icon"];
    
    xtxPwd = [[XLoginTextField alloc] initWithFrame:Rect(10, 104, bodyView.width-20, 45) leftView:@"login_password_icon"];
    
    UIColor *color = UIColorFromRGB(0xdddddf);
    xtxUser.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入用户名" attributes:@{NSForegroundColorAttributeName: color}];
    xtxPwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    xtxUser.tag = 10001;
    xtxPwd.tag = 10002;
    xtxUser.delegate = self;
    
    xtxPwd.delegate = self;
    
    [xtxPwd setSecureTextEntry:YES];
    
    [bodyView addSubview:xtxUser];
    [bodyView addSubview:xtxPwd];
   
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:Rect(kScreenSourchWidth/2-39.5, 241, 79, 79)];
    [imgView setImage:[UIImage imageNamed:@"firstFace"]];
    [self.view addSubview:bodyView];
    [self.view addSubview:imgView];
    
    XLoginButton *btnLogin = [[XLoginButton alloc] initWithFrame:Rect(10,bodyView.y+bodyView.height+20,kScreenSourchWidth/2-15,45)];
    
    XLoginButton *btnReg = [[XLoginButton alloc] initWithFrame:Rect(btnLogin.x+btnLogin.width+10,bodyView.y+bodyView.height+20,kScreenSourchWidth/2-15,45)];
    
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    
    [btnReg setTitle:@"注册" forState:UIControlStateNormal];
    
    [btnReg setTitleColor:UIColorFromRGB(0x2b7ea8) forState:UIControlStateNormal];
    
    [self.view addSubview:btnLogin];
    
    [self.view addSubview:btnReg];
    
    [btnLogin addTarget:self action:@selector(loginEvent) forControlEvents:UIControlEventTouchUpInside];
    [btnReg addTarget:self action:@selector(regEvent) forControlEvents:UIControlEventTouchUpInside];
    
    xtxUser.text = @"17727610912";
    xtxPwd.text = @"123456";
}

-(void)dealloc
{
    DLog(@"dealloc");
}

-(void)loginEvent
{
    NSString *strPhone = xtxUser.text;
    NSString *strPwd = xtxPwd.text;
    
    if (strPhone == nil || [strPhone isEqualToString:@""]) {
        [self.view makeToast:@"手机号不能为空"];
        return ;
    }
    
    if (strPwd == nil || [strPwd isEqualToString:@""]) {
        [self.view makeToast:@"密码不能为空"];
        return ;
    }
    [self.view makeToastActivity];
    
    NSString *strInfo = [NSString stringWithFormat:@"%@pub/login?mobile=%@&password=%@",KHttpServer,strPhone,strPwd];
    __weak LoginViewController *__self = self;
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id reponseObject)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:reponseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        if ([[dict objectForKey:@"status"] intValue]==200)
        {
            UserInfo *info = [UserInfo sharedUserInfo];
            info.strToken = [dict objectForKey:@"token"];
            NSDictionary *user = [dict objectForKey:@"user"];
            [info setUserDict:user];
            
            UserModel *userDl = [[UserModel alloc] init];
            userDl.strToken = [UserInfo sharedUserInfo].strToken;
            userDl.strUser = [UserInfo sharedUserInfo].strUserId;
            userDl.strPwd = [UserInfo sharedUserInfo].strPwd;
            userDl.nLogin = 1;
            [LoginUserDB updateSaveInfo:userDl];
            
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__self.view hideToastActivity];
                [__self.view removeFromSuperview];
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] setMainRootView];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),
           ^{
               [__self.view hideToastActivity];
               [__self.view makeToast:[dict objectForKey:@"msg"]];
           });
        }
    }
    fail:^(NSError *error)
    {
        DLog(@"error:%@",error);
    }];
    
}

-(void)regEvent
{
    RegViewController *regView = [[RegViewController alloc] init];
    [self presentViewController:regView animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(255, 71, 0)];
    [self initView];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)KeyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    //获取高度
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    /*关键的一句，网上关于获取键盘高度的解决办法，多到这句就over了。系统宏定义的UIKeyboardBoundsUserInfoKey等测试都不能获取正确的值。不知道为什么。。。*/
    CGSize keyboardSize = [value CGRectValue].size;
    if (_txtFieldView==nil)
    {
        return ;
    }
    CGFloat move = (_txtFieldView.superview.y+_txtFieldView.y+_txtFieldView.height)-(self.view.height-keyboardSize.height);
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.30f];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(move > 0)
    {
        self.view.frame = CGRectMake(0.0f, -move, self.view.width, self.view.height);
    }
    [UIView commitAnimations];
}

-(void)KeyboardEditing:(NSNotification *)notification
{
    _txtFieldView = notification.object;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.view.y<0)
    {
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:0.30f];
        self.view.frame = CGRectMake(0.0f, 0, self.view.width, self.view.height);
        [UIView commitAnimations];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)loginInfo
{
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



@end
