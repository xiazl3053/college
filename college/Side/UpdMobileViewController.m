//
//  UpdMobileViewController.m
//  XCMonit_Ip
//
//  Created by 夏钟林 on 14/10/11.
//  Copyright (c) 2014年 夏钟林. All rights reserved.
//

#import "UpdMobileViewController.h"

@interface UpdMobileViewController ()

@property (nonatomic,strong) UITextField *txtMobile;

@end

@implementation UpdMobileViewController
-(void)initHeadView
{
    
}

-(void)updateMobile
{
    
}

-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initHeadView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
