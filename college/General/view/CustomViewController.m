//
//  CustomViewController.m
//  FreeCar
//
//  Created by xiongchi on 15/8/1.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "CustomViewController.h"
#import "UIView+Extension.h"

@interface CustomViewController ()

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIButton *btnLeft;
@property (nonatomic,strong) UIButton *btnRight;
@property (nonatomic,strong) UILabel *txtTitle;

@end

@implementation CustomViewController

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
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateHighlighted];
    
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftBtn:btnBack];
}

-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
