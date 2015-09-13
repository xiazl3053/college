//
//  XView.m
//  college
//
//  Created by xiongchi on 15/9/2.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "XView.h"

@implementation XView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
    
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:5.0];
    
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = LINE_COLOR.CGColor;
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
