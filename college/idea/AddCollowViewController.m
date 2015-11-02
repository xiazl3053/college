//
//  AddCollowViewController.m
//  college
//
//  Created by xiongchi on 15/9/10.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "AddCollowViewController.h"
#import "XViewTextField.h"
#import "Toast+UIView.h"
#import "XViewTextSelect.h"
#import "UserInfo.h"
#import "XContentViewController.h"
#import "BaseService.h"


@interface AddCollowViewController()
{
    XViewTextField *txtTitle;
    XViewTextField *txtPrice;
    XViewTextSelect *txtIntro;
    XViewTextSelect *txtContent;
}

@property (nonatomic,copy) NSString *strContent;

@end

@implementation AddCollowViewController

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

-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initView
{
    [self setTitleText:@"征集创意"];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateHighlighted];
    
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftBtn:btnBack];
    
    txtTitle = [[XViewTextField alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, 45)];
    
//    txtPrice = [[XViewTextField alloc] initWithFrame:Rect(0, txtTitle.y+txtTitle.height, kScreenSourchWidth, txtTitle.height)];
    
//    txtIntro = [[XViewTextSelect alloc] initWithFrame:Rect(0, txtTitle.y+txtTitle.height, kScreenSourchWidth, txtTitle.height)];
    
    txtContent = [[XViewTextSelect alloc] initWithFrame:Rect(0, txtTitle.y+txtTitle.height, kScreenSourchWidth, txtTitle.height)];
    
    [self.view addSubview:txtTitle];
    
//    [self.view addSubview:txtIntro];
    
//    [self.view addSubview:txtPrice];
    
    [self.view addSubview:txtContent];
    
    UIColor *color = UIColorFromRGB(0xCCCCCC);
    [txtTitle.lblTitle setText:@"标题"];
    txtTitle.txtContent.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入标题"
                                                                                attributes:@{NSForegroundColorAttributeName:color}];
    [txtContent.lblTitle setText:@"需求"];
    txtContent.txtContent.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入需求" attributes:@{NSForegroundColorAttributeName:color}];
    
    
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
    
    __weak AddCollowViewController *__self = self;
    __weak XViewTextSelect *__txt = txtContent;
    [txtContent addTouchEvent:
     ^{
         XContentViewController *content = [[XContentViewController alloc] initWithTitle:@"需求编辑" content:__self.strContent];
         content.stringBlock= ^(NSString *strInfo)
         {
             DLog(@"strInfo:%@",strInfo);
             __self.strContent = strInfo;
             dispatch_async(dispatch_get_main_queue(),
                            ^{
                                [__txt.txtContent setText:[NSString stringWithFormat:@"已输入%zi个字符",__self.strContent.length]];
                            });
         };
         [content setContent:__self.strContent];
         [__self presentViewController:content animated:YES completion:nil];
     }];
}

-(void)setEvent
{
    NSString *strTitle = txtTitle.txtContent.text;
    if ([strTitle isEqualToString:@""]) {
        [self.view makeToast:@"标题不能为空"];
        return ;
    }
    if (_strContent==nil || [_strContent isEqualToString:@""]) {
        [self.view makeToast:@"请输入需求"];
        return;
    }
    NSDictionary *parameters = @{@"userid":[UserInfo sharedUserInfo].strUserId,@"title":strTitle,@"content":_strContent};
    __weak AddCollowViewController *__self = self;
    NSString *strUrl = [NSString stringWithFormat:@"%@zhengji/add?token=%@",KHttpServer,[UserInfo sharedUserInfo].strToken];
    [BaseService postJSONWithUrl:strUrl parameters:parameters success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([[dict objectForKey:@"status"] intValue]==200) {
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__self.view makeToast:@"添加成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [__self dismissViewControllerAnimated:YES completion:nil];
                });
            });
        }
    } fail:^(NSError *error) {
        
    }];
}



@end
