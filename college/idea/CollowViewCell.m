//
//  CollwViewCell.m
//  college
//
//  Created by xiongchi on 15/9/10.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "CollowViewCell.h"
#import "UserInfo.h"
#import "CollowModel.h"
#import "TeachModel.h"
#import "UIImageView+WebCache.h"

@interface CollowViewCell()
{
    UIImageView *imgHead;
    UILabel *lblNick;
    UILabel *lblTitle;
    UILabel *lblContent;
    UILabel *lblCreateTime;
    UILabel *lblUpdateTime;
    //    UILabel *lblNumber;
    UILabel *lblCost;
    UILabel *line1;
    UILabel *line2;
    int nX;
}

@end


@implementation CollowViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    //    imgHead = [[UIImageView alloc] initWithFrame:Rect(10, 6,40, 40)];
    
    nX = 10;
    
    //    [self.contentView addSubview:imgHead];
    //    lblNick = [[UILabel alloc] initWithFrame:Rect(10,10,180,20)];
    //    lblNick = [[UILabel alloc] initWithFrame:Rect(imgHead.x+imgHead.width+10, 7, 180, 20)];
    
    //    [lblNick setFont:XFONT(15)];
    
    //    [lblNick setTextColor:UIColorFromRGB(0x222222)];
    
    //    [self.contentView addSubview:lblNick];
    
    lblTitle = [[UILabel alloc] initWithFrame:Rect(10, 10,kScreenSourchWidth-20, 15)];
    
    lblContent = [[UILabel alloc] initWithFrame:Rect(lblTitle.x, 30, kScreenSourchWidth-80, 30)];;
    
    lblCost = [[UILabel alloc] initWithFrame:Rect(kScreenSourchWidth-80, 15, 70, 15)];
    
    [lblCost setTextColor:MAIN_COLOR];
    
    [lblCost setFont:XFONT(12)];
    
    lblCreateTime = [[UILabel alloc] initWithFrame:Rect(kScreenSourchWidth-80,40,70,15)];
    
    [lblCreateTime setFont:XFONT(12)];
    
    [lblCreateTime setTextColor:RGB(128, 128, 128)];
    
    [self.contentView addSubview:lblCost];
    
    [lblCost setTextAlignment:NSTextAlignmentRight];
    
    [lblCreateTime setTextAlignment:NSTextAlignmentRight];
    
    [self.contentView addSubview:lblTitle];
    
    [self.contentView addSubview:lblCreateTime];
    
    [self.contentView addSubview:lblContent];
    
    [lblTitle setTextColor:UIColorFromRGB(0x222222)];
    
    [lblContent setTextColor:UIColorFromRGB(0x222222)];
    
    [lblTitle setFont:XFONT(14)];
    
    [lblContent setFont:XFONT(12)];
    
    lblContent.lineBreakMode = NSLineBreakByWordWrapping;// UILineBreakModeWordWrap;
    lblContent.numberOfLines = 0;
    
    
    return self;
}

-(void)setModel:(CollowModel *)model
{
    lblTitle.text = model.strTitle;
    lblCost.text = model.strCost;
    lblContent.text = model.strContent;
    lblCreateTime.text = model.strCreateTime;
    
    CGRect size = [model.strContent boundingRectWithSize:CGSizeMake(lblContent.width,40)
                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                             attributes:[NSDictionary dictionaryWithObjectsAndKeys:lblTitle.font,NSFontAttributeName, nil] context:nil];
    lblContent.frame = Rect(10, 30, kScreenSourchWidth-80, size.size.height);
    
}

-(void)addLineView
{
    line1 = [[UILabel alloc] initWithFrame:CGRectMake(nX, kIDEAVIEWCONTROLLER-0.5, kScreenSourchWidth, 0.2)];
    line1.backgroundColor = LINE_COLOR;
    line2 = [[UILabel alloc] initWithFrame:CGRectMake(nX, kIDEAVIEWCONTROLLER-0.3, kScreenSourchWidth ,0.2)] ;
    line2.backgroundColor = [UIColor whiteColor];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [self.contentView addSubview:line1];
    [self.contentView addSubview:line2];
}

-(void)setLineFull
{
    nX = 0;
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
