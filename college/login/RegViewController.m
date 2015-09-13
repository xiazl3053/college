//
//  RegViewController.m
//  college
//
//  Created by xiongchi on 15/8/22.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "RegViewController.h"
#import "Toast+UIView.h"
#import "UserInfo.h"
#import "UserModel.h"
#import "LoginUserDB.h"
#import "HttpService.h"
#import "AFHTTPRequestOperationManager.h"
#import "BaseService.h"
#import "XRegField.h"
#import "LoginInfoViewController.h"
#import "XLoginButton.h"

@interface RegViewController ()<UITextFieldDelegate>
{
    int nSecond;
    NSTimer *_timer;
    XRegField *txtPhone;
    XRegField *txtCode;
    XRegField *txtPwd;
    XRegField *txtPwdAgain;
    UIImageView *imgCode;
    UIImageView *imgHead;
    UITextField *_txtFieldView;
    UIButton *btnTimer;
}
@end

@implementation RegViewController

-(void)dealloc
{
    DLog(@"dealloc!");
}

-(void)initView
{
    imgHead = [[UIImageView alloc] initWithFrame:Rect(kScreenSourchWidth/2-64,64,128,48)];
    [self.view addSubview:imgHead];
    [imgHead setImage:[UIImage imageNamed:@"logo_school"]];
    
    UIView *bodyView = [[UIView alloc] initWithFrame:Rect(10, 140, kScreenSourchWidth-20, 251)];
    [bodyView setBackgroundColor:UIColorFromRGB(0xfff6f1)];
    [bodyView.layer setMasksToBounds:YES];
    [bodyView.layer setCornerRadius:5.0f];
    
    txtPhone = [[XRegField alloc] initWithFrame:Rect(10, 20, bodyView.width-20, 45) imageName:@"login_register_icon"];
    txtCode = [[XRegField alloc] initWithFrame:Rect(10, txtPhone.y+txtPhone.height+10, bodyView.width-120, 45) imageName:@"login_code_icon"];
    
    btnTimer = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnTimer setTitle:@"发送验证码" forState:UIControlStateNormal];
    [btnTimer setBackgroundColor:RGB(255, 71, 0)];
    [btnTimer setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [btnTimer setTitleColor:RGB(0, 0, 0) forState:UIControlStateHighlighted];
    btnTimer.titleLabel.font = XFONT(12);
    [bodyView addSubview:btnTimer];
    
    btnTimer.frame = Rect(txtCode.x+txtCode.width+10, txtCode.y, 90, 45);
    [btnTimer.layer setMasksToBounds:YES];
    [btnTimer.layer setCornerRadius:5.0f];
    [btnTimer addTarget:self action:@selector(resetMobile) forControlEvents:UIControlEventTouchUpInside];
    
    txtPwd = [[XRegField alloc] initWithFrame:Rect(10, txtCode.y+txtCode.height+10, bodyView.width-20, 45) imageName:@"login_password_icon"];
    txtPwdAgain = [[XRegField alloc] initWithFrame:Rect(10, txtPwd.y+txtPwd.height+10, bodyView.width-20, 45) imageName:@"login_password_icon"];
    
    [bodyView addSubview:txtPhone];
    [bodyView addSubview:txtCode];
    [bodyView addSubview:txtPwd];
    [bodyView addSubview:txtPwdAgain];
    
    [self.view addSubview:bodyView];
    
    UIColor *color = UIColorFromRGB(0xdddddf);
    txtPhone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号码" attributes:@{NSForegroundColorAttributeName: color}];
    txtCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName: color}];
    txtPwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    txtPwdAgain.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"确认密码" attributes:@{NSForegroundColorAttributeName: color}];
   
    [txtPwd setSecureTextEntry:YES];
    [txtPwdAgain setSecureTextEntry:YES];
    
    txtPwd.delegate = self;
    txtPhone.delegate = self;
    txtCode.delegate = self;
    txtPwdAgain.delegate = self;
    
    [txtPhone setKeyboardType:UIKeyboardTypeNumberPad];
    [txtCode setKeyboardType:UIKeyboardTypeNumberPad];
    
    XLoginButton *btnLogin = [[XLoginButton alloc] initWithFrame:Rect(10,bodyView.y+bodyView.height+20,kScreenSourchWidth/2-15,45)];
    
    XLoginButton *btnReg = [[XLoginButton alloc] initWithFrame:Rect(btnLogin.x+btnLogin.width+10,bodyView.y+bodyView.height+20,kScreenSourchWidth/2-15,45)];
    
    [btnLogin setTitle:@"注册" forState:UIControlStateNormal];
    
    [btnReg setTitle:@"取消" forState:UIControlStateNormal];
    
    [btnReg setTitleColor:UIColorFromRGB(0x2b7ea8) forState:UIControlStateNormal];
    
    [self.view addSubview:btnLogin];
    
    [self.view addSubview:btnReg];
    
    [btnLogin addTarget:self action:@selector(regEvent) forControlEvents:UIControlEventTouchUpInside];
    [btnReg addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    txtPhone.text = @"17727610912";
    
    txtPwd.text =@"123456";
    
    txtPwdAgain.text = @"123456";
}

-(void)navBack
{
    [_timer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)regEvent
{
    NSString *strPhone = txtPhone.text;
    NSString *strCode = txtCode.text;
    NSString *strPwd = txtPwd.text;
    NSString *strConPwd = txtPwdAgain.text;
    
    if (strPhone==nil || [strPhone isEqualToString:@""])
    {
        [self.view makeToast:@"手机号不能为空"];
        return ;
    }
    
    if (strCode == nil || [strCode isEqualToString:@""]) {
        [self.view makeToast:@"验证码不能为空"];
        return ;
    }
    
    if (strPwd == nil || [strPwd isEqualToString:@""])
    {
        [self.view makeToast:@"密码不能为空"];
        return ;
    }
    
    if (strConPwd == nil || [strConPwd isEqualToString:@""])
    {
        [self.view makeToast:@"确认密码不鞥为空"];
        return ;
    }
   
    if (![strConPwd isEqualToString:strPwd])
    {
        [self.view makeToast:@"两次密码不一致"];
        return ;
    }
    [self.view makeToastActivity];
   
    NSString *strInfo = [NSString stringWithFormat:@"%@pub/regMobile?mobile=%@&check_msg=%@&password=%@",KHttpServer,strPhone,strCode,strPwd];
    
    __weak RegViewController *__regInfo = self;
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id responseObject)
    {
        dispatch_async(dispatch_get_main_queue(), ^{[__regInfo.view hideToastActivity];});
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        DLog(@"dict:%@",dict);
        
        if([[dict objectForKey:@"status"] intValue]==200)
        {
            [[UserInfo sharedUserInfo] setUserDict:[dict objectForKey:@"user"]];
            UserModel *userDl = [[UserModel alloc] init];
            userDl.strToken = [UserInfo sharedUserInfo].strToken;
            userDl.strUser = [UserInfo sharedUserInfo].strUserId;
            userDl.strPwd = [UserInfo sharedUserInfo].strPwd;
            userDl.nLogin = 1;
            [LoginUserDB updateSaveInfo:userDl];
            
            LoginInfoViewController *loginInfo = [[LoginInfoViewController alloc] init];
            [__regInfo presentViewController:loginInfo animated:YES completion:nil];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__regInfo.view makeToast:[dict objectForKey:@"msg"]];
            });
        }
    }
    fail:^(NSError *error)
    {
        DLog(@"失败");
    }];
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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


-(void)resetMobile
{
    btnTimer.enabled = NO;
    NSString *strInfo = [NSString stringWithFormat:@"%@pub/getMobileCheckMsg?mobile=%@",KHttpServer,txtPhone.text];
    NSDictionary *parameters = @{@"mobile":txtPhone.text};
    DLog(@"strInfo:%@",strInfo);
    __weak RegViewController *__self = self;
    [BaseService postJSONWithUrl:strInfo parameters:parameters
        success:^(id responseObject)
        {
            [__self comeOn:responseObject];
        }
    fail:
     ^(NSError *error)
    {
         DLog(@"error:%@",error);
     }
     ];
    [self.view makeToast:@"发送到目标手机"];
    nSecond = 59;
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

-(void)comeOn:(NSData *)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    DLog(@"dict:%@",dict);
    if ([[dict objectForKey:@"status"] intValue]==200)
    {
        __weak XRegField *__txtCode = txtCode;
        __block NSString *__strInfo = [dict objectForKey:@"check_msg"];
        dispatch_async(dispatch_get_main_queue(),
        ^{
            __txtCode.text = __strInfo;
        });
    }
}

-(void)animation1
{
    if (nSecond==0)
    {
        btnTimer.enabled  = YES;
        [btnTimer setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        return ;
    }
    NSString *strInfo = [NSString stringWithFormat:@"%d秒",nSecond];
    [btnTimer setTitle:strInfo forState:UIControlStateNormal];
    nSecond--;
}

@end
