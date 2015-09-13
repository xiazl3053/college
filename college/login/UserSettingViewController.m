//
//  UserSettingViewController.m
//  college
//
//  Created by xiongchi on 15/8/25.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "UserSettingViewController.h"
#import "XLoginTextField.h"
#import "AppDelegate.h"
#import "XLoginButton.h"

@interface UserSettingViewController ()<UITextFieldDelegate>
{
    UIImageView *imgHead;
    UITextField *_txtFieldView;
    XLoginTextField *txtName;
    XLoginTextField *txtSchool;
}
@end

@implementation UserSettingViewController

-(void)initView
{
    imgHead = [[UIImageView alloc] initWithFrame:Rect(kScreenSourchWidth/2-39.5, 74,79, 79)];
    [imgHead setImage:[UIImage imageNamed:@"moren_longin"]];
    
    UILabel *lblInfo = [[UILabel alloc] initWithFrame:Rect(imgHead.x, imgHead.y+imgHead.height+12, 79, 20)];
    [lblInfo setText:@"设置头像"];
    [lblInfo setTextColor:UIColorFromRGB(0xFFFFFF)];
    [lblInfo setFont:XFONT(12)];
    [self.view addSubview:lblInfo];
    [lblInfo setTextAlignment:NSTextAlignmentCenter];
    
    txtName = [[XLoginTextField alloc] initWithFrame:Rect(30, 230, kScreenSourchWidth-60, 45)];
    txtSchool = [[XLoginTextField alloc] initWithFrame:Rect(30, txtName.y+txtName.height+19, txtName.width, txtName.height)];
    
    [self.view addSubview:imgHead];
    [self.view addSubview:txtName];
    [self.view addSubview:txtSchool];
    
    UIColor *color = UIColorFromRGB(0xFFFFFF);
    txtName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请设置昵称" attributes:@{NSForegroundColorAttributeName: color}];
    txtSchool.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入学校" attributes:@{NSForegroundColorAttributeName: color}];
    [txtName setBackgroundColor:UIColorFromRGB(0xfe864a)];
    [txtSchool setBackgroundColor:UIColorFromRGB(0xfe864a)];
    [txtName setTextAlignment:NSTextAlignmentCenter];
    [txtSchool setTextAlignment:NSTextAlignmentCenter];
    txtSchool.layer.borderColor = [UIColor clearColor].CGColor;
    txtName.layer.borderColor = [UIColor clearColor].CGColor;
    
    XLoginButton *btnStart = [[XLoginButton alloc] initWithFrame:Rect(10, txtSchool.y+txtSchool.height+60, kScreenSourchWidth-20, 45)];
    [btnStart setTitle:@"开启征程" forState:UIControlStateNormal];
    [btnStart setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
    
    [self.view addSubview:btnStart];
    [txtName setDelegate:self];
    [txtSchool setDelegate:self];
    [btnStart addTarget:self action:@selector(startEvent) forControlEvents:UIControlEventTouchUpInside];
}

-(void)startEvent
{
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setMainRootView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:MAIN_COLOR];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

@end
