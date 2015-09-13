//
//  XInTextField.m
//  college
//
//  Created by xiongchi on 15/9/2.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "XInTextField.h"

@interface XInTextField()
{
    UILabel *lblName;
}
@end

@implementation XInTextField


-(id)initWithFrame:(CGRect)frame name:(NSString *)strName
{
    self = [super initWithFrame:frame];
    
    lblName = [[UILabel alloc] initWithFrame:Rect(5,0,frame.size.width, frame.size.height)];
    
    [self addSubview:lblName];
    
    [lblName setTextColor:UIColorFromRGB(0x000000)];
    
    [self setTextAlignment:NSTextAlignmentRight];
    
    [self setTextColor:[UIColor grayColor]];
    
    [self setBorderStyle:UITextBorderStyleNone];
    
    [self setFont:XFONT(12)];
    
    [lblName setFont:XFONT(12)];
    
    [lblName setText:strName];
    
    return self;
}

-(void)setNameFont:(UIFont *)font
{
    [self setFont:font];
    [lblName setFont:font];
}

@end
