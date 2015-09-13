//
//  XCollTabBtn.m
//  college
//
//  Created by xiongchi on 15/8/26.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "XCollTabBtn.h"

@implementation XCollTabBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithTbBtn:(CGRect)frame nor:(NSString*)strNorImg high:(NSString*)strHighImg select:(NSString*)strSelectImg title:(NSString *)strTitle
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = XFONT(12);
        
        [self setTitle:strTitle forState:UIControlStateNormal];
        [self setTitleColor:RGB(146, 146, 146) forState:UIControlStateNormal];
        [self setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
        [self setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
        
        self.contentMode = UIViewContentModeScaleAspectFit;
        [self setImage:[UIImage imageNamed:strNorImg] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:strSelectImg] forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:strHighImg] forState:UIControlStateHighlighted];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return Rect(0, 30,self.width,14);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return Rect(self.width/2-11.5, 5, 23,23);
}

@end
