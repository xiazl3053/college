//
//  UpdPwdViewController.m
//  XCMonit_Ip
//
//  Created by 夏钟林 on 14/10/10.
//  Copyright (c) 2014年 夏钟林. All rights reserved.
//

#import "UpdPwdViewController.h"
#import "Toast+UIView.h"
#import "UserInfo.h"
#import "UserModel.h"
#import "ProgressHUD.h"

@interface UpdPwdViewController ()

@property (nonatomic,assign) BOOL bTrue;
@property (nonatomic,strong) UITextField *txtOld;
@property (nonatomic,strong) UITextField *txtNew;
@property (nonatomic,strong) UITextField *txtAuth;

@end

@implementation UpdPwdViewController

-(void)initHeadView
{
    [self setTitleText:@"修改密码"];
    
}

-(void)initBodyView
{
    [self.view setBackgroundColor:RGB(247, 247, 247)];
    [self addViewLine:0 x:93];
    
    _txtOld = [[UITextField alloc] initWithFrame:Rect(0, 64+30, kScreenSourchWidth, 39.5)];
    [self addViewLine:0 x:64+69.5];
    
    [self addViewLine:0 x:64+90];
    
    _txtNew = [[UITextField alloc] initWithFrame:CGRectMake(0, 64+90, kScreenSourchWidth, 39.5)];
    
    [self addViewLine:20 x:64+129.5];
    
    _txtAuth = [[UITextField alloc] initWithFrame:CGRectMake(0, 64+130.5, kScreenSourchWidth, 39.5)];
    
    [self addViewLine:0 x:64+170];
    
    [self.view addSubview:_txtOld];
    [self.view addSubview:_txtNew];
    [self.view addSubview:_txtAuth];
    
    [_txtNew setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [_txtOld setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [_txtAuth setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    
    UIImageView *imgPwd = [[UIImageView alloc] init];
    imgPwd.frame = Rect(0, 0, 20, 39.5);
    _txtNew.leftView = imgPwd;
    _txtNew.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _txtNew.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *imgPwd1 = [[UIImageView alloc] init];
    imgPwd1.frame = Rect(0, 0, 20, 39.5);
    _txtOld.leftView = imgPwd1;
    _txtOld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _txtOld.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIImageView *imgPwd2 = [[UIImageView alloc] init];
    imgPwd2.frame = Rect(0, 0, 20, 39.5);
    _txtAuth.leftView = imgPwd2;
    _txtAuth.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _txtAuth.leftViewMode = UITextFieldViewModeAlways;
    
    [_txtNew setSecureTextEntry:YES];
    [_txtOld setSecureTextEntry:YES];
    [_txtAuth setSecureTextEntry:YES];
    
    [_txtNew setBorderStyle:UITextBorderStyleNone];
    [_txtOld setBorderStyle:UITextBorderStyleNone];
    [_txtAuth setBorderStyle:UITextBorderStyleNone];
    [_txtNew setReturnKeyType:UIReturnKeyNext];
    [_txtOld setReturnKeyType:UIReturnKeyNext];
    [_txtAuth setReturnKeyType:UIReturnKeyDone];
    UIColor *color = [UIColor grayColor];
    _txtOld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:XCLocalized(@"oldPwd") attributes:@{NSForegroundColorAttributeName: color}];
    _txtAuth.attributedPlaceholder = [[NSAttributedString alloc] initWithString:XCLocalized(@"pwdCom") attributes:@{NSForegroundColorAttributeName: color}];
    _txtNew.attributedPlaceholder = [[NSAttributedString alloc] initWithString:XCLocalized(@"newpwd") attributes:@{NSForegroundColorAttributeName: color}];//newpwd
    [_txtOld setBackgroundColor:RGB(255, 255, 255)];
    [_txtAuth setBackgroundColor:RGB(255, 255, 255)];
    [_txtNew setBackgroundColor:RGB(255, 255, 255)];
}
-(void)addViewLine:(CGFloat)fHeight x:(CGFloat)nX
{
    UILabel *sLine3 = [[UILabel alloc] initWithFrame:CGRectMake(nX, fHeight+0.5, kScreenSourchWidth, 0.5)];
    sLine3.backgroundColor = [UIColor colorWithRed:205/255.0
                                             green:205/255.0
                                              blue:205/255.0
                                             alpha:1.0];
    UILabel *sLine4 = [[UILabel alloc] initWithFrame:CGRectMake(nX, fHeight+1, kScreenSourchWidth, 0.5)] ;
    sLine4.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sLine3];
    [self.view addSubview:sLine4];
}
-(void)navBack
{
    if(_bTrue)
    {
        return ;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)updPwdInfo
{
    NSString *oldPwd = _txtOld.text;
    NSString *newPwd = _txtNew.text;
    NSString *authPwd = _txtAuth.text;
    if ([oldPwd isEqualToString:@""])
    {
        [self.view makeToast:XCLocalized(@"oldEmpty")];
        return;
    }
    if ([newPwd isEqualToString:@""]) {
        [self.view makeToast:XCLocalized(@"newEmpty")];
        return;
    }
    if ([authPwd isEqualToString:@""]) {
        [self.view makeToast:XCLocalized(@"comEmpty")];
        return;
    }
    
    if ([newPwd length]<6)
    {
        [self.view makeToast:XCLocalized(@"pwdLength")];
        return;
    }
    
    if ([newPwd length]>64)
    {
        [self.view makeToast:XCLocalized(@"pwdThan64")];
        return;
    }
    
    if([oldPwd isEqualToString:@""])
    {
        [self.view makeToast:XCLocalized(@"oldError")];
        return;
    }
    
    if (![authPwd isEqualToString:newPwd])
    {
        [self.view makeToast:XCLocalized(@"newError")];
        return;
    }
    
}

-(void)keyBoardHidden
{
    if ([_txtAuth isFirstResponder]) {
        [_txtAuth resignFirstResponder];
    }
    else if([_txtNew isFirstResponder])
    {
        [_txtNew resignFirstResponder];
    }
    else if([_txtOld isFirstResponder])
    {
        [_txtOld resignFirstResponder];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden) name:NSKEY_BOARD_RETURN_VC object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initHeadView];
    [self initBodyView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 重力处理
- (BOOL)shouldAutorotate
{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
