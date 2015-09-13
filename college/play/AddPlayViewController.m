//
//  AddPlayViewController.m
//  college
//
//  Created by xiongchi on 15/9/7.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "AddPlayViewController.h"
#import "XViewTextField.h"
#import "PlayModel.h"
#import "UserInfo.h"
#import "XViewTextSelect.h"
#import "Toast+UIView.h"
#import "XLoginButton.h"
#import "XContentViewController.h"
#import "XImageView.h"
#import "BaseService.h"
#import "XTextViewController.h"
#import "RSKImageCropper.h"

@interface AddPlayViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    XViewTextField *txtTitle;
    XViewTextSelect *txtTime;
    XViewTextField *txtAddress;
    XViewTextField *txtNumber;
    XViewTextField *txtPrice;
    XViewTextSelect *txtContent;
    XImageView *_imgView;
    UITextView *txtView;
    UIButton *btnPush;
    UIView *viewDate;
    UIDatePicker *datePicker;
    
}
@property (nonatomic,strong) PlayModel *model;
@property (nonatomic,strong) PlayModel *backModel;
@property (nonatomic,strong) NSMutableArray *aryImage;
@property (nonatomic,copy) NSString *strContent;

@property (nonatomic,strong) UIView * hiddenView;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) UIImagePickerController *camrePicker;


@end

@implementation AddPlayViewController


-(id)initWithModel:(PlayModel *)model
{
    self = [super init];
    
    _model = model;
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _aryImage = [NSMutableArray array];
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    [self initView];
}

-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initView
{
    [self setTitleText:_model ? @"修改活动":@"发布新活动"];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateHighlighted];
    
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftBtn:btnBack];
    
    _imgView = [[XImageView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, 64)];
    
    txtTitle = [[XViewTextField alloc] initWithFrame:Rect(0, _imgView.y+_imgView.height, kScreenSourchWidth, 40)];
    
    txtAddress = [[XViewTextField alloc] initWithFrame:Rect(0,txtTitle.y+txtTitle.height+1, kScreenSourchWidth, txtTitle.height)];
    
    txtNumber = [[XViewTextField alloc] initWithFrame:Rect(0, txtAddress.y+txtAddress.height+1, kScreenSourchWidth,txtTitle.height)];
    
    txtPrice = [[XViewTextField alloc] initWithFrame:Rect(0, txtNumber.y+txtNumber.height+1, kScreenSourchWidth, txtTitle.height)];
    
    txtTime = [[XViewTextSelect alloc] initWithFrame:Rect(0, txtPrice.y+txtPrice.height+1, kScreenSourchWidth, txtTitle.height)];
    
    txtContent = [[XViewTextSelect alloc] initWithFrame:Rect(0, txtTime.y+txtTime.height+1, kScreenSourchWidth, txtTitle.height)];
    
    [self.view addSubview:_imgView];
    
    [self.view addSubview:txtContent];
    
    [self.view addSubview:txtTitle];
    
    [self.view addSubview:txtAddress];
    
    [self.view addSubview:txtPrice];
    
    [self.view addSubview:txtNumber];
    
    [self.view addSubview:txtTime];
    
    [txtTitle.lblTitle setText:@"活动主题"];
    [txtAddress.lblTitle setText:@"地点"];
    [txtNumber.lblTitle setText:@"参与人数"];
    [txtTime.lblTitle setText:@"活动时间"];
    [txtPrice.lblTitle setText:@"活动花费"];
    [txtContent.lblTitle setText:@"活动内容"];
    [_imgView.lblTitle setText:@"活动图片"];
    
    UIColor *color = [UIColor grayColor];
    txtTitle.txtContent.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入活动标题" attributes:@{NSForegroundColorAttributeName: color}];
    txtAddress.txtContent.attributedPlaceholder= [[NSAttributedString alloc] initWithString:@"请输入活动地点" attributes:@{NSForegroundColorAttributeName: color}];
    txtNumber.txtContent.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"请输入参与人数" attributes:@{NSForegroundColorAttributeName: color}];
    txtTime.txtContent.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"请选择活动时间" attributes:@{NSForegroundColorAttributeName: color}];
    txtPrice.txtContent.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"请输入活动花费" attributes:@{NSForegroundColorAttributeName: color}];
    txtContent.txtContent.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入活动内容" attributes:@{NSForegroundColorAttributeName: color}];
    
    [txtNumber.txtContent setText:@"不 限"];
    
    [txtPrice.txtContent setText:@"免 费"];
    
    btnPush = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnPush setTitle:@"发布" forState:UIControlStateNormal];
    [btnPush setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [btnPush setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateHighlighted];
    [btnPush.layer setMasksToBounds:YES];
    [btnPush.layer setCornerRadius:5.0];
    
    [btnPush addTarget:self action:@selector(pushEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnPush];
    
    [btnPush setBackgroundColor:MAIN_COLOR];
    
    btnPush.frame = Rect(10, txtContent.y+txtContent.height+10, kScreenSourchWidth-20, 45);
    
    [self initHiddenView];
    [self initDateView];
    
    __weak AddPlayViewController *__self = self;
    __weak UIView *__view = viewDate;
    [txtTime addTouchEvent:
    ^{
        __view.hidden = NO;
    }];
    __weak XViewTextSelect *__txtContent = txtContent;
    [txtContent addTouchEvent:^{
        XTextViewController *viewControl = [[XTextViewController alloc] initWithTitle:@"内容编辑" content:__self.strContent ary:__self.aryImage];
        viewControl.blockText = ^(NSString *strInfo,NSArray *array)
        {
            __self.strContent = strInfo;
            if (array != nil && array.count>0)
            {
                [__self.aryImage removeAllObjects];
                [__self.aryImage addObjectsFromArray:array];
            }
            DLog(@"__self.aryImage:%zi",__self.aryImage.count);
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__txtContent.txtContent setText:[NSString stringWithFormat:@"已输入%zi个字符",__self.strContent.length]];
            });
        };
        [__self presentViewController:viewControl animated:YES completion:nil];
    }];
    
    [_imgView addTouchEvent:
    ^{
        __self.hiddenView.hidden = NO;
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

-(void)pushEvent
{
    NSString *strTitle = txtTitle.txtContent.text;
    NSString *strNumber = txtNumber.txtContent.text;
    NSString *strTime = txtTime.txtContent.text;
    NSString *strAddress = txtAddress.txtContent.text;
//    strContent = txtView.text;
    NSString *strCost = txtPrice.txtContent.text;
    
    if (strTitle==nil || [strTitle isEqualToString:@""])
    {
        [self.view makeToast:@"活动标题不能为空"];
        return ;
    }
    if (strAddress==nil || [strAddress isEqualToString:@""])
    {
        [self.view makeToast:@"活动地点不能为空"];
        return ;
    }
    if (strNumber==nil || [strNumber isEqualToString:@""])
    {
        [self.view makeToast:@"活动人数不能为空"];
        return ;
    }
    if (strCost == nil || [strCost isEqualToString:@""])
    {
        [self.view makeToast:@"活动花费不能为空"];
        return ;
    }
    if (strTime==nil || [strTime isEqualToString:@""])
    {
        [self.view makeToast:@"活动时间不能为空"];
        return ;
    }
    if (_strContent==nil || [_strContent isEqualToString:@""])
    {
        [self.view makeToast:@"活动内容不能为空"];
        return ;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [fmt setLocale:usLocale];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *dateTime = [fmt dateFromString:strTime];
    
    NSString *strDate = [NSString stringWithFormat:@"%.0f000",[dateTime timeIntervalSince1970]];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@party/add?token=%@",KHttpServer,[UserInfo sharedUserInfo].strToken];
    NSString *_strNumber = nil;
    if([strNumber isEqualToString:@"不 限"])
    {
        _strNumber = @"99999999";
    }
    else
    {
        _strNumber = strNumber;
    }
    [_aryImage insertObject:_imgView.imgView.image atIndex:0];
    NSDictionary *parameter = @{@"userid":[UserInfo sharedUserInfo].strUserId,
                                @"title":strTitle,@"address":strAddress,@"people":_strNumber,
                                @"partytime":strDate,@"cost":strCost,@"content":_strContent};
    [self.view makeToastActivity];
    
    __weak AddPlayViewController *__self = self;
    [BaseService postJSONWithUrl:strUrl parameters:parameter success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        if ([[dict objectForKey:@"status"] intValue]==200)
        {
            //上传图片
            dispatch_async(dispatch_get_main_queue(), ^{
                if (__self.aryImage.count>0)
                {
                    NSDictionary *dicParty = [dict objectForKey:@"party"];
                    __self.backModel = [[PlayModel alloc] initWithDict:dicParty];
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
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self.view hideToastActivity];
                [__self.view makeToast:@"创建失败"];
            });
        }
    } fail:^(NSError *error)
    {
        DLog(@"error:%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.view hideToastActivity];
            [__self.view makeToast:@"创建失败"];
        });
    }];
}

-(void)uploadPartyId:(UIImage *)image
{
    NSString *strUrl = [NSString stringWithFormat:@"%@pub/uploadMore/party/%@?token=%@&type=jpg",KHttpServer,_backModel.strPartyid
                        ,[UserInfo sharedUserInfo].strToken];
    __weak AddPlayViewController *__self = self;
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [txtView resignFirstResponder];
        return NO;
    }
    return YES;
}


-(void)initHiddenView
{
    _hiddenView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_hiddenView];
    
    UIView *headView = [[UIView alloc] initWithFrame:Rect(0, 0,kScreenSourchWidth, kScreenSourchHeight-200)];
    [headView setBackgroundColor:RGB(128, 128, 128)];
    [_hiddenView addSubview:headView];
    headView.alpha = 0.5f;
    
    UIView *backView = [[UIView alloc] initWithFrame:Rect(0, kScreenSourchHeight-230 , kScreenSourchWidth, 230)];
    [_hiddenView addSubview:backView];
    [backView setBackgroundColor:RGB(255, 255, 255)];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"相册" forState:UIControlStateNormal];
    [btn2 setTitle:@"照相" forState:UIControlStateNormal];
    [btn3 setTitle:@"取消" forState:UIControlStateNormal];
    [btn1 setTitleColor:RGB(26,26, 26) forState:UIControlStateNormal];
    [btn3 setTitleColor:RGB(26,26, 26) forState:UIControlStateNormal];
    [btn2 setTitleColor:RGB(26,26, 26) forState:UIControlStateNormal];
    
    btn1.layer.borderWidth = 0.5;
    btn2.layer.borderWidth = 0.5;
    btn3.layer.borderWidth = 0.5;
    
    btn1.layer.borderColor = (RGB(178, 178, 178)).CGColor;
    btn2.layer.borderColor = (RGB(178, 178, 178)).CGColor;
    btn3.layer.borderColor = (RGB(178, 178, 178)).CGColor;
    
    btn1.layer.masksToBounds = YES;
    btn1.layer.cornerRadius = 5.0f;
    btn2.layer.masksToBounds = YES;
    btn2.layer.cornerRadius = 5.0f;
    btn3.layer.masksToBounds = YES;
    btn3.layer.cornerRadius = 5.0f;
    
    btn1.frame = Rect(30, 30, kScreenSourchWidth-60, 45);
    btn2.frame = Rect(30, 90, kScreenSourchWidth-60, 45);
    btn3.frame = Rect(30, 150, kScreenSourchWidth-60, 45);
    
    [btn1 addTarget:self action:@selector(onAddPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(onAddCamre:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(viewHidden) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:btn1];
    [backView addSubview:btn2];
    [backView addSubview:btn3];
    
    _hiddenView.hidden = YES;
}

-(void)viewHidden
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.3];
    _hiddenView.hidden = YES;
    [UIView commitAnimations];
}

- (void)onAddPhoto:(UIButton *)sender
{
    _imagePicker = [[UIImagePickerController alloc] init];//
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = NO;
    [self presentViewController:_imagePicker animated:YES completion:^{}];
    
}

-(void)onAddCamre:(UIButton *)sender
{
    
    _camrePicker = [[UIImagePickerController alloc] init];//
    _camrePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _camrePicker.delegate = self;
    _camrePicker.allowsEditing = NO;
    _camrePicker.modalPresentationStyle=UIModalPresentationFullScreen;
    _camrePicker.modalPresentationStyle=UIModalPresentationCurrentContext;
    [self presentViewController:_camrePicker animated:YES completion:^{}];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = nil;
    
    image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    
    _imgView.imgView.image = image;
    
    _hiddenView.hidden = YES;
    
    [self dismissViewControllerAnimated:YES completion:^{}];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}



@end
