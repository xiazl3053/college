//
//  AddBBSViewController.m
//  college
//
//  Created by xiongchi on 15/9/8.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "AddBBSViewController.h"
#import "XViewTextField.h"
#import "XViewTextSelect.h"
#import "UserInfo.h"
#import "XViewTextSelect.h"
#import "Toast+UIView.h"
#import "XLoginButton.h"
#import "BaseService.h"
#import "BBSModel.h"
//#import "XContentViewController.h"

#import "XTextViewController.h"

@interface AddBBSViewController ()
{
    XViewTextField *txtTitle;
    XViewTextSelect *txtContent;
    UITextView *txtView;
    UIButton *btnPush;
}
@property (nonatomic,strong) BBSModel *backModel;
@property (nonatomic,copy) NSString *strContent;
@property (nonatomic,strong) NSMutableArray *aryImage;

@end


@implementation AddBBSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _aryImage = [NSMutableArray array];
    [self.view setBackgroundColor:VIEW_BACK];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initView
{
    [self setTitleText:@"创建新帖"];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateHighlighted];
    
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftBtn:btnBack];
    
    txtTitle = [[XViewTextField alloc] initWithFrame:Rect(0, 70, kScreenSourchWidth, 45)];
    
    [self.view addSubview:txtTitle];
    
    [txtTitle.lblTitle setText:@"主题"];
    
    UIColor *color = [UIColor grayColor];
    txtTitle.txtContent.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入帖子主题" attributes:@{NSForegroundColorAttributeName: color}];
    
    txtContent = [[XViewTextSelect alloc] initWithFrame:Rect(0, txtTitle.y+txtTitle.height, kScreenSourchWidth, 45)];
    
    [self.view addSubview:txtContent];
    
    [txtContent.lblTitle setText:@"内容"];
    
    txtContent.txtContent.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入帖子内容" attributes:@{NSForegroundColorAttributeName: color}];
    
    btnPush = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview:btnPush];
    
    [btnPush setTitle:@"发布" forState:UIControlStateNormal];
    [btnPush setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [btnPush setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateHighlighted];
    [btnPush setBackgroundColor:MAIN_COLOR];
    [btnPush.layer setMasksToBounds:YES];
    [btnPush.layer setCornerRadius:5.0];
    btnPush.frame = Rect(10, txtContent.y+txtContent.height+10, kScreenSourchWidth-20, 45);
    [btnPush addTarget:self action:@selector(addBBSInfo) forControlEvents:UIControlEventTouchUpInside];
    
    __weak AddBBSViewController *__self = self;
    __weak XViewTextSelect *__txtContent = txtContent;
    [txtContent addTouchEvent:^{
        XTextViewController *viewCon = [[XTextViewController alloc]  initWithTitle:@"帖子内容" content:__self.strContent ary:__self.aryImage];
        viewCon.blockText = ^(NSString *strInfo,NSArray *aryImage)
        {
            __self.strContent = strInfo;
            [__self.aryImage removeAllObjects];
            [__self.aryImage addObjectsFromArray:aryImage];
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__txtContent.txtContent setText:[NSString stringWithFormat:@"已输入%zi个字符",__self.strContent.length]];
            });
          };
          [__self presentViewController:viewCon animated:YES completion:nil];
     }];
}

-(void)addBBSInfo
{
    NSString *strTitle = txtTitle.txtContent.text;
    
    if (strTitle==nil || [strTitle isEqualToString:@""]) {
        [self.view makeToast:@"主题不能为空"];
        return ;
    }
    if (_strContent==nil || [_strContent isEqualToString:@""]) {
        [self.view makeToast:@"主题内容不能为空"];
        return ;
    }
    [self.view makeToastActivity];
    NSString *strUrl = [NSString stringWithFormat:@"%@bbs/add?token=%@",KHttpServer,[UserInfo sharedUserInfo].strToken];
    __weak AddBBSViewController *__self = self;
    NSDictionary *parameters = @{@"type":@"1",@"title":strTitle,@"content":_strContent,@"userid":[UserInfo sharedUserInfo].strUserId};
    [BaseService postJSONWithUrl:strUrl parameters:parameters success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        if ([[dict objectForKey:@"status"] intValue]==200) {
//            dispatch_async(dispatch_get_main_queue(),
//            ^{
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [__self dismissViewControllerAnimated:YES completion:nil];
//                });
//            });
            if (__self.aryImage.count>0)
            {
                __self.backModel = [[BBSModel alloc] initWithDict:[dict objectForKey:@"bbs"]];
                UIImage *image = [__self.aryImage objectAtIndex:0];
                [__self.aryImage removeObjectAtIndex:0];
                [__self uploadPartyId:image];
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
       
    }];
}


-(void)uploadPartyId:(UIImage *)image
{
    NSString *strUrl = [NSString stringWithFormat:@"%@pub/uploadMore/bbs/%@?token=%@&type=jpg",KHttpServer,_backModel.strBBSId
                        ,[UserInfo sharedUserInfo].strToken];
    DLog(@"strUrl:%@",strUrl);
    __weak AddBBSViewController *__self = self;
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

