//
//  AddIdeaViewController.m
//  college
//
//  Created by xiongchi on 15/9/10.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "AddIdeaViewController.h"
#import "XViewTextField.h"
#import "XViewTextSelect.h"
#import "UserInfo.h"
#import "XContentViewController.h"
#import "BaseService.h"
#import "XContentViewController.h"

@interface AddIdeaViewController ()
{
    XViewTextField *txtTitle;
    XViewTextField *txtPrice;
    XViewTextSelect *txtIntro;
    XViewTextSelect *txtContent;
}

@property (nonatomic,copy) NSString *strIntro;
@property (nonatomic,copy) NSString *strContent;

@end

@implementation AddIdeaViewController

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
        XContentViewController *content = [[XContentViewController alloc] initWithTitle:@"内容编辑" content:__self.strContent];
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
    
}

@end
