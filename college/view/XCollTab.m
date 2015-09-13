//
//  XCollTab.m
//  college
//
//  Created by xiongchi on 15/8/26.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "XCollTab.h"
#import "XCollTabBtn.h"

@interface XCollTab()
{
    UIButton *_btnOther;
}
@end


@implementation XCollTab

-(id)initWithArrayItem:(NSArray *)item frame:(CGRect)srcFrame
{
    self = [super initWithFrame:srcFrame];
    [self setBackgroundColor:RGB(255,255,255)];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.2, kScreenSourchWidth, 0.2)];
    line1.backgroundColor = [UIColor colorWithRed:198/255.0
                                            green:198/255.0
                                             blue:198/255.0
                                            alpha:1.0];
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0,0.4, kScreenSourchWidth ,0.2)] ;
    line2.backgroundColor = [UIColor whiteColor];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    [self addSubview:line1];
    [self addSubview:line2];
    
    int nNumber=0;
    float fWidth = kScreenSourchWidth/5;
    for (XCOLLInfo *bInfo in item)
    {
        XCollTabBtn *xcBP = [[XCollTabBtn alloc] initWithTbBtn:Rect(nNumber*fWidth, 0,fWidth, 50) nor:bInfo.strNorImg high:bInfo.strHighImg select:bInfo.strSelectImg title:bInfo.strTitle];
        xcBP.tag = 1000+nNumber;
        [xcBP addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:xcBP];
        nNumber ++;
    }
    return self;
}

-(void)clickIndex:(int)nIndex
{
    UIButton *btn = (UIButton *)[self viewWithTag:(1000+nIndex)];
   
    [self clickBtn:btn];
    
}

-(void)clickBtn:(UIButton *)btnSender
{
    _btnOther.selected = NO;
    
    btnSender.selected = YES;
    
    _btnOther = btnSender;
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickView:index:)])
    {
        int nIndex = (int)(btnSender.tag - 1000);
        [_delegate clickView:btnSender index:nIndex];
    }
}

@end

@implementation XCOLLInfo

-(id)initWithItem:(NSArray *)item
{
    self = [super init];
    _strNorImg = item[0];
    _strHighImg = item[1];
    _strSelectImg = item[2];
    _strTitle = item[3];
    return self;
}

@end

