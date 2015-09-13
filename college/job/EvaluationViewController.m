//
//  EvaluationViewController.m
//  college
//
//  Created by xiongchi on 15/9/6.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "EvaluationViewController.h"
#import "ResumeModel.h"
#import "Toast+UIView.h"
#import "UserInfo.h"
#import "BaseService.h"
#import "XView.h"
@interface EvaluationViewController ()
{
    
}
@property (nonatomic,strong) ResumeModel *model;
@property (nonatomic,strong) UITextView *textView;
@end


@implementation EvaluationViewController

-(void)dealloc
{
    _model = nil;
}

-(id)initWithModel:(ResumeModel *)resume
{
    self = [super init];
    
    _model = resume;
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:MAIN_COLOR];
    
    
    [self setTitleText:@"自我评价"];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateHighlighted];
    
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftBtn:btnBack];
    
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnSave setTitle:@"保存" forState:UIControlStateNormal];
    
    [btnSave setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    
    [btnSave setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
    
    btnSave.titleLabel.font = XFONT(12);
    
    [btnSave addTarget:self action:@selector(saveResume) forControlEvents:UIControlEventTouchUpInside];
    
    [self setRightBtn:btnSave];
    
    XView *backView = [[XView alloc] initWithFrame:Rect(10, 80, kScreenAppWidth-20, kScreenSourchHeight-140)];
    
    [self.view addSubview:backView];
    
    [backView setBackgroundColor:FRAME_COLOR];
    
    _textView = [[UITextView alloc] initWithFrame:Rect(15, 15, backView.width-30, backView.height-30)];
    
    [backView addSubview:_textView];
    
    [_textView setTextColor:UIColorFromRGB(0x222222)];
    
    [_textView setText:_model.strEvaluation];
}

-(void)saveResume
{
    if ([_textView isFirstResponder])
    {
        [_textView resignFirstResponder];
    }
    NSString *strEvalu = [_textView text];
    if ([strEvalu isEqualToString:@""])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        return ;
    }
    _model.strEvaluation = strEvalu;
    NSDictionary *parameters = @{@"userid":[UserInfo sharedUserInfo].strUserId,
                                 @"jianliid":_model.strJLId,
                                 @"evaluation":_model.strEvaluation};
    NSString *strInfo = [NSString stringWithFormat:@"%@pub/updateJianLi?token=%@&",KHttpServer,[UserInfo sharedUserInfo].strToken];
    
    __weak EvaluationViewController *__self = self;
    [BaseService postJSONWithUrl:strInfo parameters:parameters success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        if ([[dict objectForKey:@"status"] intValue]==200) {
            dispatch_async(dispatch_get_main_queue()
                           , ^{
                               [__self.view makeToast:@"保存成功"];
                           });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [__self dismissViewControllerAnimated:YES completion:nil];
            });
        }
    } fail:^(NSError *error) {
        
    }];
    
}

-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
