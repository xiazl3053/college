//
//  UserSettingViewController.m
//  college
//
//  Created by xiongchi on 15/8/25.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "UserSettingViewController.h"
#import "XLoginTextField.h"
#import "BaseService.h"
#import "UserInfo.h"
#import "RSKImageCropper.h"
#import "Toast+UIView.h"
#import "AppDelegate.h"
#import "XLoginButton.h"
#import "UIView+BlocksKit.h"

@interface UserSettingViewController ()<UITextFieldDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *imgHead;
    UITextField *_txtFieldView;
    XLoginTextField *txtName;
    XLoginTextField *txtSchool;
    UIImage *_image;
}
@property (nonatomic,strong) UIView * hiddenView;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) UIImagePickerController *camrePicker;

@end

@implementation UserSettingViewController

-(void)initView
{
    imgHead = [[UIImageView alloc] initWithFrame:Rect(kScreenSourchWidth/2-39.5, 74,79, 79)];
    [imgHead setImage:[UIImage imageNamed:@"moren_longin"]];
    [imgHead setUserInteractionEnabled:YES];
    [imgHead.layer setMasksToBounds:YES];
    [imgHead.layer setCornerRadius:39.5];
    
    UILabel *lblInfo = [[UILabel alloc] initWithFrame:Rect(imgHead.x, imgHead.y+imgHead.height+12, 79, 20)];
    [lblInfo setText:@"设置头像"];
    [lblInfo setTextColor:UIColorFromRGB(0xFFFFFF)];
    [lblInfo setFont:XFONT(12)];
    [self.view addSubview:lblInfo];
    [lblInfo setTextAlignment:NSTextAlignmentCenter];
    
    txtName = [[XLoginTextField alloc] initWithFrame:Rect(30, 230, kScreenSourchWidth-60, 45)];
    txtSchool = [[XLoginTextField alloc] initWithFrame:Rect(30, txtName.y+txtName.height+19, txtName.width, txtName.height)];
    
    [self.view addSubview:imgHead];
    [self.view addSubview:txtName];
    [self.view addSubview:txtSchool];
    
    UIColor *color = UIColorFromRGB(0xFFFFFF);
    txtName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请设置昵称" attributes:@{NSForegroundColorAttributeName: color}];
    txtSchool.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入学校" attributes:@{NSForegroundColorAttributeName: color}];
    [txtName setBackgroundColor:UIColorFromRGB(0xfe864a)];
    [txtSchool setBackgroundColor:UIColorFromRGB(0xfe864a)];
    [txtName setTextAlignment:NSTextAlignmentCenter];
    [txtSchool setTextAlignment:NSTextAlignmentCenter];
    txtSchool.layer.borderColor = [UIColor clearColor].CGColor;
    txtName.layer.borderColor = [UIColor clearColor].CGColor;
    
    XLoginButton *btnStart = [[XLoginButton alloc] initWithFrame:Rect(10, txtSchool.y+txtSchool.height+60, kScreenSourchWidth-20, 45)];
    [btnStart setTitle:@"开启征程" forState:UIControlStateNormal];
    [btnStart setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
    
    [self.view addSubview:btnStart];
    [txtName setDelegate:self];
    [txtSchool setDelegate:self];
    [btnStart addTarget:self action:@selector(startEvent) forControlEvents:UIControlEventTouchUpInside];
    [self initHiddenView];
    __weak UserSettingViewController *__self = self;
    [imgHead bk_whenTouches:1 tapped:1 handler:^{
        __self.hiddenView.hidden = NO;
    }];
}

-(void)startEvent
{
    NSString *strNick = txtName.text;
    NSString *strSchool = txtSchool.text;
    if (strNick==nil || [strNick isEqualToString:@""])
    {
        [self.view makeToast:@"昵称不能为空"];
        return ;
    }
    if (strSchool==nil || [strSchool isEqualToString:@""]) {
        [self.view makeToast:@"学校不能为空"];
        return ;
    }
    [self.view makeToastActivity];
    __weak UserSettingViewController *__self = self;
    NSString *strUrl = [NSString stringWithFormat:@"%@pub/updateUser?token=%@",KHttpServer,[UserInfo sharedUserInfo].strToken];
    __weak UIImageView *__imgHead = imgHead;
    NSDictionary *parameters = @{@"userid":[UserInfo sharedUserInfo].strUserId,@"nickname":strNick,@"organization":strSchool};
    [BaseService postJSONWithUrl:strUrl parameters:parameters success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[dict objectForKey:@"status"] intValue]==200)
        {
            if (__imgHead.image)
            {
                [__self uploadImage];
            }
            else
            {
                 [(AppDelegate *)[[UIApplication sharedApplication] delegate] setMainRootView];
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self.view makeToast:[dict objectForKey:@"msg"]];
            });
        }
    } fail:^(NSError *error)
    {
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__self.view hideToastActivity];
                [__self.view makeToast:@"连接服务器失败"];
            });
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:MAIN_COLOR];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)KeyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    //获取高度
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    /*关键的一句，网上关于获取键盘高度的解决办法，多到这句就over了。系统宏定义的UIKeyboardBoundsUserInfoKey等测试都不能获取正确的值。不知道为什么。。。*/
    CGSize keyboardSize = [value CGRectValue].size;
    if (_txtFieldView==nil)
    {
        return ;
    }
    CGFloat move = (_txtFieldView.superview.y+_txtFieldView.y+_txtFieldView.height)-(self.view.height-keyboardSize.height);
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.30f];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(move > 0)
    {
        self.view.frame = CGRectMake(0.0f, -move, self.view.width, self.view.height);
    }
    [UIView commitAnimations];
}

-(void)KeyboardEditing:(NSNotification *)notification
{
    _txtFieldView = notification.object;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.view.y<0)
    {
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:0.30f];
        self.view.frame = CGRectMake(0.0f, 0, self.view.width, self.view.height);
        [UIView commitAnimations];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
    if(_imagePicker==nil)
    {
        _imagePicker = [[UIImagePickerController alloc] init];//
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = NO;
    }
    [self presentViewController:_imagePicker animated:YES completion:^{}];
    
}

-(void)onAddCamre:(UIButton *)sender
{
    if(_camrePicker==nil)
    {
        _camrePicker = [[UIImagePickerController alloc] init];//
        _camrePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _camrePicker.delegate = self;
        _camrePicker.allowsEditing = NO;
        _camrePicker.modalPresentationStyle=UIModalPresentationFullScreen;
        _camrePicker.modalPresentationStyle=UIModalPresentationCurrentContext;
    }
    [self presentViewController:_camrePicker animated:YES completion:^{}];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = nil;
    
    image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    //圆形图片剪切
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = self;
    [self presentViewController:imageCropVC animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    //coppedImage
    [self dismissViewControllerAnimated:YES completion:nil];
    _image = croppedImage;
    [imgHead setImage:_image];
    _hiddenView.hidden = YES;
}

-(void)uploadImage
{
    __weak UserSettingViewController *__self = self;
    NSString *strUploadPic = [NSString stringWithFormat:@"%@pub/uploadUserPicture?token=%@&userid=%@&type=jpg",KHttpServer,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId];
    [BaseService postUploadWithUrl:strUploadPic image:imgHead.image success:^(id response)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
         DLog(@"dict:%@",dict);
         NSString *strTest = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         DLog(@"strTest:%@",strTest);
         if ([[dict objectForKey:@"status"] intValue]==200)
         {
             dispatch_async(dispatch_get_main_queue(),
             ^{
                 [__self.view makeToastActivity];
                  __self.hiddenView.hidden = YES;
                 [__self.view makeToast:@"上传成功"];
                 [(AppDelegate *)[[UIApplication sharedApplication] delegate] setMainRootView];
             });
         }
     } fail:nil];
}


@end
