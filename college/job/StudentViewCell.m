//
//  StudentViewCell.m
//  college
//
//  Created by xiongchi on 15/9/6.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "StudentViewCell.h"
#import "ResumeModel.h"

@interface StudentViewCell()
{
    UILabel *line1;
    UILabel *line2;
}
@end

@implementation StudentViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _lblSchool = [[UILabel alloc] initWithFrame:Rect(10, 3, kScreenSourchWidth-50, 20)];
    
    _lblTime = [[UILabel alloc] initWithFrame:Rect(10, 25, kScreenSourchWidth-50, 15)];
    
    [_lblSchool setFont:XFONT(14)];
    
    [_lblSchool setTextColor:UIColorFromRGB(0x222222)];
    
    [_lblTime setFont:XFONT(12)];
    
    [_lblTime setTextColor:RGB(180, 180, 180)];
    
    [self.contentView addSubview:_lblSchool];
    
    [self.contentView addSubview:_lblTime];
    
    return self;
}

-(void)setModel:(XEducation *)edu
{
    _lblSchool.text = edu.strSchool;
    _lblTime.text = [NSString stringWithFormat:@"%@~%@",edu.strStart,edu.strEnd];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (line1==nil)
    {
        [self addLineView];
    }
}

-(void)addLineView
{
    line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 44.5, kScreenSourchWidth, 0.2)];
    line1.backgroundColor = LINE_COLOR;
    line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 44.7, kScreenSourchWidth ,0.2)] ;
    line2.backgroundColor = [UIColor whiteColor];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    [self.contentView addSubview:line1];
    [self.contentView addSubview:line2];
}

@end
