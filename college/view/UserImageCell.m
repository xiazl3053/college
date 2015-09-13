//
//  UserImageCell.m
//  XCMonit_Ip
//
//  Created by 夏钟林 on 14/7/15.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "UserImageCell.h"

@implementation UserImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    UILabel *sLine3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenSourchWidth, 0.5)];
    sLine3.backgroundColor = LINE_COLOR;
    UILabel *sLine4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.5, kScreenSourchWidth, 0.5)] ;
    sLine4.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:sLine3];
    [self.contentView addSubview:sLine4];
    
    
    _lblDevInfo = [[UILabel alloc] initWithFrame:CGRectMake(18, 25, 150, 16)];
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSourchWidth-75, 11 , 45, 45)];
    [_lblDevInfo setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
    
    [_lblDevInfo setTextColor:[UIColor grayColor]];
    [_lblDevInfo setFont:XFONT(12)];
    [_imgView.layer setMasksToBounds:YES];
    _imgView.layer.cornerRadius = 22.5f;
    [self.contentView addSubview:_lblDevInfo];
    [self.contentView addSubview:_imgView];
    
    UILabel *sLine1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 66.6, kScreenSourchWidth, 0.2)];
    sLine1.backgroundColor = LINE_COLOR;
    
    UILabel *sLine2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 66.8, kScreenSourchWidth, 0.2)] ;
    sLine2.backgroundColor = [UIColor whiteColor];
    
    UIImageView *img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more_ico"]];
    [self.contentView addSubview:img1];
    img1.frame = Rect(kScreenSourchWidth-20, 32, 8, 13);
    
    [self.contentView addSubview:sLine1];
    [self.contentView addSubview:sLine2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setImageInfo:(NSString*)strImage
{
    __block NSString *__strPath = strImage;
    __block UserImageCell *imageCell = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        DLog(@"Starting: %@", __strPath);
        UIImage *avatarImage = nil;
        NSURL *url = [NSURL URLWithString:__strPath];
        NSData *responseData = [NSData dataWithContentsOfURL:url];
        avatarImage = [UIImage imageWithData:responseData];
        DLog(@"Finishing: %@", __strPath);
        if (avatarImage)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (imageCell.imageLoad)
                {
                    imageCell.imageLoad(avatarImage);
                }
            });
        }
        else
        {
            DLog(@"-- impossible download: %@", __strPath);
        }
    });
}

@end
