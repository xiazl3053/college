//
//  AddTeachingViewController.m
//  college
//
//  Created by xiongchi on 15/9/8.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "AddTeachingViewController.h"
#import "XViewTextField.h"
#import "XContentViewController.h"
#import "UserInfo.h"
#import "XViewTextSelect.h"
#import "Toast+UIView.h"
#import "XLoginButton.h"
#import "BaseService.h"
#import "XTextViewController.h"
#import "TeachModel.h"
@interface AddTeachingViewController ()
{
    XViewTextField *txtTitle;
    UIButton *btnPush;
    XViewTextSelect *txtTime;
    XViewTextField *txtCount;
    XViewTextField *txtPrice;
    XViewTextSelect *txtContent;

    UIView *viewDate;
    UIDatePicker *datePicker;
}
@property (nonatomic,strong) TeachModel *backModel;

@property (nonatomic,copy) NSString *strContent;
@property (nonatomic,strong) NSMutableArray *aryImage;

@end

@implementation AddTeachingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:VIEW_BACK];
    _aryImage = [NSMutableArray array];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initView
{
    [self setTitleText:@"发布授课"];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateHighlighted];
    
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftBtn:btnBack];
    
    txtTitle = [[XViewTextField alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, 40)];
    
    txtCount = [[XViewTextField alloc] initWithFrame:Rect(0, txtTitle.y+txtTitle.height, kScreenSourchWidth, txtTitle.height)];
    
    txtPrice = [[XViewTextField alloc] initWithFrame:Rect(0, txtCount.y+txtCount.height, kScreenSourchWidth, txtTitle.height)];
    
    txtTime = [[XViewTextSelect alloc] initWithFrame:Rect(0, txtPrice.y+txtPrice.height, kScreenSourchWidth, txtTitle.height)];
    
    txtContent = [[XViewTextSelect alloc] initWithFrame:Rect(0, txtTime.y+txtTime.height, kScreenSourchWidth, txtTime.height)];

    [self.view addSubview:txtTitle];
    
    [self.view addSubview:txtCount];
    
    [self.view addSubview:txtPrice];
    
    [self.view addSubview:txtTime];
    
    [self.view addSubview:txtContent];
    
    [txtTitle.lblTitle setText:@"授课主题"];
    
    [txtCount.lblTitle setText:@"最大人数"];
    
    [txtTime.lblTitle setText:@"授课时间"];
    
    [txtContent.lblTitle setText:@"授课说明"];
    
    [txtPrice.lblTitle setText:@"听课价格"];
    
    [txtPrice.txtContent setKeyboardType:UIKeyboardTypeNumberPad];
    [txtCount.txtContent setKeyboardType:UIKeyboardTypeNumberPad];
    
    UIColor *color = [UIColor grayColor];
    txtTitle.txtContent.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入主题" attributes:@{NSForegroundColorAttributeName: color}];
    txtPrice.txtContent.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入价格" attributes:@{NSForegroundColorAttributeName: color}];
    txtCount.txtContent.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入人数(默认不限)" attributes:@{NSForegroundColorAttributeName: color}];
    txtTime.txtContent.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请选择时间" attributes:@{NSForegroundColorAttributeName: color}];
    txtContent.txtContent.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入主题" attributes:@{NSForegroundColorAttributeName: color}];
    
    btnPush = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview:btnPush];
    
    [btnPush setTitle:@"发布" forState:UIControlStateNormal];
    [btnPush setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [btnPush setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateHighlighted];
    [btnPush setBackgroundColor:MAIN_COLOR];
    [btnPush.layer setMasksToBounds:YES];
    [btnPush.layer setCornerRadius:5.0];
    btnPush.frame = Rect(10, txtContent.y+txtContent.height+10, kScreenSourchWidth-20, 45);
    [btnPush addTarget:self action:@selector(pushEvent) forControlEvents:UIControlEventTouchUpInside];
    
    __weak AddTeachingViewController *__self = self;
    __weak XViewTextSelect *__txtContent = txtContent;
    [txtContent addTouchEvent:^{
        XTextViewController *viewCon = [[XTextViewController alloc]  initWithTitle:@"授课说明" content:__self.strContent ary:__self.aryImage];
        viewCon.blockText = ^(NSString *strInfo,NSArray *aryImage)
        {
            __self.strContent = strInfo;
            [__self.aryImage removeAllObjects];
            [__self.aryImage addObjectsFromArray:aryImage];
            dispatch_async(dispatch_get_main_queue(),
            ^{
                 [__txtContent.txtContent setText:[NSString stringWithFormat:@""/*,__self.strContent.length*/]];
            });
        };
        [__self presentViewController:viewCon animated:YES completion:nil];
    }];
    [self initDateView];
    __weak UIView *__view = viewDate;
    [txtTime addTouchEvent:
    ^{
        __view.hidden = NO;
    }];
    
}


-(void)pushEvent
{
    NSString *strTitle = txtTitle.txtContent.text;
    NSString *strCount = txtCount.txtContent.text;
    NSString *strTime = txtTime.txtContent.text;
    NSString *strPrice = txtPrice.txtContent.text;
    NSString *strNumber = nil;
    
    if (strTitle==nil || [strTitle isEqualToString:@""])
    {
        [self.view makeToast:@"授课主题不能为空"];
        return ;
    }
    if (strTime==nil || [strTime isEqualToString:@""]) {
        [self.view makeToast:@"请选择授课时间"];
        return ;
    }
    if (_strContent==nil || [_strContent isEqualToString:@""])
    {
        [self.view makeToast:@"授课说明不能为空"];
        return ;
    }
    if (strPrice == nil || [strPrice isEqualToString:@""]) {
        [self.view makeToast:@"收割价格不能为空"];
        return ;
    }
    
    if (strCount == nil||[strCount isEqualToString:@""])
    {
        strNumber = @"99999999";
    }
    else
    {
        strNumber = strCount;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [fmt setLocale:usLocale];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *strDate = [NSString stringWithFormat:@"%.0f000",[[fmt dateFromString:strTime] timeIntervalSince1970]];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@bbs/add?token=%@",KHttpServer,[UserInfo sharedUserInfo].strToken];
    
    NSDictionary *parameters = @{@"userid":[UserInfo sharedUserInfo].strUserId,
                                @"title":strTitle,@"people":strNumber,@"teachtime":strDate/*,@"price":strPrice*/,@"type":@"2",
                                @"content":_strContent,@"teachtype":@"123456",@"tag":@"我去啊",@"info":strPrice};

    [self.view makeToastActivity];
    
    __weak AddTeachingViewController *__self = self;
    [BaseService postJSONWithUrl:strUrl parameters:parameters success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        
        if ([[dict objectForKey:@"status"] intValue]==200)
        {
            //上传图片
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [__self.view hideToastActivity];
//                [__self.view makeToast:@"添加授课成功"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [__self dismissViewControllerAnimated:YES completion:nil];
//                });
//            });
            if (__self.aryImage.count>0)
            {
                __self.backModel = [[TeachModel alloc] initWithDict:[dict objectForKey:@"bbs"]];
                UIImage *image = [__self.aryImage objectAtIndex:0];
                [__self.aryImage removeObjectAtIndex:0];
                [__self uploadPartyId:image];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(),
                ^{
                    [__self dismissViewControllerAnimated:YES completion:nil];
                });
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
    NSString *strUrl = [NSString stringWithFormat:@"%@pub/uploadMore/bbs/%@?token=%@&type=jpg",KHttpServer,_backModel.strTeachId
                        ,[UserInfo sharedUserInfo].strToken];
    DLog(@"strUrl:%@",strUrl);
    __weak AddTeachingViewController *__self = self;
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

-(void)initDateView
{
    viewDate = [[UIView alloc] initWithFrame:self.view.bounds];
    UIView *headView = [[UIView alloc] initWithFrame:Rect(0, 0,kScreenSourchWidth, kScreenSourchHeight-254)];
    [headView setBackgroundColor:RGB(128, 128, 128)];
    [viewDate addSubview:headView];
    headView.alpha = 0.5f;
    UIView *backView = [[UIView alloc] initWithFrame:Rect(0, kScreenSourchHeight-254 , kScreenSourchWidth, 254)];
    [viewDate addSubview:backView];
    [backView setBackgroundColor:RGB(255, 255, 255)];
    
    UIButton *btnDate = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:btnDate];
    [btnDate setTitle:@"OK" forState:UIControlStateNormal];
    [btnDate setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    btnDate.titleLabel.font = XFONT(15);
    [btnDate addTarget:self action:@selector(setDateInfo) forControlEvents:UIControlEventTouchUpInside];
    btnDate.frame = Rect(kScreenSourchWidth-50,0, 44,37);
    
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(0,37, kScreenSourchWidth, 1)];
    [lblContent setBackgroundColor:[UIColor grayColor]];
    [backView addSubview:lblContent];
    
    datePicker = [[UIDatePicker alloc]initWithFrame:Rect(0, 38, kScreenSourchWidth, 216)];
    
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [NSDate date];
    
    NSDate *dateInfo = [fmt dateFromString:[NSString stringWithFormat:@"%d-%d-%d",date.year+1,date.month+1,date.day+1]];
    [datePicker setMinimumDate:date];
    [datePicker setMaximumDate:dateInfo];
    
    [backView addSubview:datePicker];
    
    [self.view addSubview:viewDate];
    viewDate.hidden = YES;
}

-(void)setDateInfo
{
    NSDate *date = datePicker.date;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *strInfo = [fmt stringFromDate:date];
    
    [txtTime.txtContent setText:strInfo];
    
    viewDate.hidden = YES;
}


@end
