//
//  TeachViewCell.m
//  college
//
//  Created by xiongchi on 15/8/27.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "UserInfo.h"
#import "TeachModel.h"
#import "UIImageView+WebCache.h"
#import "TeachViewCell.h"

@interface TeachViewCell()
{
    UIImageView *imgHead;
    UILabel *lblNick;
    UILabel *lblTitle;
    UILabel *lblContent;
    UILabel *lblCreateTime;
    UILabel *lblUpdateTime;
    UILabel *lblJoinNumber;
    UILabel *line1;
    UILabel *line2;
}

@end


@implementation TeachViewCell

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
    imgHead = [[UIImageView alloc] initWithFrame:Rect(10, 6,40, 40)];
    
    [self.contentView addSubview:imgHead];
    
    lblNick = [[UILabel alloc] initWithFrame:Rect(imgHead.x+imgHead.width+6, 7, 180, 20)];
    
    [lblNick setFont:XFONT(15)];
    
    [lblNick setTextColor:UIColorFromRGB(0x222222)];
    
    [self.contentView addSubview:lblNick];
    
    lblJoinNumber = [[UILabel alloc] initWithFrame:Rect(lblNick.x, 30,100,15)];
    [lblJoinNumber setFont:XFONT(12)];
    [lblJoinNumber setTextColor:RGB(200, 200, 200)];
    [self.contentView addSubview:lblJoinNumber];
    
    lblTitle = [[UILabel alloc] initWithFrame:Rect(10, 50,kScreenSourchWidth-20, 16)];
    
    lblContent = [[UILabel alloc] initWithFrame:Rect(10, 70, kScreenSourchWidth-20, 15)];;
    
    [self.contentView addSubview:lblTitle];
    
    [self.contentView addSubview:lblContent];
    
    [lblTitle setTextColor:UIColorFromRGB(0x222222)];
    
    [lblContent setTextColor:UIColorFromRGB(0x222222)];
    
    [lblTitle setFont:XFONT(14)];
    
    [lblContent setFont:XFONT(12)];
    
    return self;
}

-(void)setModel:(TeachModel *)model
{
    NSString *strUrl = [NSString stringWithFormat:@"%@pub/downloadUserPicture?userid=%@&token=%@",KHttpServer,model.strUserId,[UserInfo sharedUserInfo].strToken];
    [imgHead sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"firstFace"]];
    lblNick.text = model.strNick;
    lblJoinNumber.text = [NSString stringWithFormat:@"报名人数:%@",model.strJoinNum];
    lblTitle.text = model.strTitile;
    NSString *_strContent = model.strContent;
    while (YES&&_strContent)
    {
        NSRange start = [_strContent rangeOfString:@"<img>"];
        if (start.location == NSNotFound)
        {
            break;
        }
        NSRange end = [_strContent rangeOfString:@"</img>"];
        _strContent = [_strContent stringByReplacingCharactersInRange:NSMakeRange(start.location,end.location+end.length-start.location) withString:@""];
    }
    NSInteger nLength = _strContent.length >= 30 ? 30 : _strContent.length;
    
    lblContent.text = [NSString stringWithFormat:@"%@",[_strContent substringWithRange:NSMakeRange(0, nLength)]];
    
}

-(void)addLineView
{
    line1 = [[UILabel alloc] initWithFrame:CGRectMake(10, kTEACHVIEWTABLEVIEWHEIGHT-0.5, kScreenSourchWidth, 0.2)];
    line1.backgroundColor = LINE_COLOR;
    line2 = [[UILabel alloc] initWithFrame:CGRectMake(10, kTEACHVIEWTABLEVIEWHEIGHT-0.3, kScreenSourchWidth ,0.2)] ;
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

@end
