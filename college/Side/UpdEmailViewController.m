//
//  UpdEmailViewController.m
//  XCMonit_Ip
//
//  Created by 夏钟林 on 14/10/10.
//  Copyright (c) 2014年 夏钟林. All rights reserved.
//

#import "UpdEmailViewController.h"
#import "Toast+UIView.h"

@interface UpdEmailViewController ()

@property (nonatomic,strong) UITextField *txtEmail;

@end

@implementation UpdEmailViewController

-(void)initHeadView
{
    [self setTitleText:@"修改邮箱"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initHeadView];
    _txtEmail = [[UITextField alloc] initWithFrame:Rect(0, 64+20, kScreenSourchWidth, 39.5)];
    [self.view addSubview:_txtEmail];
    [_txtEmail setBorderStyle:UITextBorderStyleNone];
    [self.view setBackgroundColor:RGB(247, 247, 247)];
    UIImageView *imgPwd = [[UIImageView alloc] init];
    imgPwd.frame = Rect(0, 0, 20, 39.5);
    _txtEmail.leftView = imgPwd;
    _txtEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _txtEmail.leftViewMode = UITextFieldViewModeAlways;
    UIColor *color = [UIColor grayColor];
    _txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:XCLocalized(@"email") attributes:@{NSForegroundColorAttributeName: color}];
    [_txtEmail setReturnKeyType:UIReturnKeyDone];
    [_txtEmail setBackgroundColor:[UIColor whiteColor]];
    
}

-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateEmail
{
    [_txtEmail resignFirstResponder];
    NSString *strEmail = [_txtEmail text];
    if ([strEmail isEqualToString:@""]) {
        [self.view makeToast:@"EMAIL不能为空"];
        return;
    }
    
    if (![self validateEmail:strEmail])
    {
        [self.view makeToast:@"Email格式不对"];
        return;
    }
    
}

- (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

-(void)dealloc
{
    
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


@end
