//
//  UpdNikNameViewController.m
//  XCMonit_Ip
//
//  Created by 夏钟林 on 14/10/11.
//  Copyright (c) 2014年 夏钟林. All rights reserved.
//

#import "UpdNikNameViewController.h"
#import "Toast+UIView.h"
#import "ProgressHUD.h"

@interface UpdNikNameViewController ()

@property (nonatomic,strong) UITextField *txtNick;

@end

@implementation UpdNikNameViewController
-(void)initHeadView
{
    
    [self setTitleText:@"昵称修改"];
}
-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)updateNickName
{
    [_txtNick resignFirstResponder];
    NSString *strEmail = [_txtNick text];
    if ([strEmail isEqualToString:@""])
    {
        [self.view makeToast:@"昵称不能为空"];
        return;
    }
    
    if ([strEmail length]>64)
    {
        [self.view makeToast:@"昵称不能超过64位"];
        return ;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeadView];
    _txtNick = [[UITextField alloc] initWithFrame:Rect(0, 64+20, kScreenSourchWidth, 39.5)];
    [self.view addSubview:_txtNick];
    [_txtNick setBorderStyle:UITextBorderStyleNone];
    [self.view setBackgroundColor:RGB(247, 247, 247)];
    UIImageView *imgPwd = [[UIImageView alloc] init];
    imgPwd.frame = Rect(0, 0, 20, 39.5);
    _txtNick.leftView = imgPwd;
    _txtNick.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _txtNick.leftViewMode = UITextFieldViewModeAlways;
    UIColor *color = [UIColor grayColor];
    _txtNick.attributedPlaceholder = [[NSAttributedString alloc] initWithString:XCLocalized(@"Nickname") attributes:@{NSForegroundColorAttributeName: color}];
    [_txtNick setReturnKeyType:UIReturnKeyDone];
    [_txtNick setBackgroundColor:[UIColor whiteColor]];
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

-(void)closeKeyBoard
{
    [_txtNick resignFirstResponder];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
