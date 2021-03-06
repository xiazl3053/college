//
//  IdeaViewCell.m
//  college
//
//  Created by xiongchi on 15/9/10.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "IdeaViewCell.h"
#import "UserInfo.h"
#import "IdeaModel.h"
#import "TeachModel.h"
#import "UIImageView+WebCache.h"

@interface IdeaViewCell()
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


@implementation IdeaViewCell

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
    nX = 10;

    lblTitle = [[UILabel alloc] initWithFrame:Rect(10, 10,kScreenSourchWidth-20, 15)];
    
    lblContent = [[UILabel alloc] initWithFrame:Rect(lblTitle.x, 30, kScreenSourchWidth-100, 30)];;
    
    lblCost = [[UILabel alloc] initWithFrame:Rect(kScreenSourchWidth-80, 15, 70, 15)];
    
    [lblCost setTextColor:MAIN_COLOR];
    
    [lblCost setFont:XFONT(14)];
    
    lblCreateTime = [[UILabel alloc] initWithFrame:Rect(kScreenSourchWidth-80,40,70,15)];
    
    [lblCreateTime setFont:XFONT(12)];
    
    [self.contentView addSubview:lblCost];
    
    [self.contentView addSubview:lblTitle];
    
    [lblCost setTextAlignment:NSTextAlignmentRight];
    
    [lblCreateTime setTextAlignment:NSTextAlignmentRight];
    
    [self.contentView addSubview:lblCreateTime];
    
    [self.contentView addSubview:lblContent];
    
    [lblCreateTime setTextColor:RGB(128, 128, 128)];
    
    [lblTitle setTextColor:UIColorFromRGB(0x222222)];
    
    [lblContent setTextColor:UIColorFromRGB(0x222222)];
    
    [lblTitle setFont:XFONT(14)];
    
    [lblContent setFont:XFONT(12)];
    
    lblContent.lineBreakMode = NSLineBreakByWordWrapping;// UILineBreakModeWordWrap;
    
    lblContent.numberOfLines = 0;
    
    return self;
}

-(void)setModel:(IdeaModel *)model
{

    lblTitle.text = model.strTitle;
    lblCost.text = [NSString stringWithFormat:@"%@",model.strCost];
    lblContent.text = model.strIntrol;
    lblCreateTime.text = model.strCreateTime;
    
//    CGRect size = [model.strIntrol boundingRectWithSize:CGSizeMake(lblTitle.width,40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:lblTitle.font,NSFontAttributeName, nil] context:nil];
//    lblContent.frame = Rect(10, 30, kScreenSourchWidth-80, size.size.height);
    
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
