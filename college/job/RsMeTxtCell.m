//
//  RsMeTxtCell.m
//  college
//
//  Created by xiongchi on 15/9/4.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "RsMeTxtCell.h"

@interface RsMeTxtCell(){
    UILabel *line1;
    UILabel *line2;
}

@end

@implementation RsMeTxtCell



- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _lblName = [[UILabel alloc] initWithFrame:Rect(10, 0, 100, 44)];
    
    [_lblName setTextColor:[UIColor grayColor]];
    
    [_lblName setFont:XFONT(12)];
    
    [self.contentView addSubview:_lblName];
    
    _txtName = [[UITextField alloc] initWithFrame:Rect(110, 0, kScreenSourchWidth-135, 44)];
    
    [_txtName setTextColor:UIColorFromRGB(0x222222)];
    
    [_txtName setFont:XFONT(12)];
    
    [_txtName setTextAlignment:NSTextAlignmentRight];
    
    [self.contentView addSubview:_txtName];
    
    return self;
}

-(void)addLineView
{
    line1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 44.6, kScreenSourchWidth, 0.2)];
    line1.backgroundColor = LINE_COLOR;
    line2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 44.8, kScreenSourchWidth ,0.2)] ;
    line2.backgroundColor = [UIColor whiteColor];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [self.contentView addSubview:line1];
    [self.contentView addSubview:line2];
}

-(void)setLineFull
{
    if (line1==nil)
    {
        [self addLineView];
    }
    line1.frame = Rect(0, 44.6, kScreenSourchWidth, 0.2);
    line2.frame = Rect(0, 44.8, kScreenSourchWidth, 0.2);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (line1==nil)
    {
        [self addLineView];
    }
}

@end
