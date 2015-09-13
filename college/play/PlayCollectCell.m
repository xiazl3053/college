//
//  PlayCollectCell.m
//  college
//
//  Created by xiongchi on 15/8/26.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "PlayCollectCell.h"
#import "UIImageView+WebCache.h"
#import "UserInfo.h"

@interface PlayCollectCell()
{
    UIImageView *imgView;
    UILabel *lblTitle;
    UILabel *lblContent;
    UILabel *lblAddress;
}
@end


@implementation PlayCollectCell


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    imgView = [[UIImageView alloc] initWithFrame:Rect(0, 0, frame.size.width, frame.size.height)];
    [imgView setImage:[UIImage imageNamed:@"first_busy"]];
    imgView.layer.masksToBounds = YES;
    imgView.layer.cornerRadius = 5.0f;
    
    [self.contentView addSubview:imgView];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    
    [self.contentView addSubview:backView];
    
    [backView setBackgroundColor:RGB(126, 126, 126)];
    [backView setAlpha:0.5f];
    
    lblTitle = [[UILabel alloc] initWithFrame:Rect(10,frame.size.height/2+30, frame.size.width-30, 18)];
    
    [lblTitle setFont:XFONT(16)];
    
    [lblTitle setTextColor:UIColorFromRGB(0xFFFFFF)];
    
    [self.contentView addSubview:lblTitle];
    
//    [lblTitle setText:@"1234567890"];
    
//    lblContent = [[UILabel alloc] initWithFrame:Rect(10, lblTitle.y+lblTitle.height+10, lblTitle.width, 15)];
//    
//    [lblContent setFont:XFONT(12)];
//    
//    [lblContent setTextColor:UIColorFromRGB(0xFFFFFF)];
//    
//    [self.contentView addSubview:lblContent];
    
//    [lblContent setText:@"123456789"];
    
    lblAddress = [[UILabel alloc] initWithFrame:Rect(10, lblTitle.y+lblTitle.height+5, lblTitle.width, 15)];
    [lblAddress setFont:XFONT(12)];
    
    [lblAddress setTextColor:UIColorFromRGB(0xFFFFFF)];
    
    [self.contentView addSubview:lblAddress];
    
    return self;
}

-(void)setPlayModel:(PlayModel *)model
{
    NSString *strIndex = [model.strImg componentsSeparatedByString:@","][0];
    NSString *strUrl = [NSString stringWithFormat:@"%@pub/download/party/%@?token=%@&pictureid=%@",KHttpServer,model.strPartyid,[UserInfo sharedUserInfo].strToken,strIndex];
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"first_busy"]];
    
    lblTitle.text = model.strTitle;
    
    lblContent.text = model.strContent;
    
    lblAddress.text = model.strAddress;
}

@end
