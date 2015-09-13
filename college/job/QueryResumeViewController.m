//
//  QueryResumeViewController.m
//  college
//
//  Created by xiongchi on 15/9/7.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "QueryResumeViewController.h"
#import "UserInfo.h"
#import "UIImageView+WebCache.h"
#import "ResumeModel.h"
@interface QueryResumeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *lblName;
//    UILabel *lblMobile;
//    UILabel *lblEmail;
}

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) ResumeModel *model;

@end

@implementation QueryResumeViewController

-(id)initWIthModel:(ResumeModel *)model
{
    self = [super init];
    
    _model = model;
    
    return self;
}

-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initView
{
    [self setTitleText:_model.strTitle];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateHighlighted];
    
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftBtn:btnBack];
    
    UIView *headView = [[UIView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, 60)];
    
    [self.view addSubview:headView];
    
    [headView setBackgroundColor:MAIN_COLOR];
    
    _imgView = [[UIImageView alloc] initWithFrame:Rect(kScreenSourchWidth/2-42, headView.y+headView.height-42, 84, 84)];
    
    [self.view addSubview:_imgView];
    NSString *strImg = [NSString stringWithFormat:@"%@pub/downloadJianLiPicture?token=%@&jianliid=%@&uesrid=%@",
                        KHttpServer,[UserInfo sharedUserInfo].strToken,_model.strJLId,[UserInfo sharedUserInfo].strUserId];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:strImg] placeholderImage:[UIImage imageNamed:@"moren_longin"]];
    
    [_imgView.layer setMasksToBounds:YES];
    [_imgView.layer setCornerRadius:42];
    
    lblName = [[UILabel alloc] initWithFrame:Rect(10,_imgView.y+_imgView.height+10,kScreenSourchWidth-20,20)];
    
    [lblName setFont:XFONT(15)];
    
    [lblName setTextColor:UIColorFromRGB(0x222222)];
    
    [lblName setText:_model.strName];
    
    [lblName setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:lblName];

    _scrollView = [[UIScrollView alloc] initWithFrame:Rect(0, _imgView.y+_imgView.height+35,kScreenSourchWidth,
                                                           kScreenSourchHeight-(_imgView.y+_imgView.height+35))];
    [self.view addSubview:_scrollView];
    
    CGFloat fHeight = [self initPersonInfoView];
    
    if(_model.aryEduca.count>=1)
    {
        fHeight = fHeight + [self initEducation:fHeight];
    }
    
    if (_model.aryStuHor.count>=1)
    {
        fHeight = fHeight + [self initStuHor:fHeight];
    }
    
    if(_model.aryTrueJob.count>=1)
    {
        fHeight = fHeight + [self initTrueJob:fHeight];
    }
    
    if(_model.aryLang.count>=1)
    {
        fHeight = fHeight + [self initLang:fHeight];
    }
    
    if(_model.aryTrain.count>=1)
    {
        fHeight = fHeight + [self initTrain:fHeight];
    }
    if (_model.strEvaluation)
    {
        fHeight = fHeight + [self initContent:fHeight];
    }
    _scrollView.contentSize = CGSizeMake(kScreenSourchWidth,fHeight);
}

-(CGFloat)initContent:(CGFloat)fHeight
{
    UIView *headView = [[UIView alloc] initWithFrame:Rect(10, fHeight, kScreenSourchWidth-20,200)];
    
    [_scrollView addSubview:headView];
    
    [headView.layer setMasksToBounds:YES];
    
    [headView.layer setCornerRadius:5.0];
    
    [headView setBackgroundColor:UIColorFromRGB(0xf4ebec)];
    
    UIView *upView = [[UIView alloc] initWithFrame:Rect(0, 0, headView.width,30)];
    
    [headView addSubview:upView];
    
    [upView setBackgroundColor:UIColorFromRGB(0x417bc4)];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:Rect(10, 0, upView.width-20, 30)];
    
    [lblTitle setFont:XFONT(15)];
    
    [lblTitle setText:[NSString stringWithFormat:@"自我评价"]];
    
    [lblTitle setTextColor:UIColorFromRGB(0xFFFFFF)];
    
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    
    [upView addSubview:lblTitle];
    
    CGFloat fAll = upView.y+upView.height+6;
    
    NSString *strInfo = [NSString stringWithFormat:@"   %@",_model.strEvaluation];
    
    NSDictionary *attributes = @{NSFontAttributeName:XFONT(14)};
    
    CGSize textSize = [strInfo boundingRectWithSize:CGSizeMake(headView.width-20, 0) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;;
    
    UITextView *txtView = [[UITextView alloc] initWithFrame:Rect(10,fAll,headView.width-20, textSize.height+20)];
    
    [headView addSubview:txtView];
    
    [txtView setText:strInfo];
    
    [txtView setFont:XFONT(12)];
    
    [txtView setTextColor:UIColorFromRGB(0x222222)];
    
    txtView.editable = NO;
    
    [txtView setBackgroundColor:[UIColor clearColor]];
    
    fAll += txtView.height;
    
    headView.frame = Rect(10,fHeight,kScreenSourchWidth-20,fAll+10);
    
    return headView.height+10;
}

-(CGFloat)initTrain:(CGFloat)fHeight
{
    UIView *headView = [[UIView alloc] initWithFrame:Rect(10, fHeight, kScreenSourchWidth-20,200)];
    
    [_scrollView addSubview:headView];
    
    [headView.layer setMasksToBounds:YES];
    
    [headView.layer setCornerRadius:5.0];
    
    [headView setBackgroundColor:UIColorFromRGB(0xf4ebec)];
    
    UIView *upView = [[UIView alloc] initWithFrame:Rect(0, 0, headView.width,30)];
    
    [headView addSubview:upView];
    
    [upView setBackgroundColor:UIColorFromRGB(0x417bc4)];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:Rect(10, 0, upView.width-20, 30)];
    
    [lblTitle setFont:XFONT(15)];
    
    [lblTitle setText:[NSString stringWithFormat:@"培训经历"]];
    
    [lblTitle setTextColor:UIColorFromRGB(0xFFFFFF)];
    
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    
    [upView addSubview:lblTitle];
    
    CGFloat fAll = upView.y+upView.height+6;
    int i=0;
    for (XTrain *stuHor in _model.aryTrain)
    {
        UILabel *lblTime = [[UILabel alloc] initWithFrame:Rect(40,fAll,headView.width-50,20)];
        [headView addSubview:lblTime];
        [self setLabelStyle:lblTime text:[NSString stringWithFormat:@"%@",stuHor.strTime]];
        
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:Rect(20,lblTime.y+2.5,15,15)];
        [headView addSubview:img1];
        [img1 setImage:[UIImage imageNamed:@"clock"]];
        
        fAll += 25;
        
        UILabel *lblSchool = [[UILabel alloc] initWithFrame:Rect(40,fAll,headView.width-50, 20)];
        [headView addSubview:lblSchool];
        
        UIImageView *img2 = [[UIImageView alloc] initWithFrame:Rect(20,lblSchool.y+2.5,15,15)];
        [headView addSubview:img2];
        [img2 setImage:[UIImage imageNamed:@"birthday"]];
        [self setLabelStyle:lblSchool text:[NSString stringWithFormat:@"%@",stuHor.strKecheng]];
        
        if(i != _model.aryTrain.count-1)
        {
            UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(0, fAll+22,headView.width, 0.5)];
            [lblContent setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
            [headView addSubview:lblContent];
        }
        i++;
        fAll += 25;
    }
    
    headView.frame = Rect(10,fHeight,kScreenSourchWidth-20,fAll);
    
    return headView.height+10;
}

-(CGFloat)initLang:(CGFloat)fHeight
{
    UIView *headView = [[UIView alloc] initWithFrame:Rect(10, fHeight, kScreenSourchWidth-20,200)];
    
    [_scrollView addSubview:headView];
    
    [headView.layer setMasksToBounds:YES];
    
    [headView.layer setCornerRadius:5.0];
    
    [headView setBackgroundColor:UIColorFromRGB(0xf4ebec)];
    
    UIView *upView = [[UIView alloc] initWithFrame:Rect(0, 0, headView.width,30)];
    
    [headView addSubview:upView];
    
    [upView setBackgroundColor:UIColorFromRGB(0x417bc4)];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:Rect(10, 0, upView.width-20, 30)];
    
    [lblTitle setFont:XFONT(15)];
    
    [lblTitle setText:[NSString stringWithFormat:@"语言能力"]];
    
    [lblTitle setTextColor:UIColorFromRGB(0xFFFFFF)];
    
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    
    [upView addSubview:lblTitle];
    
    CGFloat fAll = upView.y+upView.height+6;
    int i=0;
    for (XLanguage *stuHor in _model.aryLang)
    {
        UILabel *lblTime = [[UILabel alloc] initWithFrame:Rect(40,fAll,headView.width-50,20)];
        [headView addSubview:lblTime];
        [self setLabelStyle:lblTime text:[NSString stringWithFormat:@"%@   %@",stuHor.strType,stuHor.strChengdu]];
        
        
        if(i != _model.aryLang.count-1)
        {
            UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(0, fAll+22,headView.width, 0.5)];
            [lblContent setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
            [headView addSubview:lblContent];
        }
        i++;
        fAll += 25;
    }
    
    headView.frame = Rect(10,fHeight,kScreenSourchWidth-20,fAll);
    
    return headView.height+10;
}

-(CGFloat)initTrueJob:(CGFloat)fHeight
{
    UIView *headView = [[UIView alloc] initWithFrame:Rect(10, fHeight, kScreenSourchWidth-20,200)];
    
    [_scrollView addSubview:headView];
    
    [headView.layer setMasksToBounds:YES];
    
    [headView.layer setCornerRadius:5.0];
    
    [headView setBackgroundColor:UIColorFromRGB(0xf4ebec)];
    
    UIView *upView = [[UIView alloc] initWithFrame:Rect(0, 0, headView.width,30)];
    
    [headView addSubview:upView];
    
    [upView setBackgroundColor:UIColorFromRGB(0x417bc4)];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:Rect(10, 0, upView.width-20, 30)];
    
    [lblTitle setFont:XFONT(15)];
    
    [lblTitle setText:[NSString stringWithFormat:@"实践经历"]];
    
    [lblTitle setTextColor:UIColorFromRGB(0xFFFFFF)];
    
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    
    [upView addSubview:lblTitle];
    
    CGFloat fAll = upView.y+upView.height+6;
    int i=0;
    for (XTrueJob *stuHor in _model.aryTrueJob)
    {
        UILabel *lblTime = [[UILabel alloc] initWithFrame:Rect(40,fAll,headView.width-50,20)];
        [headView addSubview:lblTime];
        [self setLabelStyle:lblTime text:[NSString stringWithFormat:@"%@",stuHor.strTime]];
        
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:Rect(20,lblTime.y+2.5,15,15)];
        [headView addSubview:img1];
        [img1 setImage:[UIImage imageNamed:@"clock"]];
        
        fAll += 25;
        
        UILabel *lblSchool = [[UILabel alloc] initWithFrame:Rect(40,fAll,headView.width-50, 20)];
        [headView addSubview:lblSchool];
        
        UIImageView *img2 = [[UIImageView alloc] initWithFrame:Rect(20,lblSchool.y+2.5,15,15)];
        [headView addSubview:img2];
        [img2 setImage:[UIImage imageNamed:@"birthday"]];
        [self setLabelStyle:lblSchool text:[NSString stringWithFormat:@"%@",stuHor.strZhiwei]];
        
        if(i != _model.aryEduca.count-1)
        {
            UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(0, fAll+22,headView.width, 0.5)];
            [lblContent setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
            [headView addSubview:lblContent];
        }
        i++;
        fAll += 25;
    }
    
    headView.frame = Rect(10,fHeight,kScreenSourchWidth-20,fAll);
    
    return headView.height+10;
}

-(CGFloat)initStuHor:(CGFloat)fHeight
{
    UIView *headView = [[UIView alloc] initWithFrame:Rect(10, fHeight, kScreenSourchWidth-20,200)];
    
    [_scrollView addSubview:headView];
    
    [headView.layer setMasksToBounds:YES];
    
    [headView.layer setCornerRadius:5.0];
    
    [headView setBackgroundColor:UIColorFromRGB(0xf4ebec)];
    
    UIView *upView = [[UIView alloc] initWithFrame:Rect(0, 0, headView.width,30)];
    
    [headView addSubview:upView];
    
    [upView setBackgroundColor:UIColorFromRGB(0x417bc4)];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:Rect(10, 0, upView.width-20, 30)];
    
    [lblTitle setFont:XFONT(15)];
    
    [lblTitle setText:[NSString stringWithFormat:@"学生奖励"]];
    
    [lblTitle setTextColor:UIColorFromRGB(0xFFFFFF)];
    
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    
    [upView addSubview:lblTitle];
    
    CGFloat fAll = upView.y+upView.height+6;
    int i=0;
    for (XStuHor *stuHor in _model.aryStuHor)
    {
        UILabel *lblTime = [[UILabel alloc] initWithFrame:Rect(40,fAll,headView.width-50,20)];
        [headView addSubview:lblTime];
        [self setLabelStyle:lblTime text:[NSString stringWithFormat:@"%@",stuHor.strTime]];
        
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:Rect(20,lblTime.y+2.5,15,15)];
        [headView addSubview:img1];
        [img1 setImage:[UIImage imageNamed:@"clock"]];
        
        fAll += 25;
        
        UILabel *lblSchool = [[UILabel alloc] initWithFrame:Rect(40,fAll,headView.width-50, 20)];
        [headView addSubview:lblSchool];
        
        UIImageView *img2 = [[UIImageView alloc] initWithFrame:Rect(20,lblSchool.y+2.5,15,15)];
        [headView addSubview:img2];
        [img2 setImage:[UIImage imageNamed:@"birthday"]];
        [self setLabelStyle:lblSchool text:[NSString stringWithFormat:@"%@",stuHor.strName]];
        
        if(i != _model.aryEduca.count-1)
        {
            UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(0, fAll+22,headView.width, 0.5)];
            [lblContent setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
            [headView addSubview:lblContent];
        }
        i++;
        fAll += 25;
    }
    
    headView.frame = Rect(10,fHeight,kScreenSourchWidth-20,fAll);
    
    return headView.height+10;
}

-(CGFloat)initEducation:(CGFloat)fHeight
{
    UIView *headView = [[UIView alloc] initWithFrame:Rect(10, fHeight, kScreenSourchWidth-20,200)];
    
    [_scrollView addSubview:headView];
   
    [headView.layer setMasksToBounds:YES];
    
    [headView.layer setCornerRadius:5.0];
    
    [headView setBackgroundColor:UIColorFromRGB(0xf4ebec)];
    
    UIView *upView = [[UIView alloc] initWithFrame:Rect(0, 0, headView.width,30)];
    
    [headView addSubview:upView];
    
    [upView setBackgroundColor:UIColorFromRGB(0x417bc4)];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:Rect(10, 0, upView.width-20, 30)];
    
    [lblTitle setFont:XFONT(15)];
    
    [lblTitle setText:[NSString stringWithFormat:@"教育信息"]];
    
    [lblTitle setTextColor:UIColorFromRGB(0xFFFFFF)];
    
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    
    [upView addSubview:lblTitle];
    
    CGFloat fAll = upView.y+upView.height+6;
    int i = 0;
    for (XEducation *educa in _model.aryEduca)
    {
        UILabel *lblTime = [[UILabel alloc] initWithFrame:Rect(40,fAll,headView.width-50,20)];
        [headView addSubview:lblTime];
        [self setLabelStyle:lblTime text:[NSString stringWithFormat:@"%@-%@",educa.strStart,educa.strEnd]];
        
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:Rect(20,lblTime.y+2.5,15,15)];
        [headView addSubview:img1];
        [img1 setImage:[UIImage imageNamed:@"clock"]];
        
        fAll += 25;
        
        UILabel *lblSchool = [[UILabel alloc] initWithFrame:Rect(40,fAll,headView.width-50, 20)];
        [headView addSubview:lblSchool];
        
        UIImageView *img2 = [[UIImageView alloc] initWithFrame:Rect(20,lblSchool.y+2.5,15,15)];
        [headView addSubview:img2];
        [img2 setImage:[UIImage imageNamed:@"birthday"]];
        [self setLabelStyle:lblSchool text:[NSString stringWithFormat:@"%@",educa.strSchool]];
        
        if(i != _model.aryEduca.count-1)
        {
            UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(0, fAll+22,headView.width, 0.5)];
            [lblContent setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
            [headView addSubview:lblContent];
        }
        
        fAll += 25;
        i++;
    }
    
    headView.frame = Rect(10,fHeight,kScreenSourchWidth-20,fAll);
    
    return headView.height;
}



-(CGFloat)initPersonInfoView
{
    
    CGFloat fHeight=0;
    
    UIView *headView = [[UIView alloc] initWithFrame:Rect(10,5, kScreenSourchWidth-20, 200)];
    
    [_scrollView addSubview:headView];
    
    [headView.layer setMasksToBounds:YES];
    
    [headView.layer setCornerRadius:5.0];
    
    [headView setBackgroundColor:UIColorFromRGB(0xf4ebec)];
    
    UIView *upView = [[UIView alloc] initWithFrame:Rect(0, 0, headView.width,30)];
    
    [headView addSubview:upView];
    
    [upView setBackgroundColor:MAIN_COLOR];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:Rect(10, 0, upView.width-20, 30)];
    
    [lblTitle setFont:XFONT(15)];

    [lblTitle setText:[NSString stringWithFormat:@"个人信息"]];

    [lblTitle setTextColor:UIColorFromRGB(0xFFFFFF)];

    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    
    [upView addSubview:lblTitle];
    
    UILabel *lblSex = [[UILabel alloc] initWithFrame:Rect(40,upView.y+upView.height+6,headView.width-50, 20)];
    
    [headView addSubview:lblSex];
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:Rect(20, lblSex.y+2.5, 15, 15)];
    [headView addSubview:img1];
    [img1 setImage:[UIImage imageNamed:@"icon_touxiang"]];
    [self setLabelStyle:lblSex text:[NSString stringWithFormat:@"性别: %@",_model.strSex]];
    
    UILabel *lblBirthday = [[UILabel alloc] initWithFrame:Rect(40,lblSex.y+lblSex.height+5,headView.width-50, 20)];
    [headView addSubview:lblBirthday];
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:Rect(20, lblBirthday.y+2.5, 15, 15)];
    [headView addSubview:img2];
    [img2 setImage:[UIImage imageNamed:@"birthday"]];
    
    [self setLabelStyle:lblBirthday text:[NSString stringWithFormat:@"生日: %@",_model.strBirthDay]];
    
    UILabel *lblMobile = [[UILabel alloc] initWithFrame:Rect(40,lblBirthday.y+lblBirthday.height+5,headView.width-50, 20)];
    [headView addSubview:lblMobile];
    
    UIImageView *img3 = [[UIImageView alloc] initWithFrame:Rect(20, lblMobile.y+2.5, 15, 15)];
    [headView addSubview:img3];
    [img3 setImage:[UIImage imageNamed:@"birthday"]];
    
    [self setLabelStyle:lblMobile text:[NSString stringWithFormat:@"手机: %@",_model.strMobile]];
   
    fHeight = lblMobile.y+lblMobile.height+5;
    
    if (_model.strCard)
    {
        
        UILabel *lblCard = [[UILabel alloc] initWithFrame:Rect(40,fHeight,headView.width-50, 20)];
        
        [headView addSubview:lblCard];
        UIImageView *img4 = [[UIImageView alloc] initWithFrame:Rect(20, lblCard.y+2.5, 15, 15)];
        [headView addSubview:img4];
        [img4 setImage:[UIImage imageNamed:@"birthday"]];
        [self setLabelStyle:lblCard text:[NSString stringWithFormat:@"身份证: %@",_model.strCard]];
        
        fHeight += 30;
    }
    
    if (_model.strEmail)
    {
        UILabel *lblEmail = [[UILabel alloc] initWithFrame:Rect(40,fHeight,headView.width-50, 20)];
        
        [headView addSubview:lblEmail];
        
        [self setLabelStyle:lblEmail text:[NSString stringWithFormat:@"邮箱: %@",_model.strEmail]];
        
        UIImageView *img4 = [[UIImageView alloc] initWithFrame:Rect(20, lblEmail.y+2.5, 15, 15)];
        [headView addSubview:img4];
        [img4 setImage:[UIImage imageNamed:@"birthday"]];
        
        fHeight += 30;
    }
    
    headView.frame = Rect(10,0,kScreenSourchWidth-20,fHeight);
    
    return fHeight+10;
}

-(void)setLabelStyle:(UILabel *)lblTemp text:(NSString *)strContent
{
    [lblTemp setText:strContent];
    
    [lblTemp setFont:XFONT(12)];
    
    [lblTemp setTextColor:UIColorFromRGB(0x656565)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
