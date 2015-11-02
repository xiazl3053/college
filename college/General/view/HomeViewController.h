//
//  HomeViewController.h
//  college
//
//  Created by xiongchi on 15/8/29.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIControl+BlocksKit.h"

@interface HomeViewController : UIViewController

@property (nonatomic,strong) UIButton *btnLeft;

-(void)updateImage;

-(void)setViewBgColor:(UIColor *)bgColor;

-(void)setTitleText:(NSString *)strText;

-(void)setLeftBtn:(UIButton *)btnLeft;

-(void)setRightBtn:(UIButton *)btnRight;

-(void)addLeftEvent:(void (^)(id sender))handler;



@end
