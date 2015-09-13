//
//  BBSViewCell.m
//  college
//
//  Created by xiongchi on 15/8/27.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "BBSViewCell.h"
#import "BBSModel.h"
#import "UIImageView+WebCache.h"
#import "UserInfo.h"


@interface BBSViewCell()
{
    UIImageView *imgHead;
    UILabel *lblName;
    UILabel *lblTitle;
    UILabel *line1;
    UILabel *line2;
    UILabel *lblReply;
}
@end

@implementation BBSViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    imgHead = [[UIImageView alloc] initWithFrame:Rect(10, 7, 40, 40)];
    
    [self.contentView addSubview:imgHead];
    
    lblName = [[UILabel alloc] initWithFrame:Rect(imgHead.x+imgHead.width+7, 7, kScreenSourchWidth-imgHead.width-30,20)];
    [lblName setTextColor:UIColorFromRGB(0x222222)];
    [lblName setFont:XFONT(15)];
    
    [self.contentView addSubview:lblName];
    
    lblTitle = [[UILabel alloc] initWithFrame:Rect(10, imgHead.y+imgHead.height+5, kScreenSourchWidth-20, 40)];
    
    [lblTitle setFont:XFONT(12)];
    lblTitle.lineBreakMode = NSLineBreakByWordWrapping;// UILineBreakModeWordWrap;
    lblTitle.numberOfLines = 0;
    
    [self.contentView addSubview:lblTitle];
    
    lblReply = [[UILabel alloc] initWithFrame:Rect(lblName.x, lblName.y+lblName.height+5, lblName.width, 15)];
    
    [lblReply setFont:XFONT(12)];
    
    [lblReply setTextColor:RGB(200, 200, 200)];
    
    [self.contentView addSubview:lblReply];
    
    return self;
}

-(void)addLineView
{
    line1 = [[UILabel alloc] initWithFrame:CGRectMake(10, kTEACHVIEWTABLEVIEWHEIGHT-0.5, kScreenSourchWidth, 0.2)];
    line1.backgroundColor = LINE_COLOR;
    line2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 44.8, kTEACHVIEWTABLEVIEWHEIGHT-0.3 ,0.2)] ;
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
    line1.frame = Rect(0, kTEACHVIEWTABLEVIEWHEIGHT-0.5, kScreenSourchWidth, 0.2);
    line2.frame = Rect(0, kTEACHVIEWTABLEVIEWHEIGHT-0.3, kScreenSourchWidth, 0.2);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (line1==nil)
    {
        [self addLineView];
    }
}

-(void)setModel:(BBSModel *)model
{
    NSString *strUrl = [NSString stringWithFormat:@"%@pub/downloadUserPicture?userid=%@&token=%@",KHttpServer,model.strUserId,[UserInfo sharedUserInfo].strToken];
    [imgHead sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"firstFace"]];
    lblName.text = model.strNick;
    lblTitle.text = model.strTitile;
    lblReply.text = [NSString stringWithFormat:@"回帖数量:%@",model.strRePly];
    
   CGRect size = [model.strTitile boundingRectWithSize:CGSizeMake(lblTitle.width,40)
                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                          attributes:[NSDictionary dictionaryWithObjectsAndKeys:lblTitle.font,NSFontAttributeName, nil] context:nil];
    lblTitle.frame = Rect(10, imgHead.y+imgHead.height+5, kScreenSourchWidth-20, size.size.height);
}

@end
