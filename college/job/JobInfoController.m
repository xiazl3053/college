//
//  JobInfoController.m
//  college
//
//  Created by xiongchi on 15/8/27.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "JobInfoController.h"
#import "JobInfoModel.h"
#import "Toast+UIView.h"
#import "BaseService.h"
#import "UserInfo.h"
#import "JobModel.h"
#import "XLoginButton.h"

@interface JobInfoController ()
{
    UILabel *lblTitle;
    UILabel *lblCompany;
    UILabel *lblAddress;
    UILabel *lblTime;
    UILabel *lblJobTime;
    UILabel *lblPrice;
    UITextView *txtContent;
    UIScrollView *scrollView;
    JobModel *_model;
    int _nId;
}

@end

@implementation JobInfoController

-(id)initWIthModel:(JobModel *)jobModel
{
    self = [super init];
    
    _model = jobModel;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
    [self initView];
    [self setJobInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setJobInfo
{
    lblTitle.text = _model.strTitle;
    lblCompany.text = [NSString stringWithFormat:@"公司:%@",_model.strCompany];
    lblAddress.text = [NSString stringWithFormat:@"地址:%@",_model.strAddress];
    lblTime.text = [NSString stringWithFormat:@"发布时间:%@",_model.strDate];
    lblJobTime.text = [NSString stringWithFormat:@"工作时间:%@",_model.strJobTime];
    lblPrice.text = [NSString stringWithFormat:@"薪资:%@",_model.strPrice];
    txtContent.text = _model.strContent;
}

-(void)initView
{
    [self setTitleText:@"兼职"];
   
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateHighlighted];
    
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftBtn:btnBack];
    
    lblTitle = [[UILabel alloc] initWithFrame:Rect(10, 81, kScreenSourchWidth-50,20)];
    
    [lblTitle setFont:XFONT(16)];
    
    [lblTitle setTextColor:UIColorFromRGB(0x222222)];
    
    [self.view addSubview:lblTitle];
    
    [lblTitle setText:@"东风东路大润发传单"];
    
    lblCompany = [[UILabel alloc] initWithFrame:Rect(10, lblTitle.y+lblTitle.height+4 , kScreenSourchWidth-50, 18)];
    
    [lblCompany setFont:XFONT(12)];
    
    [lblCompany setTextColor:UIColorFromRGB(0x222222)];
    
    [self.view addSubview:lblCompany];
    [lblCompany setText:@"公司:广东国际大润发有限公司"];
    
    UIView *headView = [[UIView alloc] initWithFrame:Rect(10, lblCompany.y+lblCompany.height+17, kScreenSourchWidth-20, 140)];
    
    [headView.layer setMasksToBounds:YES];
    
    [headView.layer setCornerRadius:5.0f];
    
    [headView setBackgroundColor:UIColorFromRGB(0xF4EBEC)];
    
    [self.view addSubview:headView];
    
    UIView *viewAddr = [[UIView alloc] initWithFrame:Rect(0, 0, headView.width, 50)];
    [viewAddr setBackgroundColor:MAIN_COLOR];
    [headView addSubview:viewAddr];
    
    lblAddress = [[UILabel alloc] initWithFrame:Rect(10, 5, viewAddr.width-40, 40)];
    
    [lblAddress setBackgroundColor:MAIN_COLOR];
    
    [lblAddress setFont:XFONT(12)];
    
    [lblAddress setTextColor:UIColorFromRGB(0xFFFFFF)];
    
    [viewAddr addSubview:lblAddress];
    
    UIImageView *imgMap = [[UIImageView alloc] initWithFrame:Rect(viewAddr.width-40,12.5, 25, 25)];
    
    [viewAddr addSubview:imgMap];
    
    [imgMap setImage:[UIImage imageNamed:@"map"]];
    
    [lblAddress setText:@"工作地址:越秀区恒福路18号(麓湖路口麓湖公)"];
    
    [headView addSubview:[self createSmallImage:@"clock" frame:Rect(10, viewAddr.y+viewAddr.height+14,15, 15)]];
    
    lblTime = [[UILabel alloc] initWithFrame:Rect(30, viewAddr.y+viewAddr.height+15,headView.width-50, 13)];
    
    [lblTime setFont:XFONT(12)];
    
    [lblTime setTextColor:UIColorFromRGB(0x000000)];
    
    [headView addSubview:lblTime];
    
    [lblTime setText:@"发布时间:2015-08-15"];
    
    
    [headView addSubview:[self createSmallImage:@"time" frame:Rect(10, lblTime.y+lblTime.height+11,15, 15)]];
    
    lblJobTime = [[UILabel alloc] initWithFrame:Rect(30, lblTime.y+lblTime.height+12,lblTime.width, 13)];
    
    [lblJobTime setFont:XFONT(12)];
    
    [lblJobTime setTextColor:UIColorFromRGB(0x000000)];
    
    [headView addSubview:lblJobTime];
    
    [lblJobTime setText:@"工作时间:周一至周五"];
    
    [headView addSubview:[self createSmallImage:@"money" frame:Rect(10, lblJobTime.y+lblJobTime.height+11,15, 15)]];
    
    lblPrice = [[UILabel alloc] initWithFrame:Rect(30, lblJobTime.y+lblJobTime.height+12,lblTime.width, 13)];
    
    [lblPrice setFont:XFONT(12)];
    
    [lblPrice setTextColor:UIColorFromRGB(0x000000)];
    
    [headView addSubview:lblPrice];
    [lblPrice setText:@"薪资:15元/小时"];
    
    [self addLineView:headView.height+headView.y+17];
    
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:Rect(10, headView.height+headView.y+34.2, kScreenSourchWidth-20, 20)];
    
    [lblTemp setText:@"职位描述"];
    
    [lblTemp setFont:XFONT(16)];
    
    [lblTemp setTextColor:UIColorFromRGB(0x00000)];
    
    [self.view addSubview:lblTemp];
    
    txtContent = [[UITextView alloc] initWithFrame:Rect(10, lblTemp.y+lblTemp.height+10, kScreenSourchWidth-20, 50)];
    
    [txtContent setUserInteractionEnabled:NO];
    
    [txtContent setText:@"[岗位职责]\r\n 1.负责CMS网站的网页设计、优化;\r\n 2.确保前端界面在不同浏览器和分辨率下保持优质"];
    
    [self.view addSubview:txtContent];
    
    [self addLineView:kScreenSourchHeight-55];
    
    XLoginButton *btnRequest = [XLoginButton buttonWithType:UIButtonTypeCustom];
    
    [btnRequest setTitle:@"立即申请" forState:UIControlStateNormal];
    
    [btnRequest setBackgroundColor:RGB(59, 118, 199)];
    
    [self.view addSubview:btnRequest];
    
    btnRequest.frame = Rect(10, kScreenSourchHeight-50, kScreenSourchWidth-20, 45);
    
    [btnRequest setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    
    [btnRequest setTitleColor:RGB(0, 0, 0) forState:UIControlStateHighlighted];
    [btnRequest addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
}

-(void)sendMessage
{
    if ([UserInfo sharedUserInfo].strJianliId==nil)
    {
        [self.view makeToast:@"简历为空"];
        return ;
    }
//jianzhiid 兼职表主键
    NSString *strInfo = [NSString stringWithFormat:@"%@jianzhi/applyJianzhi?token=%@&jianzhiid=%@&publishuserid=%@&shengqinguserid=%@&jianliid=%@",KHttpServer,[UserInfo sharedUserInfo].strToken,_model.strJZId,_model.strUserId,[UserInfo sharedUserInfo].strUserId,[UserInfo sharedUserInfo].strJianliId];
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id responseObject)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
    }
    fail:^(NSError *error)
    {
        
    }];
}

-(void)addLineView:(CGFloat)fOrginY
{
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0,fOrginY, kScreenSourchWidth, 0.2)];
    line1.backgroundColor = [UIColor colorWithRed:198/255.0
                                            green:198/255.0
                                             blue:198/255.0
                                            alpha:1.0];
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, fOrginY+0.2, kScreenSourchWidth ,0.2)] ;
    line2.backgroundColor = [UIColor whiteColor];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    [self.view addSubview:line1];
    [self.view addSubview:line2];
}

-(UIImageView*)createSmallImage:(NSString *)strName frame:(CGRect)frame
{
    UIImageView *imgTemp1 = [[UIImageView alloc] initWithFrame:frame];
    [imgTemp1 setImage:[UIImage imageNamed:strName]];
    return imgTemp1;
}

-(void)map
{
    BOOL hasBaiduMap = NO;
    BOOL hasGaodeMap = NO;
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]){
        hasBaiduMap = YES;
    }
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        hasGaodeMap = YES;
    }
    NSString *strTilte = @"";
    
//    if ([@"使用百度地图导航" isEqualToString:strTilte])
//    {
//        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving",currentLat, currentLon,_shopLat,_shopLon] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
//        
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
//    }
//    else if ([@"使用高德地图导航" isEqualToString:strTilte])
//    {
//        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%f&lon=%f&dev=1&style=2",@"app name", yourscheme, @"终点", _shopLat, _shopLon] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
//    }
}

@end
