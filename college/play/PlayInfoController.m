//
//  PlayInfoController.m
//  college
//
//  Created by xiongchi on 15/8/28.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "PlayInfoController.h"
#import "XLoginButton.h"
#import "SDWebImageManager.h"
#import "Toast+UIView.h"
#import "UserInfo.h"
#import "BaseService.h"
#import "UIImageView+WebCache.h"
#import "PlayModel.h"
#import "EmojiTextAttachment.h"
#import "SDImageCache.h"
#import "NSAttributedString+EmojiExtension.h"


@interface PlayInfoController ()<UITextViewDelegate>
{
    UIImageView *imgHead;
    UILabel *lblName;
    UITextView *txtAddress;
    UILabel *lblType;
    UILabel *lblTime;
    UITextView *txtContent;
    UIScrollView *scrollView;
    NSMutableArray *aryIndex;
}
@property (nonatomic,strong) PlayModel *model;
@property (nonatomic,strong) NSMutableDictionary *aryDict;

@end

@implementation PlayInfoController

-(void)joinPlayInfo
{
    
    NSString *strInfo = [NSString stringWithFormat:@"%@party/applyParty?partyid=%@&token=%@&publishuserid=%@&shengqinguserid=%@",KHttpServer,
                         _model.strPartyid,[UserInfo sharedUserInfo].strToken,_model.strUserid,[UserInfo sharedUserInfo].strUserId];
    __weak PlayInfoController *__self = self;
    [self.view makeToastActivity];
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[dict objectForKey:@"status"] intValue]==200)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self.view hideToastActivity];
                [__self.view makeToast:@"报名成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [__self navBack];
                });
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__self.view hideToastActivity];
                [__self.view makeToast:[dict objectForKey:@"msg"]];
            });
        }
    } fail:^(NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.view hideToastActivity];
            [__self.view makeToast:@"报名失败"];
        });
    }];
}

-(void)download
{
    NSArray *ary = [_model.strImg componentsSeparatedByString:@","];
    __weak PlayInfoController *__self = self;
    __block NSInteger __nLength =ary.count-1;
    for (int i=1; i<ary.count;i++)
    {
        NSString *strUrl = [NSString stringWithFormat:@"%@pub/download/party/%@?token=%@&pictureid=%@",KHttpServer,_model.strPartyid,[UserInfo sharedUserInfo].strToken,[ary objectAtIndex:i]];
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
             }];
        }
    }
}

-(id)initWithModel:(PlayModel *)model
{
    self = [super init];
    _model = model;
    _aryDict = [NSMutableDictionary dictionary];
    __weak PlayInfoController *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [__self download];
    });
    
    return self;
}

-(void)setPlayModel
{
    [lblName setText:_model.strTitle];

//    NSString *_strContent = _model.strContent;
//    if(_model.strContent)
//    {
//        _strContent = [_strContent stringByReplacingOccurrencesOfString:@"\n" withString:@"\r\n"];
//    }
//    aryIndex = [NSMutableArray array];
//    while (YES&&_strContent)
//    {
//        NSRange start = [_strContent rangeOfString:@"<img>"];
//        if (start.location == NSNotFound)
//        {
//            break;
//        }
//        NSRange end = [_strContent rangeOfString:@"</img>"];
//        NSLog(@"rang:%@",[_strContent substringWithRange:NSMakeRange(start.location,end.location+end.length-start.location)]);
//        _strContent = [_strContent stringByReplacingCharactersInRange:NSMakeRange(start.location,end.location+end.length-start.location) withString:@""];
//        
//        [aryIndex addObject:[NSNumber numberWithInteger:start.location]];
//    }
//    txtContent.text = _strContent;
    NSArray *array = [_model.strImg componentsSeparatedByString:@","];
//    CGFloat fHeight = 0;
//    for (NSNumber *number in aryIndex)
//    {
//        EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
//        //Set tag and image
//        emojiTextAttachment.emojiTag = @"<img>{width:100,height:100}</img>";
//        NSString *strUrl = [NSString stringWithFormat:@"%@pub/download/party/%@?token=%@&pictureid=%@",KHttpServer,_model.strPartyid,[UserInfo sharedUserInfo].strToken,[array objectAtIndex:nNumber]];
//        
//        emojiTextAttachment.image = [_aryDict objectForKey:[NSURL URLWithString:strUrl]];
//        
//        CGSize imageSize = [emojiTextAttachment.image size];
//         emojiTextAttachment.emojiSize = imageSize.width>=txtContent.width? txtContent.width :imageSize.width;
//    
//        CGFloat imgHeight = imageSize.height*(CGFloat)
//            (emojiTextAttachment.emojiSize /((imageSize.width==0) ? kScreenSourchWidth:imageSize.width));
//        
//        DLog(@"imgHeight:%F",imgHeight);
//        
//        fHeight+=imgHeight;
//        
//        [txtContent.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]
//                                            atIndex:[number intValue]];
//        nNumber++;
//    }
//    DLog(@"fHeight:%f",fHeight);
//    txtContent.frame = Rect(0, txtContent.y, kScreenSourchWidth, fHeight);
//    [scrollView setContentSize:CGSizeMake(kScreenSourchWidth, txtContent.y+txtContent.height)];
    
    [txtAddress setText:_model.strAddress];
    
    [lblTime setText:_model.strPartyTime];
    
    [lblType setText:_model.strPrice];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@pub/download/party/%@?token=%@&pictureid=%@",KHttpServer,_model.strPartyid,[UserInfo sharedUserInfo].strToken,[_model.strImg componentsSeparatedByString:@","][0]];
    
    [imgHead sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"firstFace"]];
    
    if ([_aryDict allValues].count == array.count-1)
    {
        [self setImageView];
    }
}

-(void)setImageView
{
    NSString *_strContent = _model.strContent;
    if(_model.strContent)
    {
        _strContent = [_strContent stringByReplacingOccurrencesOfString:@"\n" withString:@"\r\n"];
    }
    aryIndex = [NSMutableArray array];
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
    txtContent.text = _strContent;
    NSArray *array = [_model.strImg componentsSeparatedByString:@","];
    CGFloat fHeight = 0;
    int nNumber = 1;
    for (NSNumber *number in aryIndex)
    {
        EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
        //Set tag and image
        emojiTextAttachment.emojiTag = @"<img>{width:100,height:100}</img>";
        NSString *strUrl = [NSString stringWithFormat:@"%@pub/download/party/%@?token=%@&pictureid=%@",KHttpServer,_model.strPartyid,[UserInfo sharedUserInfo].strToken,[array objectAtIndex:nNumber]];
        
        emojiTextAttachment.image = [_aryDict objectForKey:strUrl];
        
        CGSize imageSize = [emojiTextAttachment.image size];
        emojiTextAttachment.emojiSize = imageSize.width>=txtContent.width? txtContent.width :imageSize.width;
        
        CGFloat imgHeight = imageSize.height*(CGFloat)
        (emojiTextAttachment.emojiSize /((imageSize.width==0) ? kScreenSourchWidth:imageSize.width));
        
        DLog(@"imgHeight:%F",imgHeight);
        
        fHeight+=imgHeight;
        
        [txtContent.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]
                                               atIndex:[number intValue]];
        nNumber++;
    }
    DLog(@"fHeight:%f",fHeight);
    txtContent.frame = Rect(0, txtContent.y, kScreenSourchWidth, fHeight);
    [scrollView setContentSize:CGSizeMake(kScreenSourchWidth, txtContent.y+txtContent.height)];
}

-(void)initView
{
    [self setTitleText:@"娱乐"];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateHighlighted];
    
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftBtn:btnBack];
    
    scrollView = [[UIScrollView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth,kScreenSourchHeight-119)];
    
    scrollView.scrollEnabled = YES;
    
    [self.view addSubview:scrollView];
    
    imgHead = [[UIImageView alloc] initWithFrame:Rect(0, 0, kScreenSourchWidth, 180)];
    
    [imgHead setImage:[UIImage imageNamed:@"firstFace"]];
    
    [scrollView addSubview:imgHead];
    
    UIView *backView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenSourchWidth, 180)];
    
    [scrollView addSubview:backView];
    
    [backView setBackgroundColor:RGB(126, 126, 126)];
    
    [backView setAlpha:0.5f];
    
    lblName = [[UILabel alloc] initWithFrame:Rect(10, imgHead.y+imgHead.height-30, 300, 20)];
   
    [lblName setFont:XFONT(15)];
    
    [lblName setText:@"电影点评会"];
    
    [lblName setTextColor:UIColorFromRGB(0xFFFFFF)];
    
    [scrollView addSubview:lblName];
    
    
    UIView *headView = [[UIView alloc] initWithFrame:Rect(10, lblName.y+lblName.height+17, kScreenSourchWidth-20, 120)];
    
    [headView.layer setMasksToBounds:YES];
    
    [headView.layer setCornerRadius:5.0f];
    
    [headView setBackgroundColor:UIColorFromRGB(0xF4EBEC)];
    
    [scrollView addSubview:headView];
    
    UIView *viewAddr = [[UIView alloc] initWithFrame:Rect(0, 0, headView.width, 50)];
    [viewAddr setBackgroundColor:MAIN_COLOR];
    [headView addSubview:viewAddr];
    
    txtAddress = [[UITextView alloc] initWithFrame:Rect(10, 7, viewAddr.width-20, 36)];
    
    [txtAddress setBackgroundColor:MAIN_COLOR];
    
    [txtAddress setFont:XFONT(12)];
    
    [txtAddress setTextColor:UIColorFromRGB(0xFFFFFF)];
    
    [viewAddr addSubview:txtAddress];
    
    [txtAddress setUserInteractionEnabled:NO];
    
    UIImageView *imgTemp1 = [[UIImageView alloc] initWithFrame:Rect(10, viewAddr.y+viewAddr.height+14,15, 15)];
    [imgTemp1 setImage:[UIImage imageNamed:@"kind"]];
    
    [headView addSubview:imgTemp1];
    
    lblType = [[UILabel alloc] initWithFrame:Rect(30, viewAddr.y+viewAddr.height+15,headView.width-50, 13)];
    
    [lblType setFont:XFONT(12)];
    
    [lblType setTextColor:UIColorFromRGB(0x000000)];
    
    [headView addSubview:lblType];
    
    UIImageView *imgTemp2 = [[UIImageView alloc] initWithFrame:Rect(10, lblType.y+lblType.height+14,15, 15)];
    [imgTemp2 setImage:[UIImage imageNamed:@"clock"]];
    
    [headView addSubview:imgTemp2];
    
    lblTime = [[UILabel alloc] initWithFrame:Rect(30, lblType.y+lblType.height+15,lblType.width, 13)];
    
    [lblTime setFont:XFONT(12)];
    
    [lblTime setTextColor:UIColorFromRGB(0x000000)];
    
    [headView addSubview:lblTime];
    
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:Rect(10, headView.y+headView.height+17, 130, 15)];
    
    [scrollView addSubview:lblTemp];
    
    [lblTemp setTextColor:UIColorFromRGB(0x00)];
    
    [lblTemp setText:@"活动介绍"];
    
    txtContent = [[UITextView alloc] initWithFrame:Rect(0, lblTemp.y+lblTemp.height+17, kScreenSourchWidth,
                                                        kScreenSourchHeight-lblTemp.y+lblTemp.height+17-50)];
    
    [txtContent setFont:XFONT(12)];
    
    [txtContent setEditable:NO];
    
    txtContent.delegate = self;
    
    [txtContent setScrollEnabled:NO];
    
    [scrollView addSubview:txtContent];
    
    [self addLineView:kScreenSourchHeight-55];
    
    XLoginButton *btnRequest = [XLoginButton buttonWithType:UIButtonTypeCustom];
    
    [btnRequest setTitle:@"申请参加" forState:UIControlStateNormal];
    
    [btnRequest setBackgroundColor:RGB(59, 118, 199)];
    
    [self.view addSubview:btnRequest];
    
    btnRequest.frame = Rect(10, kScreenSourchHeight-50, kScreenSourchWidth-20, 45);
    
    [btnRequest setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [btnRequest setTitleColor:RGB(0, 0, 0) forState:UIControlStateHighlighted];
   
    [btnRequest addTarget:self action:@selector(joinPlayInfo) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
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

-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    [self initView];
    [self setPlayModel];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self setPlayModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
//    for (NSString *url in [_aryDict allKeys])
//    {
//        [[SDImageCache sharedImageCache] removeImageForKey:url];
//    }
}
@end
