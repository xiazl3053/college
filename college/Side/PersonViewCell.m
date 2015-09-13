//
//  PersonViewCell.m
//  college
//
//  Created by xiongchi on 15/8/29.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "PersonViewCell.h"

@interface PersonViewCell()
{
    UIImageView *imgView;
    UILabel *lblName;
    UILabel *line1;
    UILabel *line2;
}
@end

@implementation PersonViewCell

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
    
    [self.contentView setBackgroundColor:UIColorFromRGB(0x050e1d)];
    
//    self.contentView.alpha = 0.85;
    
    imgView = [[UIImageView alloc] initWithFrame:Rect(12, 10, 20, 21)];
    
    [self.contentView addSubview:imgView];
    
    lblName = [[UILabel alloc] initWithFrame:Rect(imgView.x+imgView.width+15, 15,200, 15)];
    
    [lblName setFont:XFONT(12)];
    
    [lblName setTextColor:UIColorFromRGB(0xcfcec9)];
    
    [self.contentView addSubview:lblName];
    
    return self;
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
    line1 = [[UILabel alloc] initWithFrame:CGRectMake(0,44.5, kScreenSourchWidth, 0.2)];
    line1.backgroundColor = [UIColor colorWithRed:198/255.0
                                            green:198/255.0
                                             blue:198/255.0
                                            alpha:1.0];
    line2 = [[UILabel alloc] initWithFrame:CGRectMake(0,44.7, kScreenSourchWidth ,0.2)] ;
    line2.backgroundColor = [UIColor whiteColor];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    [self.contentView addSubview:line1];
    [self.contentView addSubview:line2];
}

-(void)setCellInfo:(NSString *)strImg name:(NSString *)strName
{
    [imgView setImage:[UIImage imageNamed:strImg]];
    
    [lblName setText:strName];
}


@end

