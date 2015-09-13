//
//  XViewTextField.m
//  college
//
//  Created by xiongchi on 15/9/8.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "XViewTextField.h"
@interface XViewTextField()
{
    
        UILabel *line1;
        UILabel *line2;
}
@end

@implementation XViewTextField

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    _lblTitle = [[UILabel alloc] initWithFrame:Rect(10, 1, 100, frame.size.height-1)];
    
    [self addSubview:_lblTitle];
    
    _txtContent = [[UITextField alloc] initWithFrame:Rect(110,1, frame.size.width-120, frame.size.height-1)];
    
    [self addSubview:_txtContent];
    
    [_lblTitle setFont:XFONT(14)];
    
    [_lblTitle setTextColor:UIColorFromRGB(0x8e8c97)];
    
    [_txtContent setFont:XFONT(14)];
    
    [_txtContent setTextColor:UIColorFromRGB(0x222222)];
    
    [_txtContent setTextAlignment:NSTextAlignmentRight];
    
    [self addLineView];
    
    return self;
}

-(void)addLineView
{
    line1 = [[UILabel alloc] initWithFrame:CGRectMake(10, self.height-1+0.5, kScreenSourchWidth, 0.2)];
    line1.backgroundColor = LINE_COLOR;
    line2 = [[UILabel alloc] initWithFrame:CGRectMake(10,self.height-1+0.7, kScreenSourchWidth ,0.2)] ;
    line2.backgroundColor = [UIColor whiteColor];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:line1];
    [self addSubview:line2];
}

-(void)AddEvent
{
    
}

@end
