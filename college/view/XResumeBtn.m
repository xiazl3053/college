//
//  XResumeBtn.m
//  college
//
//  Created by xiongchi on 15/9/5.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "XResumeBtn.h"

@implementation XResumeBtn

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self setBackgroundColor:RGB(255,255,255)];
    
    self.titleLabel.font = XFONT(12);
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:5.0];
    [self.layer setBorderWidth:0.5];
    [self.layer setBorderColor:LINE_COLOR.CGColor];
    
    return self;
}

@end
