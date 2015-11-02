//
//  AddIdeaViewController.m
//  college
//
//  Created by xiongchi on 15/9/10.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "AddIdeaViewController.h"
#import "XViewTextField.h"
#import "Toast+UIView.h"
#import "XViewTextSelect.h"
#import "UserInfo.h"
#import "XContentViewController.h"
#import "BaseService.h"
#import "XContentViewController.h"
#import "XTextViewController.h"
#import "IdeaModel.h"

@interface AddIdeaViewController ()
{
    XViewTextField *txtTitle;
    XViewTextField *txtPrice;
    XViewTextSelect *txtIntro;
    XViewTextSelect *txtContent;
}

@property (nonatomic,strong) IdeaModel *backModel;
@property (nonatomic,copy) NSString *strIntro;
@property (nonatomic,copy) NSString *strContent;
@property (nonatomic,strong) NSMutableArray *aryImage;
@property (nonatomic,assign) NSInteger nId;

@end

@implementation AddIdeaViewController

-(id)initWithZhengjiId:(NSInteger)zId
{
    self = [super init];
    
    _nId = zId;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _aryImage = [NSMutableArray array];
    [self.view setBackgroundColor:VIEW_BACK];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initView
{
    [self setTitleText:@"发布创意"];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateHighlighted];
    
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftBtn:btnBack];
    
    txtTitle = [[XViewTextField alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, 45)];
    
    txtPrice = [[XViewTextField alloc] initWithFrame:Rect(0, txtTitle.y+txtTitle.height, kScreenSourchWidth, txtTitle.height)];
    
    txtIntro = [[XViewTextSelect alloc] initWithFrame:Rect(0, txtPrice.y+txtPrice.height, kScreenSourchWidth, txtTitle.height)];
    
    txtContent = [[XViewTextSelect alloc] initWithFrame:Rect(0, txtIntro.y+txtIntro.height, kScreenSourchWidth, txtTitle.height)];
    
    [self.view addSubview:txtTitle];
    
    [self.view addSubview:txtIntro];
    
    [self.view addSubview:txtPrice];
    
    [self.view addSubview:txtContent];
    
    UIColor *color = UIColorFromRGB(0xCCCCCC);
    [txtTitle.lblTitle setText:@"标题"];
    txtTitle.txtContent.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入标题"
                                                                                attributes:@{NSForegroundColorAttributeName:color}];
    [txtPrice.lblTitle setText:@"价格"];
    txtPrice.txtContent.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入价格"
                                                                                attributes:@{NSForegroundColorAttributeName:color}];
    [txtPrice.txtContent setKeyboardType:UIKeyboardTypeNumberPad];
    [txtIntro.lblTitle setText:@"引言"];
    txtIntro.txtContent.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入引言"
                                                                                attributes:@{NSForegroundColorAttributeName:color}];
    
    [txtContent.lblTitle setText:@"正文"];
    txtContent.txtContent.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入正文(对外加密)" attributes:@{NSForegroundColorAttributeName:color}];
    
    UIButton *btnPush = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnPush];
    [btnPush setTitle:@"发布" forState:UIControlStateNormal];
    [btnPush setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [btnPush setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateHighlighted];
    [btnPush setBackgroundColor:MAIN_COLOR];
    [btnPush.layer setMasksToBounds:YES];
    [btnPush.layer setCornerRadius:5.0];
    btnPush.frame = Rect(10, txtContent.y+txtContent.height+10, kScreenSourchWidth-20, 45);
    [btnPush addTarget:self action:@selector(setEvent) forControlEvents:UIControlEventTouchUpInside];
    
    __weak AddIdeaViewController *__self = self;
    __weak XViewTextSelect *__txt = txtContent;
    [txtContent addTouchEvent:
    ^{
        XTextViewController *content = [[XTextViewController alloc] initWithTitle:@"内容编辑" content:__self.strContent ary:__self.aryImage];
        content.blockText= ^(NSString *strInfo,NSArray *aryImage)
        {
            DLog(@"strInfo:%@",strInfo);
            __self.strContent = strInfo;
            [__self.aryImage addObjectsFromArray:aryImage];
            if(strInfo.length>=1)
            {
                dispatch_async(dispatch_get_main_queue(),
                ^{
                    [__txt.txtContent setText:[NSString stringWithFormat:@"已有内容"]];
                });
            }
        };
        [content setContent:__self.strContent];
        [__self presentViewController:content animated:YES completion:nil];
    }];
    __weak XViewTextSelect *__txtIntro = txtIntro;
    [txtIntro addTouchEvent:^{
        XContentViewController *content = [[XContentViewController alloc] initWithTitle:@"引言编辑" content:__self.strIntro];
        content.stringBlock= ^(NSString *strInfo)
        {
            DLog(@"strInfo:%@",strInfo);
            __self.strIntro = strInfo;
            dispatch_async(dispatch_get_main_queue(),
               ^{
                   [__txtIntro.txtContent setText:[NSString stringWithFormat:@"已输入%zi个字符",__self.strIntro.length]];
               });
        };
        [content setContent:__self.strIntro];
        [__self presentViewController:content animated:YES completion:nil];
    }];
}

-(void)setEvent
{
    NSString *strTitle = txtTitle.txtContent.text;
    NSString *strPrice = txtPrice.txtContent.text;
    
    
    if (strTitle==nil || [strTitle isEqualToString:@""])
    {
        [self.view makeToast:@"创意主题不能为空"];
        return ;
    }
    if (strPrice == nil || [strPrice isEqualToString:@""])
    {
        [self.view makeToast:@"价格不能为空"];
        return;
    }
    if (_strContent==nil || [_strContent isEqualToString:@""])
    {
        [self.view makeToast:@"授课内容不能为空"];
        return ;
    }
    if (_strIntro == nil||[_strIntro isEqualToString:@""])
    {
        [self.view makeToast:@"引言不能为空"];
        return ;
    }
  
    
    NSString *strUrl = [NSString stringWithFormat:@"%@idea/add?token=%@",KHttpServer,[UserInfo sharedUserInfo].strToken];
    NSDictionary *parameters = nil;
    if (_nId)
    {
        parameters = @{@"userid":[UserInfo sharedUserInfo].strUserId,
                       @"title":strTitle,@"price":strPrice,
                       @"content":_strContent,@"jieshao":_strIntro,@"zhengjiid":[NSNumber numberWithInteger:_nId]};
    }
    else
    {
        parameters = @{@"userid":[UserInfo sharedUserInfo].strUserId,
                                 @"title":strTitle,@"price":strPrice,
                                 @"content":_strContent,@"jieshao":_strIntro};
    }
    [self.view makeToastActivity];
    __weak AddIdeaViewController *__self = self;
    [BaseService postJSONWithUrl:strUrl parameters:parameters success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        
        if ([[dict objectForKey:@"status"] intValue]==200)
        {
            //上传图片
            if (__self.aryImage.count>0)
            {
                __self.backModel = [[IdeaModel alloc] initWithDict:[dict objectForKey:@"idea"]];
                UIImage *image = [__self.aryImage objectAtIndex:0];
                [__self.aryImage removeObjectAtIndex:0];
                [__self uploadPartyId:image];
            }
            else
            {
                
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self.view hideToastActivity];
                [__self.view makeToast:@"添加失败"];
            });
        }
    } fail:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.view hideToastActivity];
            [__self.view makeToast:@"添加失败"];
        });
    }];
}


-(void)uploadPartyId:(UIImage *)image
{
    NSString *strUrl = [NSString stringWithFormat:@"%@pub/uploadMore/idea/%@?token=%@&type=jpg",KHttpServer,_backModel.strIdeaId
                        ,[UserInfo sharedUserInfo].strToken];
    __weak AddIdeaViewController *__self = self;
    [BaseService postUploadWithUrl:strUrl image:image success:^(id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         DLog(@"dict:%@",dict);
         NSString *strInfo = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         DLog(@"strInfo:%@",strInfo);
         if([[dict objectForKey:@"status"] intValue]!=200)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [__self.view hideToastActivity];
                 [__self.view makeToast:[dict objectForKey:@"msg"]];
             });
         }
         else
         {
             if (__self.aryImage.count>0)
             {
                 UIImage *image = [__self.aryImage objectAtIndex:0];
                 [__self.aryImage removeObjectAtIndex:0];
                 [__self uploadPartyId:image];
             }
             else
             {
                 [__self.view hideToastActivity];
                 [__self.view makeToast:@"创建成功"];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [__self navBack];
                 });
             }
         }
     } fail:
     ^{
         dispatch_async(dispatch_get_main_queue(), ^{
             [__self.view hideToastActivity];
             [__self.view makeToast:@"图片上传失败"];
         });
     }];
}

@end
