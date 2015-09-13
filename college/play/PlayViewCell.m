//
//  PlayViewCell.m
//  college
//
//  Created by xiongchi on 15/8/26.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "PlayViewCell.h"
#import "UIImageView+WebCache.h"

@interface PlayViewCell()
{
    
    UIImageView *imgView;
    UILabel *lblTitle;
    UILabel *lblContent;
    UILabel *lblDate;
    UILabel *lblAddress;
    UILabel *line1;
    UILabel *line2;
    
}

@end

@implementation PlayViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    imgView = [[UIImageView alloc] initWithFrame:Rect(10, 8, 90, 54)];
    [self.contentView addSubview:imgView];
    
    lblTitle = [[UILabel alloc] initWithFrame:Rect(110, 8, 160, 17)];
    
    [lblTitle setFont:XFONT(15)];
    
    [lblTitle setTextColor:UIColorFromRGB(0x222222)];
    
    [self.contentView addSubview:lblTitle];
    
    lblContent = [[UILabel alloc] initWithFrame:Rect(lblTitle.x,lblTitle.y+lblTitle.height+15, 140, 13)];
    
    [lblContent setFont:XFONT(12)];
    
    [lblContent setTextColor:UIColorFromRGB(0xD4D4D4)];
    
    [self.contentView addSubview:lblContent];
    
    lblAddress = [[UILabel alloc] initWithFrame:Rect(kScreenSourchWidth-70, 10,65, 20)];
    
    [lblAddress setFont:XFONT(12)];
    
    [lblAddress setTextColor:UIColorFromRGB(0x222222)];
    
    [lblAddress setTextAlignment:NSTextAlignmentRight];
    
    [self.contentView addSubview:lblAddress];
    
    lblDate = [[UILabel alloc] initWithFrame:Rect(kScreenSourchWidth-70, 40, 65, 20)];
    
    [lblDate setFont:XFONT(12)];
    
    [lblDate setTextColor:UIColorFromRGB(0x222222)];
    
    [lblDate setTextAlignment:NSTextAlignmentRight];
    
    [self.contentView addSubview:lblDate];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self addLineView];
}

-(void)addLineView
{
    line1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 69.5, kScreenSourchWidth, 0.2)];
    line1.backgroundColor = [UIColor colorWithRed:198/255.0
                                             green:198/255.0
                                              blue:198/255.0
                                             alpha:1.0];
    line2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 69.7+0.2, kScreenSourchWidth ,0.2)] ;
    line2.backgroundColor = [UIColor whiteColor];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    [self.contentView addSubview:line1];
    [self.contentView addSubview:line2];
}

-(void)setPlayModel:(PlayModel *)model
{
    NSString *strUrl = [NSString stringWithFormat:@"%@pub/download/party/%@",KHttpServer,model.strPartyid];
    [imgView sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@""]];
    lblTitle.text = model.strTitle;
    lblContent.text = model.strContent;
    lblDate.text = model.strPartyTime;
    lblAddress.text = model.strAddress;
}

@end
