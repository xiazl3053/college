//
//  JobViewCell.m
//  college
//
//  Created by xiongchi on 15/8/26.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "JobViewCell.h"

@interface JobViewCell()
{
    UILabel *lblTitle;
    UILabel *lblCompany;
    UILabel *lblPrice;
    UILabel *lblAddres;
    UILabel *line1;
    UILabel *line2;
    int nX;
}

@end

@implementation JobViewCell

-(void)setJobModel:(JobModel *)model
{
    lblTitle.text = model.strTitle;
    
    lblCompany.text = [NSString stringWithFormat:@"%@",model.strCompany];
    
    if(model.strPrice && ![model.strPrice isEqualToString:@""])
    {
        lblPrice.text = [NSString stringWithFormat:@"%@",model.strPrice];
    }
    
    lblAddres.text = model.strJobTime;
    
}

- (void)awakeFromNib
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    nX = 10;
    lblTitle = [[UILabel alloc] initWithFrame:Rect(10, 5, 200, 20)];
    
    [lblTitle setFont:XFONT(15)];
    
    [lblTitle setTextColor:UIColorFromRGB(0x222222)];
    
    [self.contentView addSubview:lblTitle];
    
    lblCompany = [[UILabel alloc] initWithFrame:Rect(lblTitle.x,32, 180, 13)];
    
    [lblCompany setFont:XFONT(12)];
    
    [lblCompany setTextColor:UIColorFromRGB(0x7D7D7D)];
    
    [self.contentView addSubview:lblCompany];
    
    lblPrice = [[UILabel alloc] initWithFrame:Rect(kScreenSourchWidth-130, lblTitle.y+5, 100, 13)];
    
    [lblPrice setFont:XFONT(12)];
    
    [lblPrice setTextAlignment:NSTextAlignmentRight];
    
    [lblPrice setTextColor:MAIN_COLOR];
    
    [self.contentView addSubview:lblPrice];
   
    lblAddres = [[UILabel alloc] initWithFrame:Rect(kScreenSourchWidth-130, lblPrice.y+lblPrice.height+3, 100, 13)];
    
    [lblAddres setFont:XFONT(12)];
    
    [lblAddres setTextColor:RGB(200, 200, 200)];
    
    [lblAddres setTextAlignment:NSTextAlignmentRight];
    
    [self.contentView addSubview:lblAddres];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more_ico"]];
    
    [self.contentView addSubview:imgView];
    
    imgView.frame = Rect(kScreenSourchWidth-20 , 18.5, 8, 13);
    
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

-(void)setLineFull
{
//    if (line1==nil)
//    {
//        [self addLineView];
//    }
//    line1.frame = Rect(0, 49.5, kScreenSourchWidth, 0.2);
//    line2.frame = Rect(0, 49.7, kScreenSourchWidth, 0.2);
    nX = 0;
}

-(void)addLineView
{
    line1 = [[UILabel alloc] initWithFrame:CGRectMake(nX, 49.5, kScreenSourchWidth, 0.2)];
    line1.backgroundColor = LINE_COLOR;
    line2 = [[UILabel alloc] initWithFrame:CGRectMake(nX, 49.7, kScreenSourchWidth ,0.2)] ;
    line2.backgroundColor = [UIColor whiteColor];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    [self.contentView addSubview:line1];
    [self.contentView addSubview:line2];
}

@end
