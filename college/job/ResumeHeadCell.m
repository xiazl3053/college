//
//  ResumeHeadCell.m
//  college
//
//  Created by xiongchi on 15/9/5.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "ResumeHeadCell.h"
#import "XResumeBtn.h"
#import "XLoginButton.h"
#import "ResumeModel.h"

@interface ResumeHeadCell()
{
    UILabel *lblTile;
    UILabel *lblCreateTime;
    UILabel *lblUpdateTime;
    UIButton *btnUpddate;
    UIButton *btnDelete;
}

@end

@implementation ResumeHeadCell

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

    [self.contentView setBackgroundColor:RGB(239, 239, 239)];
   
    UIView *headView = [[UIView alloc] initWithFrame:Rect(10, 0, kScreenSourchWidth-20, 140)];
    
    [self.contentView addSubview:headView];
    
    [headView.layer setBorderColor:LINE_COLOR.CGColor];
    
    [headView.layer setBorderWidth:0.5];
    
    [headView setBackgroundColor:RGB(255, 255, 255)];
    
    [headView.layer setMasksToBounds:YES];
    
    [headView.layer setCornerRadius:5.0];
    
    lblTile = [[UILabel alloc] initWithFrame:Rect(15,10, 200, 20)];
    
    [lblTile setFont:XFONT(15)];
   
    [headView addSubview:lblTile];
    
    [self addLineView:headView heaght:40];
    
    lblCreateTime = [[UILabel alloc] initWithFrame:Rect(15,lblTile.y+lblTile.height+20,200,15)];
    
    [lblCreateTime setFont:XFONT(12)];
    
    [lblCreateTime setTextColor:[UIColor grayColor]];
    
    [headView addSubview:lblCreateTime];
    
    lblUpdateTime = [[UILabel alloc] initWithFrame:Rect(15, lblCreateTime.y+lblCreateTime.height+10, 200, 15)];
    
    [lblUpdateTime setFont:XFONT(12)];
    
    [lblUpdateTime setTextColor:[UIColor grayColor]];
    
    [headView addSubview:lblUpdateTime];
    
    UILabel *lblQuery = [[UILabel alloc] initWithFrame:Rect(kScreenAppWidth-100,125/2-6.5, 60, 13)];
    [lblQuery setFont:XFONT(12)];
    [lblQuery setTextColor:[UIColor grayColor]];
    [lblQuery setText:@"预览"];
    [headView addSubview:lblQuery];
    [lblQuery setTextAlignment:NSTextAlignmentRight];
    
    UIImageView *imgQuery = [[UIImageView alloc] initWithFrame:Rect(lblQuery.x+lblQuery.width+2, lblQuery.y, 8, 13)];
    [imgQuery setImage:[UIImage imageNamed:@"more_ico"]];
    [headView addSubview:imgQuery];
    
    [self addLineView:headView heaght:lblUpdateTime.y+lblUpdateTime.height+5];
    
    btnUpddate = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnUpddate.frame = Rect(0,lblUpdateTime.y+lblUpdateTime.height+6, headView.width/2, headView.height-(lblUpdateTime.y+lblUpdateTime.height+6));
    
    [btnUpddate setTitle:@"编辑" forState:UIControlStateNormal];
    
    [btnUpddate setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    
    [btnUpddate setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateHighlighted];
    
    [headView addSubview:btnUpddate];
    
    UIView *lineView = [[UIView alloc] initWithFrame:Rect(headView.width/2-0.5,lblUpdateTime.y+lblUpdateTime.height+5,1,
                                                    140 - (lblUpdateTime.y+lblUpdateTime.height+5))];
    [lineView setBackgroundColor:LINE_COLOR];
    
    [headView addSubview:lineView];
    
    btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnDelete.frame = Rect(btnUpddate.x+btnUpddate.width, btnUpddate.y,headView.width/2 , btnUpddate.height);
    
    [btnDelete setTitle:@"删除" forState:UIControlStateNormal];
    
    [btnDelete setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    
    [btnDelete setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateHighlighted];
    
    [btnUpddate addTarget:self action:@selector(updateEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [btnDelete addTarget:self action:@selector(deleteEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:btnDelete];
    
    [btnUpddate setBackgroundColor:VIEW_BACK];
    [btnDelete setBackgroundColor:VIEW_BACK];
    
    return self;
}

-(void)addLineView:(UIView *)headView heaght:(CGFloat)height
{
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, height, headView.width-0, 0.5)];
    line1.backgroundColor = LINE_COLOR;
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, height+0.5, headView.width-0,0.5)] ;
    line2.backgroundColor = [UIColor whiteColor];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [headView addSubview:line1];
    [headView addSubview:line2];
}

-(void)updateEvent
{
    if (_delegate && [_delegate respondsToSelector:@selector(resumeEdit:)])
    {
        [_delegate resumeEdit:_model];
    }
}

-(void)deleteEvent
{
    if (_delegate && [_delegate respondsToSelector:@selector(resumeDelete:)])
    {
        [_delegate resumeDelete:_model];
    }
}

-(void)setResumeInfo:(ResumeModel *)model
{
    [lblTile setText:model.strTitle];
    
    [lblUpdateTime setText:[NSString stringWithFormat:@"更新于 %@",model.strUpdTime]];
    
    [lblCreateTime setText:[NSString stringWithFormat:@"创建于 %@",model.strCreateTime]];
    
    _model = model;
}



@end
