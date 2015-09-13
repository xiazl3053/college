//
//  UserInfoVIewController.m
//  XCMonit_Ip
//
//  Created by 夏钟林 on 14/7/15.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "UserInfoVIewController.h"
#import "UserImageCell.h"
#import "BaseService.h"
#import "UIImageView+WebCache.h"
#import "UserInfo.h"
#import "Toast+UIView.h"
#import "UpdEmailViewController.h"
#import "UpdPwdViewController.h"
#import "UpdNikNameViewController.h"
#import "RSKImageCropper.h"
#import "RsMeSelectCell.h"

#define USER_INFO_NULL NSLocalizedString(@"NULLInfo", nil)

//修改昵称、邮箱、密码、
@interface UserInfoVIewController ()<RSKImageCropViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL bView;
}

@property (nonatomic,strong) UIView *hiddenView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) UIImagePickerController *camrePicker;

@end

@implementation UserInfoVIewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initUI
{
    [self setTitleText:@"个人资料"];
    [self.view setBackgroundColor:VIEW_BACK];

}
-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kScreenSourchWidth,45*5+67) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionHeaderHeight = 10.0;
    _tableView.sectionFooterHeight = 10.0;
    [_tableView setBackgroundColor:VIEW_BACK];
    bView = YES;
    [self initData];
    
    UIButton *btnPush = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPush setTitle:@"修改密码" forState:UIControlStateNormal];
    [btnPush setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [btnPush setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateHighlighted];
    [btnPush.layer setMasksToBounds:YES];
    [btnPush.layer setCornerRadius:5.0];
    [btnPush addTarget:self action:@selector(updatePwd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPush];
    
    [btnPush setBackgroundColor:MAIN_COLOR];
    
    btnPush.frame = Rect(10, _tableView.y+_tableView.height+5, kScreenSourchWidth-20, 45);
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:NS_UPDATE_USER_INFO_VC object:nil];
    [self initHiddenView];
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
    }
    [self presentViewController:_camrePicker animated:YES completion:^{}];
}

-(void)updatePwd
{
    UpdPwdViewController *upd = [[UpdPwdViewController alloc] init];
    [self presentViewController:upd animated:YES completion:nil];
}

-(void)initData
{
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *strUserInfo = @"XCUserAllInfo";
        static NSString *strImageInfo = @"xcUserImageCell";
        if(indexPath.section ==0 && indexPath.row==0)
        {
            DLog(@"重新加载");
            UserImageCell *imgCell = [tableView dequeueReusableCellWithIdentifier:strImageInfo];
            if (imgCell==nil)
            {
                imgCell = [[UserImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strImageInfo];
            }
            [imgCell.lblDevInfo setText:@"头像"];
            NSString *strInfo = [NSString stringWithFormat:@"%@pub/downloadUserPicture?token=%@&userid=%@",
                                 KHttpServer,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId];
            [imgCell.imgView sd_setImageWithURL:[NSURL URLWithString:strInfo] placeholderImage:[UIImage imageNamed:@"moren_longin"]];
            return imgCell;
        }
        RsMeSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:strUserInfo];
        if (cell==nil)
        {
            cell = [[RsMeSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strUserInfo];
        }
        switch (indexPath.row)
        {
            case 1:
            {
                [cell.lblName setText:@"昵称"];
                [cell.txtName setText:@""];
            }
            break;
            case 2:
            {
         
                [cell.lblName setText:@"真实姓名"];
                [cell.txtName setText:@""];
            }
            break;
        
            case 3:
            {
                [cell.lblName setText:@"Email"];
                [cell.txtName setText:@""];
            }
            break;
            case 4:
            {
                [cell.lblName setText:@"身份证"];
                [cell.txtName setText:@""];
                [cell setLineFull];
            }
            break;
        }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        
        case 0:
        {
            switch (indexPath.row)
            {
                case 1:
                {
                    UpdNikNameViewController *upd= [[UpdNikNameViewController alloc] init];
                    [self presentViewController:upd animated:YES completion:nil];
                }
                break;
                case 0:
                {
                    _hiddenView.hidden = NO;
                }
                break;
            }
        }
        break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
//                    UpdRealViewController *upd = [[UpdRealViewController alloc] init];
//                    [self presentViewController:upd animated:YES completion:nil];
                }
                    break;
                case 1:
                {
//                    UpdEmailViewController *updEmail = [[UpdEmailViewController alloc] init];
//                    [self presentViewController:updEmail animated:YES completion:nil];
                }
                    break;
                case 2:
                {
                    
                }
                break;
                case 3:
                {
                
                }
                break;
                default:
                break;
            }
        }
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark 高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 67;
    }
    return 45;//67+44.5*4+80
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:Rect(0, 0, kScreenSourchWidth, 30)];
    [headView setBackgroundColor:VIEW_BACK];
    return headView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:Rect(0, 0, kScreenSourchWidth, 10)];
    [headView setBackgroundColor:VIEW_BACK];
    return headView;
}


#pragma mark 重力处理
- (BOOL)shouldAutorotate
{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
//    [self.addPhotoButton setImage:croppedImage forState:UIControlStateNormal];
    //coppedImage
    [self dismissViewControllerAnimated:YES completion:nil];
    [self uploadImage:croppedImage];
}

-(void)uploadImage:(UIImage*)image
{
    __weak UserInfoVIewController *__self = self;
    //上传图片
    NSString *strUrl = [NSString stringWithFormat:@"%@pub/uploadUserPicture?userid=%@&token=%@&type=jpg",KHttpServer,[UserInfo sharedUserInfo].strUserId,[UserInfo sharedUserInfo].strToken];
    
    [BaseService postUploadWithUrl:strUrl image:image success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        if ([[dict objectForKey:@"status"] intValue]==200)
        {
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__self updateImgView];
            });
        }
    } fail:^{
        
    }];
}
-(void)updateImgView
{
    NSString *strImg = [NSString stringWithFormat:@"%@pub/downloadUserPicture?token=%@&uesrid=%@",
                        KHttpServer,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId];
    [[SDImageCache sharedImageCache] removeImageForKey:strImg];
//    NSArray *array = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForItem:0 inSection:0], nil];
    __weak UserInfoVIewController *__self = self;
    UserImageCell *cell = (UserImageCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:strImg] placeholderImage:[UIImage imageNamed:@"moren_longin"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        [__self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_FOR_UPDATE_USER_INFO object:nil];
    }];
}

@end
