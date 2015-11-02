//
//  IdeaDetailViewController.m
//  college
//
//  Created by xiongchi on 15/9/10.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "IdeaDetailViewController.h"
#import "XView.h"
#import "UIImageView+WebCache.h"
#import "TeachModel.h"
#import "Toast+UIView.h"
#import "UIImageView+WebCache.h"
#import "EmojiTextAttachment.h"
#import "SDImageCache.h"
#import "NSAttributedString+EmojiExtension.h"
#import "UserInfo.h"
#import "BaseService.h"
#import "IdeaModel.h"

@interface IdeaDetailViewController ()
{
    UIImageView *imgHead;
    UILabel *lblNick;
    UILabel *lblCreateTime;
    UILabel *lblMoney;
    UILabel *lblTitle;
    UILabel *lblIntrol;
    UIScrollView *scrollView;
    
    UITextView *txtView;
}

@property (nonatomic,strong) IdeaModel *model;
@property (nonatomic,strong) NSMutableDictionary *aryDict;

@end


@implementation IdeaDetailViewController

-(id)initWithModel:(IdeaModel *)model
{
    self = [super init];
    _aryDict = [NSMutableDictionary dictionary];
    _model = model;
    DLog(@"bbsid:%@",_model.strIdeaId);
    __weak IdeaDetailViewController *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [__self download];
    });
    
    return self;
}


-(void)download
{
    NSArray *ary = [_model.strImg componentsSeparatedByString:@","];
    __weak IdeaDetailViewController *__self = self;
    __block NSInteger __nLength =ary.count;
    for (int i=0; i<ary.count;i++)
    {
        NSString *strUrl = [NSString stringWithFormat:@"%@pub/download/idea/%@?token=%@&pictureid=%@",KHttpServer,_model.strIdeaId,[UserInfo sharedUserInfo].strToken,[ary objectAtIndex:i]];
        DLog(@"i:%d",i);
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:strUrl];
        if (image)
        {
            DLog(@"存在");
            [_aryDict setObject:image forKey:strUrl];
            if ([_aryDict allKeys].count==__nLength)
            {
                if ([__self isViewLoaded])
                {
                    dispatch_async(dispatch_get_main_queue(),
                                   ^{
                                       [__self setImageView];
                                   });
                }
            }
        }
        else
        {
            [manager downloadImageWithURL:[NSURL URLWithString:strUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
             {
                 DLog(@"下载成功");
                 DLog(@"image:%@",imageURL);
                 if (image)
                 {
                     [__self.aryDict setObject:image forKey:[imageURL absoluteString]];
                     if ([_aryDict allKeys].count==__nLength)
                     {
                         if ([__self isViewLoaded])
                         {
                             dispatch_async(dispatch_get_main_queue(),
                                            ^{
                                                [__self setImageView];
                                            });
                         }
                     }
                 }
             }];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:VIEW_BACK];
    [self setTitleText:@"创意"];
    
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
    
    lblMoney = [[UILabel alloc] initWithFrame:Rect(lblNick.x,lblCreateTime.y+lblCreateTime.height+10, lblCreateTime.width, 20)];
    
    [lblMoney setFont:XFONT(14)];
    
    [lblMoney setTextColor:MAIN_COLOR];
    
    [lblMoney setText:[NSString stringWithFormat:@"人民币:%@",_model.strCost]];
    
    [scrollView addSubview:lblMoney];
    
    [self addLineView:scrollView heaght:lblMoney.y+lblMoney.height+5];
    
    lblTitle=[[UILabel alloc] initWithFrame:Rect(10, lblMoney.y+lblMoney.height+10, kScreenSourchWidth-60, 20)];
    
    [lblTitle setFont:XFONT(15)];
    
    [lblTitle setTextColor:UIColorFromRGB(0x333333)];
    
    [scrollView addSubview:lblTitle];
    
    [lblTitle setText:_model.strTitle];
    
    lblIntrol = [[UILabel alloc] initWithFrame:Rect(10, lblTitle.y+lblTitle.height+5, kScreenSourchWidth-20, 30)];
    
    [lblIntrol setFont:XFONT(14)];
    
    [lblIntrol setTextColor:UIColorFromRGB(0x333333)];
    
    CGRect size = [_model.strIntrol boundingRectWithSize:CGSizeMake(lblIntrol.width,kScreenSourchHeight*3)
                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                             attributes:[NSDictionary dictionaryWithObjectsAndKeys:lblTitle.font,NSFontAttributeName, nil] context:nil];
    lblIntrol.frame = Rect(10, lblTitle.y+lblTitle.height+5, kScreenSourchWidth-20, size.size.height);
    
    lblIntrol.text = _model.strIntrol;
    
    [scrollView addSubview:lblIntrol];
    
    if ([_model.strSell isEqualToString:@"N"])
    {
        UIButton *btnPush = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnPush setTitle:@"支付" forState:UIControlStateNormal];
        [btnPush setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [btnPush setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateHighlighted];
        [btnPush.layer setMasksToBounds:YES];
        [btnPush.layer setCornerRadius:5.0];
        
        [btnPush addTarget:self action:@selector(pushEvent) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btnPush];
        
        [btnPush setBackgroundColor:MAIN_COLOR];
        
        btnPush.frame = Rect(10, kScreenSourchHeight-50, kScreenSourchWidth-20, 45);
        return ;
    }

    txtView = [[UITextView alloc] initWithFrame:Rect(0,lblIntrol.y+lblIntrol.height+10, kScreenSourchWidth,
                                                        kScreenSourchHeight-(lblIntrol.y+lblIntrol.height+10+50))];
    [txtView setFont:XFONT(12)];

    [scrollView addSubview:txtView];

    [txtView setEditable:NO];

    [txtView setScrollEnabled:NO];

    NSArray *ary = [_model.strImg componentsSeparatedByString:@","];

    if ([_aryDict allKeys].count==ary.count)
    {
        [self setImageView];
    }
}

-(void)createView
{
    txtView = [[UITextView alloc] initWithFrame:Rect(0,lblIntrol.y+lblIntrol.height+10, kScreenSourchWidth,
                                                     kScreenSourchHeight-(lblIntrol.y+lblIntrol.height+10+50))];
    [txtView setFont:XFONT(12)];
    
    [scrollView addSubview:txtView];
    
    [txtView setEditable:NO];
    
    [txtView setScrollEnabled:NO];
    
    NSArray *ary = [_model.strImg componentsSeparatedByString:@","];
    
    if ([_aryDict allKeys].count==ary.count)
    {
        [self setImageView];
    }
}

-(void)pushEvent
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确认支付:%@",_model.strCost] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
    [alert show];
    
}

-(void)setImageView
{
    NSString *_strContent = _model.strContent;
    if(_model.strContent)
    {
        _strContent = [_strContent stringByReplacingOccurrencesOfString:@"\n" withString:@"\r\n"];
    }
    NSMutableArray *aryIndex = [NSMutableArray array];
    while (YES&&_strContent)
    {
        NSRange start = [_strContent rangeOfString:@"<img>"];
        if (start.location == NSNotFound)
        {
            break;
        }
        NSRange end = [_strContent rangeOfString:@"</img>"];
        NSLog(@"rang:%@",[_strContent substringWithRange:NSMakeRange(start.location,end.location+end.length-start.location)]);
        _strContent = [_strContent stringByReplacingCharactersInRange:NSMakeRange(start.location,end.location+end.length-start.location) withString:@""];
        
        [aryIndex addObject:[NSNumber numberWithInteger:start.location]];
    }
    txtView.text = _strContent;
    NSArray *array = [_model.strImg componentsSeparatedByString:@","];
    CGFloat fHeight = 0;
    int nNumber = 0;
    for (NSNumber *number in aryIndex)
    {
        EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
        //Set tag and image
        emojiTextAttachment.emojiTag = @"<img>{width:100,height:100}</img>";
        NSString *strUrl = [NSString stringWithFormat:@"%@pub/download/idea/%@?token=%@&pictureid=%@",KHttpServer,_model.strIdeaId,[UserInfo sharedUserInfo].strToken,[array objectAtIndex:nNumber]];
        
        emojiTextAttachment.image = [_aryDict objectForKey:strUrl];
        
        CGSize imageSize = [emojiTextAttachment.image size];
        emojiTextAttachment.emojiSize = imageSize.width>=txtView.width? txtView.width :imageSize.width;
        
        CGFloat imgHeight = imageSize.height*(CGFloat)
        (emojiTextAttachment.emojiSize /((imageSize.width==0) ? kScreenSourchWidth:imageSize.width));
        
        DLog(@"imgHeight:%f",imgHeight);
        
        fHeight+=imgHeight;
        
        [txtView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]
                                               atIndex:[number intValue]];
        nNumber++;
    }
    DLog(@"fHeight:%f",fHeight);
    
    txtView.frame = Rect(0, lblIntrol.y+lblIntrol.height+10, kScreenSourchWidth, fHeight);
    
    [scrollView setContentSize:CGSizeMake(kScreenSourchWidth, txtView.y+txtView.height)];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)payInfo
{
    NSString *strUrl = [NSString stringWithFormat:@"%@idea/pay/%@?userid=%@&token=%@",KHttpServer,_model.strIdeaId,[UserInfo sharedUserInfo].strUserId,[UserInfo sharedUserInfo].strToken];
    __weak IdeaDetailViewController *__self = self;
    [BaseService postJSONWithUrl:strUrl parameters:nil success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[dict objectForKey:@"status"] intValue]==200)
        {
            DLog(@"支付成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self createView];
                [__self setImageView];
            });
        }
    } fail:^(NSError *error) {
        
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self.view makeToastActivity];
            __weak IdeaDetailViewController *__self = self;
            dispatch_async(dispatch_get_global_queue(0, 0),
            ^{
                [__self payInfo];
            });
        }
            break;
        default:
        {
            
        }
            break;
    }
}

@end
