//
//  CollowViewController.m
//  college
//
//  Created by xiongchi on 15/9/10.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "CollowViewController.h"
#import "UserInfo.h"
#import "AddIdeaViewController.h"

#import "BaseService.h"
#import "CollowModel.h"
#import "UIImageView+WebCache.h"

@interface CollowViewController ()
{
    UILabel *lblNick;
    UIImageView *imgHead;
    UILabel *lblCreateTime;
    UILabel *lblTitle;
    UIScrollView *scrollView;
    UITextView *txtContent;
    UILabel *lblInfo;
}
@property (nonatomic,strong) CollowModel *model;

@end

@implementation CollowViewController

-(id)initWithModel:(CollowModel *)model
{
    self = [super init];
    
    _model=model;
    
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:VIEW_BACK];
    
    scrollView = [[UIScrollView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, kScreenSourchHeight-119)];
    [self.view addSubview:scrollView];
    
    imgHead = [[UIImageView alloc] initWithFrame:Rect(10, 10, 40, 40)];
    [scrollView addSubview:imgHead];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@pub/downloadUserPicture?userid=%@&token=%@",KHttpServer,_model.strUserId,[UserInfo sharedUserInfo].strToken];
    
    [imgHead sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"firstFace"]];
    
    lblNick = [[UILabel alloc] initWithFrame:Rect(imgHead.x+imgHead.width+10, imgHead.y, 200, 20)];
    
    [lblNick setTextColor:UIColorFromRGB(0x333333)];
    
    [lblNick setText:_model.strNick];
    
    [lblNick setFont:XFONT(15)];
    
    [scrollView addSubview:lblNick];
    
    lblCreateTime = [[UILabel alloc] initWithFrame:Rect(lblNick.x, lblNick.y+lblNick.height, lblNick.width, 15)];
    
    [lblCreateTime setText:_model.strCreateTime];
    
    [lblCreateTime setTextColor:[UIColor grayColor]];
    
    [lblCreateTime setFont:XFONT(12)];
    
    [scrollView addSubview:lblCreateTime];
    
    [self addLineView:scrollView heaght:lblCreateTime.y+lblCreateTime.height+5];
    
    lblTitle=[[UILabel alloc] initWithFrame:Rect(10, lblCreateTime.y+lblCreateTime.height+10, kScreenSourchWidth-60, 20)];
    
    [lblTitle setFont:XFONT(15)];
    
    [lblTitle setTextColor:UIColorFromRGB(0x333333)];
    
    [scrollView addSubview:lblTitle];
    
    [lblTitle setText:_model.strTitle];
    
    txtContent = [[UITextView alloc] initWithFrame:Rect(10, lblTitle.y+lblTitle.height+5, kScreenSourchWidth-20, 100)];
    
    [txtContent setFont:XFONT(14)];
    
    [txtContent setTextColor:UIColorFromRGB(0x333333)];
    
    [txtContent setEditable:NO];
    
    [txtContent setBackgroundColor:VIEW_BACK];
    
    CGRect size = [_model.strContent boundingRectWithSize:CGSizeMake(txtContent.width,kScreenSourchHeight*3)
                                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                              attributes:[NSDictionary dictionaryWithObjectsAndKeys:lblTitle.font,NSFontAttributeName, nil] context:nil];
    
    txtContent.frame = Rect(10, lblTitle.y+lblTitle.height+5, kScreenSourchWidth-20, size.size.height+30);
    
    txtContent.text = _model.strContent;
    
    [scrollView addSubview:txtContent];
    
    UIButton *btnPush = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPush setTitle:@"接单" forState:UIControlStateNormal];
    [btnPush setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [btnPush setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateHighlighted];
    [btnPush.layer setMasksToBounds:YES];
    [btnPush.layer setCornerRadius:5.0];
    
    [btnPush addTarget:self action:@selector(pushEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnPush];
    
    [btnPush setBackgroundColor:MAIN_COLOR];
    
    btnPush.frame = Rect(10, kScreenSourchHeight-50, kScreenSourchWidth-20, 45);
}

-(void)getAllNumber
{
    NSString *strUrl = [NSString stringWithFormat:@"%@zhengji/ideaList?"];
}

-(void)addLineView:(UIView *)headView heaght:(CGFloat)height
{
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, height, headView.width, 0.4)];
    line1.backgroundColor = LINE_COLOR;
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, height+0.4, headView.width,0.4)] ;
    line2.backgroundColor = [UIColor whiteColor];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [headView addSubview:line1];
    [headView addSubview:line2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)pushEvent
{
    AddIdeaViewController *addView = [[AddIdeaViewController alloc] initWithZhengjiId:[_model.strCollowId integerValue]];
    [self presentViewController:addView animated:YES completion:nil];
}

@end
