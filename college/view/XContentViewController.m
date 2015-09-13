//
//  XContentViewController.m
//  college
//
//  Created by xiongchi on 15/9/11.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "XContentViewController.h"

@interface XContentViewController ()<UITextViewDelegate>
{
    NSString *_strTitle;
    UITextView *txtView;
    NSString *_strContent;
}

@end

@implementation XContentViewController
-(id)initWithTitle:(NSString *)strTitle content:(NSString *)strContent
{
    self = [super init];
    _strTitle = strTitle;
    _strContent = strContent;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:_strTitle];
    [self.view setBackgroundColor:VIEW_BACK];
    txtView = [[UITextView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, kScreenSourchHeight-129)];
    [self.view addSubview:txtView];
    [txtView setDelegate:self];
    [txtView setFont:XFONT(12)];
    UIButton *btnPush = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnPush];
    [btnPush setTitle:@"发布" forState:UIControlStateNormal];
    [btnPush setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [btnPush setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateHighlighted];
    [btnPush setBackgroundColor:MAIN_COLOR];
    [btnPush.layer setMasksToBounds:YES];
    [btnPush.layer setCornerRadius:5.0];
    btnPush.frame = Rect(10, txtView.y+txtView.height+10, kScreenSourchWidth-20, 45);
    [btnPush addTarget:self action:@selector(setEvent) forControlEvents:UIControlEventTouchUpInside];
    [txtView setText:_strContent];
}

-(void)setContent:(NSString *)strInfo
{
    txtView.text = strInfo;
}

-(void)setEvent
{
    if (_stringBlock)
    {
        _stringBlock(txtView.text);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [txtView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end
