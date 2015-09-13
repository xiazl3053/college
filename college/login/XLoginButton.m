//
//  XLoginButton.m
//  college
//
//  Created by xiongchi on 15/8/22.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "XLoginButton.h"

@implementation XLoginButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self setBackgroundColor:RGB(255,255,255)];
    
    self.titleLabel.font = XFONT(12);
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:5.0];
    
    return self;
}

@end
