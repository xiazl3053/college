//
//  BBSViewController.m
//  college
//
//  Created by xiongchi on 15/9/13.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "BBSViewController.h"

//#import ""
#import "BBSModel.h"
#import "Toast+UIView.h"
#import "UIImageView+WebCache.h"
#import "EmojiTextAttachment.h"
#import "SDImageCache.h"
#import "NSAttributedString+EmojiExtension.h"
#import "UserInfo.h"
#import "BaseService.h"

@interface BBSViewController ()<UITextFieldDelegate>
{
    UIImageView *imgHead;
    UILabel *lblNickName;
    UILabel *lblTime;
    UITextView *txtContent;
    UIScrollView *scrollView;
    UITextField *txtBack;
}
@property (nonatomic,strong) BBSModel *model;
@property (nonatomic,strong) NSMutableDictionary *aryDict;

@end

@implementation BBSViewController

-(id)initWithModel:(BBSModel *)model
{
    self = [super init];
    _aryDict = [NSMutableDictionary dictionary];
    _model = model;
    DLog(@"bbsid:%@",_model.strBBSId);
    __weak BBSViewController *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [__self download];
    });
    
    return self;
}

-(void)download
{
    NSArray *ary = [_model.strImg componentsSeparatedByString:@","];
    __weak BBSViewController *__self = self;
    __block NSInteger __nLength =ary.count;
    for (int i=0; i<ary.count;i++)
    {
        NSString *strUrl = [NSString stringWithFormat:@"%@pub/download/bbs/%@?token=%@&pictureid=%@",KHttpServer,_model.strBBSId,[UserInfo sharedUserInfo].strToken,[ary objectAtIndex:i]];
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
                 DLog(@"下载成功imageurl:%@",[imageURL absoluteString]);
                 DLog(@"error:%@",error);
                 if (error==nil)
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
                 }
             ];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitleText:@"论坛"];
    scrollView = [[UIScrollView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth,kScreenSourchHeight-119)];
    
    scrollView.scrollEnabled = YES;
    
    [self.view addSubview:scrollView];
    
    imgHead = [[UIImageView alloc] initWithFrame:Rect(10, 10, 40,40)];
    NSString *strUrl = [NSString stringWithFormat:@"%@pub/downloadUserPicture?userid=%@&token=%@",KHttpServer,_model.strUserId,[UserInfo sharedUserInfo].strToken];
    [imgHead sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"firstFace"]];
    
    [scrollView addSubview:imgHead];
    
    lblNickName = [[UILabel alloc] initWithFrame:Rect(imgHead.x+imgHead.width+10, imgHead.y,200,20)];
    
    [lblNickName setFont:XFONT(15)];
    
    [lblNickName setTextColor:UIColorFromRGB(0x000000)];
    
    [scrollView addSubview:lblNickName];
    
    [lblNickName setText:_model.strNick];
    
    lblTime = [[UILabel alloc] initWithFrame:Rect(lblNickName.x,lblNickName.y+lblNickName.height,lblNickName.width,15)];
    
    [lblTime setFont:XFONT(12)];
    
    [lblTime setTextColor:[UIColor grayColor]];
    
    [lblTime setText:_model.strCreateTime];
    
    [scrollView addSubview:lblTime];
    
    txtContent = [[UITextView alloc] initWithFrame:Rect(0,imgHead.y+imgHead.height+10, kScreenSourchWidth,
                                                        kScreenSourchHeight-(imgHead.y+imgHead.height+50))];
    [txtContent setFont:XFONT(14)];
    
    [scrollView addSubview:txtContent];
    
    [txtContent setEditable:NO];
    
    [txtContent setScrollEnabled:NO];
    
    txtBack = [[UITextField alloc] initWithFrame:Rect(10, kScreenSourchHeight-50,kScreenSourchWidth-20, 45)];
    
    [self.view addSubview:txtBack];
    
    [txtBack setBorderStyle:UITextBorderStyleRoundedRect];
    
    [txtBack.layer setBorderColor:LINE_COLOR.CGColor];
    
    [txtBack setTextColor:UIColorFromRGB(0x333333)];
    
    txtBack.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"回复"
                                                                      attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];;
    txtBack.delegate = self;
    
    [self initData];
}

-(void)initData
{
    NSString *strInfo = [NSString stringWithFormat:@"%@pub/bbs/ReplyList?token=%@&pk=%@&pageNo=1&pageSize=15",KHttpServer,[UserInfo sharedUserInfo].strToken,_model.strBBSId];
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        if ([[dict objectForKey:@"status"] intValue]==200) {
            
        }
    } fail:^(NSError *error) {
        
    }];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setImageView];
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
        NSString *strUrl = [NSString stringWithFormat:@"%@pub/download/bbs/%@?token=%@&pictureid=%@",KHttpServer,_model.strBBSId,[UserInfo sharedUserInfo].strToken,[array objectAtIndex:nNumber]];
        
        emojiTextAttachment.image = [_aryDict objectForKey:strUrl];
        
        CGSize imageSize = [emojiTextAttachment.image size];
        emojiTextAttachment.emojiSize = imageSize.width>=txtContent.width? txtContent.width :imageSize.width;
        
        CGFloat imgHeight = imageSize.height*(CGFloat)
        (emojiTextAttachment.emojiSize /((imageSize.width==0) ? kScreenSourchWidth:imageSize.width));
        
//        DLog(@"imgHeight:%F",imgHeight);
        
        fHeight+=imgHeight;
        
        [txtContent.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]
                                               atIndex:[number intValue]];
        nNumber++;
    }
//    DLog(@"fHeight:%f",fHeight);

    txtContent.frame = Rect(0, txtContent.y, kScreenSourchWidth, fHeight);
    [scrollView setContentSize:CGSizeMake(kScreenSourchWidth, txtContent.y+txtContent.height)];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (txtBack.text.length==0)
    {
        return YES;
    }
//    [txtBack resignFirstResponder];
    NSString *strUrl = [NSString stringWithFormat:@"%@pub/addReply/bbs?token=%@",KHttpServer,[UserInfo sharedUserInfo].strToken];
    //{"pk" : 4 , "publishuserid" :5 , "replyuserid" :1 , "message" : "用户1回复用户5，帖子是4"}
    NSDictionary *parameters = @{@"pk":_model.strBBSId,@"replyuserid":[UserInfo sharedUserInfo].strUserId,
                                 @"publishuserid":_model.strUserId,@"message":txtBack.text};
    DLog(@"parameters:%@",parameters);
    __weak BBSViewController *__self = self;
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
//                [txtBack resignFirstResponder];
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
