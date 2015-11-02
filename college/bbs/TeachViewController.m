//
//  TeachViewController.m
//  college
//
//  Created by xiongchi on 15/9/15.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "TeachViewController.h"
#import "XView.h"
#import "TeachModel.h"
#import "Toast+UIView.h"
#import "UIImageView+WebCache.h"
#import "EmojiTextAttachment.h"
#import "SDImageCache.h"
#import "NSAttributedString+EmojiExtension.h"
#import "UserInfo.h"
#import "BaseService.h"

@interface TeachViewController ()<UITextFieldDelegate>
{
    UIImageView *imgHead;
    UILabel *lblNickName;
    UILabel *lblTime;
    UITextView *txtContent;
    UIScrollView *scrollView;
    UITextField *txtBack;
}

@property (nonatomic,strong) TeachModel *model;
@property (nonatomic,strong) NSMutableDictionary *aryDict;

@end

@implementation TeachViewController

-(id)initWithModel:(TeachModel *)model
{
    self = [super init];
    _aryDict = [NSMutableDictionary dictionary];
    _model = model;
    DLog(@"bbsid:%@",_model.strTeachId);
    __weak TeachViewController *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [__self download];
    });
    
    return self;
}


-(void)download
{
    NSArray *ary = [_model.strImg componentsSeparatedByString:@","];
    __weak TeachViewController *__self = self;
    __block NSInteger __nLength =ary.count;
    for (int i=0; i<ary.count;i++)
    {
        NSString *strUrl = [NSString stringWithFormat:@"%@pub/download/bbs/%@?token=%@&pictureid=%@",KHttpServer,_model.strTeachId,[UserInfo sharedUserInfo].strToken,[ary objectAtIndex:i]];
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
                 if (image) {
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
    [self setTitleText:@"授课"];
    scrollView = [[UIScrollView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth,kScreenSourchHeight-119)];
    
    scrollView.scrollEnabled = YES;
    
    [self.view addSubview:scrollView];
    
    imgHead = [[UIImageView alloc] initWithFrame:Rect(10, 10, 40,40)];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@pub/downloadUserPicture?userid=%@&token=%@",KHttpServer,_model.strUserId,[UserInfo sharedUserInfo].strToken];
    
    [imgHead sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"firstFace"]];
    
    [scrollView addSubview:imgHead];
    
    lblNickName = [[UILabel alloc] initWithFrame:Rect(imgHead.x+imgHead.width+10, imgHead.y,200,20)];
    
    [lblNickName setFont:XFONT(15)];
    
    [lblNickName setText:_model.strNick ? _model.strNick :@"测试"];
    
    [lblNickName setTextColor:UIColorFromRGB(0xFFFFFF)];
    
    [scrollView addSubview:lblNickName];
    
    [lblNickName setText:_model.strNick];
    
    lblTime = [[UILabel alloc] initWithFrame:Rect(lblNickName.x,lblNickName.y+lblNickName.height,lblNickName.width,15)];
    
    [lblTime setFont:XFONT(12)];
    
    [lblTime setTextColor:[UIColor grayColor]];
    
    [lblTime setText:_model.strCreateTime];
    
    [scrollView addSubview:lblTime];
    
    UIView *teachInfoView = [[UIView alloc] initWithFrame:Rect(0, imgHead.y+imgHead.height+19, kScreenSourchWidth,90)];
    
    [teachInfoView setBackgroundColor:VIEW_BACK];
    [scrollView addSubview:teachInfoView];
    
    UILabel *lblTeachTime = [[UILabel alloc] initWithFrame:Rect(10, 5, teachInfoView.width-20, 20)];
    [lblTeachTime setText:_model.strTeachTime];
    [lblTeachTime setFont:XFONT(13)];
    [lblTeachTime setTextColor:UIColorFromRGB(0x333333)];
    [teachInfoView addSubview:lblTeachTime];
    
    [self addLineView:teachInfoView heaght:29.2];
    
    UILabel *lblJoin = [[UILabel alloc] initWithFrame:Rect(10, 35, teachInfoView.width-20, 20)];
    [lblJoin setText:[NSString stringWithFormat:@"报名人数:%@  可参与人数:%@",_model.strRePly?_model.strRePly:@"0",_model.strJoinNum]];
    [lblJoin setFont:XFONT(13)];
    [lblJoin setTextColor:UIColorFromRGB(0x333333)];
    [teachInfoView addSubview:lblJoin];
    [self addLineView:teachInfoView heaght:59.2];
    
    UILabel *lblPrice = [[UILabel alloc] initWithFrame:Rect(10, 65, teachInfoView.width-20, 20)];
    [lblPrice setText:[NSString stringWithFormat:@"参加价格:%@",_model.strCost]];
    [lblPrice setFont:XFONT(13)];
    [lblPrice setTextColor:UIColorFromRGB(0x333333)];
    [teachInfoView addSubview:lblPrice];
    [self addLineView:teachInfoView heaght:89.2];
    
    
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(10,teachInfoView.y+teachInfoView.height+10,kScreenSourchWidth-20,20)];
    [lblContent setFont:XFONT(14)];
    [lblContent setText:@"授课说明"];
    [lblContent setTextColor:UIColorFromRGB(0x333333)];
    [scrollView addSubview:lblContent];
    
    txtContent = [[UITextView alloc] initWithFrame:Rect(0,lblContent.y+lblContent.height+10, kScreenSourchWidth,
                                                        kScreenSourchHeight-(lblContent.y+lblContent.height+10+50))];
    [txtContent setFont:XFONT(14)];
    
    [scrollView addSubview:txtContent];
    
    [txtContent setEditable:NO];
    
    [txtContent setScrollEnabled:NO];
    
    
    UIButton *btnPush = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnPush];
    [btnPush setTitle:@"立即报名" forState:UIControlStateNormal];
    [btnPush setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [btnPush setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateHighlighted];
    [btnPush setBackgroundColor:MAIN_COLOR];
    [btnPush.layer setMasksToBounds:YES];
    [btnPush.layer setCornerRadius:5.0];
    btnPush.frame = Rect(10, kScreenSourchHeight-50, kScreenSourchWidth-20, 45);
    [btnPush addTarget:self action:@selector(pushEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPush];
    
    NSDate *nowDate = [NSDate date];
    NSTimeInterval now = [nowDate timeIntervalSince1970];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSTimeInterval classTime = [[fmt dateFromString:_model.strTeachTime] timeIntervalSince1970];
    if (now>classTime)
    {
        btnPush.enabled = NO;
    }

    NSArray *ary = [_model.strImg componentsSeparatedByString:@","];
    
    if ([_aryDict allKeys].count==ary.count)
    {
        [self setImageView];
    }
}

-(void)pushEvent
{
    NSString *strInfo = [NSString stringWithFormat:@"%@bbs/applyClass?token=%@&bbsid=%@&publishuserid=%@&shengqinguserid=%@",KHttpServer,[UserInfo sharedUserInfo].strToken,_model.strTeachId,_model.strUserId,[UserInfo sharedUserInfo].strUserId];
    __weak TeachViewController *__self = self;
    NSDate *nowDate = [NSDate date];
    NSTimeInterval now = [nowDate timeIntervalSince1970];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSTimeInterval classTime = [[fmt dateFromString:_model.strTeachTime] timeIntervalSince1970];
    if (now>classTime)
    {
        [self.view makeToast:@"已经过了报名期限"];
        return ;
    }
    
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[dict objectForKey:@"status"] intValue]==200)
        {
            DLog(@"报名成功");
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__self.view hideToastActivity];
                [__self.view makeToast:@"报名成功"];
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
    } fail:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.view hideToastActivity];
            [__self.view makeToast:@"回复失败"];
        });
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    txtContent.text = _strContent;
    NSArray *array = [_model.strImg componentsSeparatedByString:@","];
    CGFloat fHeight = 0;
    int nNumber = 0;
    for (NSNumber *number in aryIndex)
    {
        EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
        //Set tag and image
        emojiTextAttachment.emojiTag = @"<img>{width:100,height:100}</img>";
        NSString *strUrl = [NSString stringWithFormat:@"%@pub/download/bbs/%@?token=%@&pictureid=%@",KHttpServer,_model.strTeachId,[UserInfo sharedUserInfo].strToken,[array objectAtIndex:nNumber]];
        
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (txtBack.text.length==0)
    {
        return YES;
    }
    NSString *strUrl = [NSString stringWithFormat:@"%@pub/addReply/bbs?token=%@",KHttpServer,[UserInfo sharedUserInfo].strToken];
    NSDictionary *parameters = @{@"pk":_model.strTeachId,@"replyuserid":[UserInfo sharedUserInfo].strUserId,
                                 @"publishuserid":_model.strUserId,@"message":txtBack.text};
    DLog(@"parameters:%@",parameters);
    __weak TeachViewController *__self = self;
    __weak UITextField *__txtBack = txtBack;
    [BaseService postJSONWithUrl:strUrl parameters:parameters success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        if ([[dict objectForKey:@"status"] intValue]==200) {
            DLog(@"回复成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self.view makeToast:@"回复成功"];
                __txtBack.text = @"";
                [txtBack resignFirstResponder];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self.view makeToast:[dict objectForKey:@"msg"]];
                __txtBack.text = @"";
            });
        }
    } fail:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.view makeToast:@"回复失败"];
        });
    }];
    return YES;
}

@end
