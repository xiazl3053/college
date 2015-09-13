//
//  PlayViewController.m
//  FreeCar
//
//  Created by xiongchi on 15/7/21.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "UIView+Extension.h"

@interface MainViewController()
{
    
}

@end

@implementation MainViewController

-(void)initHeadView
{
    [self setTitleText:@"Live preview"];
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"btn_set_normal"] forState:UIControlStateHighlighted];
    [btnLeft setImage:[UIImage imageNamed:@"btn_set_high"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftBtn:btnLeft];
    
}

-(void)rightClick
{
    
}

-(void)leftClick
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(0, 0, 0)];
    [self initHeadView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)stopPlay
{
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
}
- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
}
-(BOOL)shouldAutorotate
{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
