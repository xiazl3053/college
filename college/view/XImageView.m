//
//  XImageView.m
//  college
//
//  Created by xiongchi on 15/9/13.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "XImageView.h"
#import "UIView+BlocksKit.h"

@interface XImageView()
{
    UILabel *line1;
    UILabel *line2;
}
@end

@implementation XImageView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    _lblTitle = [[UILabel alloc] initWithFrame:Rect(10, 1, 100, frame.size.height-1)];
    
    [self addSubview:_lblTitle];
    
    _imgView = [[UIImageView alloc] initWithFrame:Rect(kScreenSourchWidth-frame.size.height-28,1, frame.size.height-2, frame.size.height-2)];
    
    [self addSubview:_imgView];
    
    [_lblTitle setFont:XFONT(14)];
    
    [_lblTitle setTextColor:UIColorFromRGB(0x8e8c97)];
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:Rect(kScreenSourchWidth-20, frame.size.height/2-6.5, 8, 13)];
    
    [img1 setImage:[UIImage imageNamed:@"more_ico"]];
    
    [self addSubview:img1];
    
    [self addLineView];
    
    return self;
}

-(void)addTouchEvent:(void (^)())handle
{
    [self bk_whenTouches:1 tapped:1 handler:handle];
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
