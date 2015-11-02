//
//  ResumeEditViewController.m
//  college
//
//  Created by xiongchi on 15/9/5.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "ResumeEditViewController.h"
#import "EvaluationViewController.h"
#import "PeixViewController.h"
#import "LangugeViewController.h"
#import "TrueJobViewController.h"
#import "StuHorViewController.h"
#import "XLoginTextField.h"
#import "XLoginButton.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "Toast+UIView.h"
#import "BaseService.h"
#import "StudentViewController.h"
#import "UserInfo.h"
#import "RsMeViewCOntroller.h"
#import "RsMeSelectCell.h"
#import "ResumeModel.h"
#import "RSKImageCropper.h"

@interface ResumeEditViewController ()<UITableViewDataSource,UITableViewDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *imgView;
    UILabel *lblTitle;
    UIView *updateView;
    UIView *alView;
    XLoginTextField *txtUpd;
}
@property (nonatomic,strong) ResumeModel *model;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) BOOL bLoading;

@property (nonatomic,strong) UIView * hiddenView;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) UIImagePickerController *camrePicker;

@end

@implementation ResumeEditViewController
-(void)initUpdateView
{
    alView = [[UIView alloc] initWithFrame:self.view.bounds];
    [alView setBackgroundColor:RGB(210, 210, 210)];
    [alView setAlpha:0.5];
    [self.view addSubview:alView];
    
    updateView = [[UIView alloc] initWithFrame:Rect(kScreenSourchWidth/2-150,kScreenSourchHeight/2-70,300,140)];
    
    [updateView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:updateView];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(0, 5, updateView.width, 30)];
    
    [lblName setText:@"修改简历名称"];
    
    [lblName setTextColor:MAIN_COLOR];
    
    [lblName setTextAlignment:NSTextAlignmentCenter];
    
    [lblName setFont:XFONT(12)];
    
    [updateView addSubview:lblName];
    
    txtUpd = [[XLoginTextField alloc] initWithFrame:Rect(10,45, updateView.width-20, 40)];
    
    UIView *leftView = [[UIView alloc] initWithFrame:Rect(0, 0, 10, 40)];
    
    txtUpd.leftView = leftView;
    
    txtUpd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    txtUpd.leftViewMode = UITextFieldViewModeAlways;
    
    [updateView addSubview:txtUpd];
    
    [updateView.layer setMasksToBounds:YES];
    [updateView.layer setCornerRadius:5];
    
    XLoginButton *btnCan = [[XLoginButton alloc] initWithFrame:Rect(10, updateView.height-45, updateView.width/2-12.5, 39)];
    
    XLoginButton *btnUpd = [[XLoginButton alloc] initWithFrame:Rect(btnCan.x+btnCan.width+5,btnCan.y,btnCan.width, 39)];
    
    [btnCan setTitle:@"取消" forState:UIControlStateNormal];
    btnCan.layer.borderColor = MAIN_COLOR.CGColor;
    [btnCan setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    btnCan.layer.borderWidth = 0.5;
    
    [btnUpd setTitle:@"保存" forState:UIControlStateNormal];
    btnUpd.layer.borderColor = MAIN_COLOR.CGColor;
    [btnUpd setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    btnUpd.layer.borderWidth = 0.5;
    
    [btnCan addTarget:self action:@selector(canView) forControlEvents:UIControlEventTouchUpInside];
    [btnUpd addTarget:self action:@selector(confige) forControlEvents:UIControlEventTouchUpInside];
    
    [updateView addSubview:btnCan];
    [updateView addSubview:btnUpd];
    
    alView.hidden = YES;
    updateView.hidden = YES;
}

-(void)updateTitleService:(NSString *)strInfo
{
    NSString *strUrl = [NSString stringWithFormat:@"%@pub/updateJianLi?token=%@&userid=%@",
                         KHttpServer,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId];
    NSDictionary *parameters = @{@"jianliid":_model.strJLId,@"userid":[UserInfo sharedUserInfo].strUserId,@"title":strInfo};
    __weak ResumeEditViewController *__self = self;
    __weak ResumeModel *__model = _model;
    [BaseService postJSONWithUrl:strUrl parameters:parameters success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[dict objectForKey:@"status"] intValue]==200)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_FOR_RESUME_UPDATE_VC object:nil];
            __model.strTitle = [[dict objectForKey:@"jianli"] objectForKey:@"title"];
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__self.view makeToast:@"修改成功"];
            });
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

-(void)confige
{
    NSString *strTitle = txtUpd.text;
    
    if (strTitle==nil || [strTitle isEqualToString:@""])
    {
        [self.view makeToast:@"简历名称不能为空"];
        return ;
    }
    
    lblTitle.text = strTitle;
    __block NSString *__strInfo = strTitle;
    __weak ResumeEditViewController *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [__self updateTitleService:__strInfo];
    });
    
    alView.hidden = YES;
    updateView.hidden = YES;
}

-(void)canView
{
    alView.hidden = YES;
    updateView.hidden = YES;
}


-(NSDictionary*)getDict:(ResumeModel *)model
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:model.strName forKey:@"name"];
    [dict setObject:model.strMobile forKey:@"mobile"];
    [dict setObject:model.strAddress forKey:@"address"];
    
    if(_model.strJLId != nil)
    {
        [dict setObject:_model.strJLId forKey:@"jianliid"];
    }
    
    [dict setObject:[UserInfo sharedUserInfo].strUserId forKey:@"userid"];
    NSString *strSex = [model.strSex isEqualToString:@"男"]?@"1":@"0";
    [dict setObject:strSex forKey:@"sex"];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *strBirthDay = [NSString stringWithFormat:@"%.0f000",[[fmt dateFromString:model.strBirthDay] timeIntervalSince1970]];
    [dict setObject:strBirthDay forKey:@"birthdate"];
    
    NSString *strCreateTime = [NSString stringWithFormat:@"%.0f000",[[fmt dateFromString:model.strCreateTime] timeIntervalSince1970]];
    [dict setObject:strCreateTime forKey:@"createtime"];
    
    NSString *strUpdTime = [NSString stringWithFormat:@"%.0f000",[[fmt dateFromString:model.strUpdTime] timeIntervalSince1970]];
    [dict setObject:strUpdTime forKey:@"updatetime"];
    
    if (model.strCard!=nil && ![_model.strCard isEqualToString:@""])
    {
        [dict setObject:model.strCard forKey:@"card"];
    }
    
    if (model.strEmail!=nil && ![model.strEmail isEqualToString:@""])
    {
        [dict setObject:model.strEmail forKey:@"email"];
    }
    
    [dict setObject:@"未命名的简历" forKey:@"title"];
    
    return dict;
}

-(void)addResume:(ResumeModel *)model
{
    NSString *strInfo = [NSString stringWithFormat:@"%@pub/addJianLi?token=%@",KHttpServer,[UserInfo sharedUserInfo].strToken];
    
    NSDictionary *parameters = [self getDict:model];
    
    __weak ResumeEditViewController *__self = self;
    [BaseService postJSONWithUrl:strInfo parameters:parameters success:^(id responseObject)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        if([[dict objectForKey:@"status"] intValue]==200)
        {
            NSDictionary *dictResume = [dict objectForKey:@"jianli"];
            ResumeModel *resume = [[ResumeModel alloc] initWithDict:dictResume];
            __self.model = resume;
            [[UserInfo sharedUserInfo].aryResume addObject:resume];
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_FOR_RESUME_UPDATE_VC object:nil];
            __self.bLoading = NO;
            dispatch_async(dispatch_get_main_queue(),
            ^{
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self.view makeToast:@"获取信息失败"];
            });
        }
        
    } fail:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.view makeToast:@"获取信息失败"];
        });
    }];
}

-(id)initWithNewModel:(ResumeModel *)model
{
    self = [super init];
    
    _bLoading = YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
        [self addResume:model];
    });
    return self;
}

-(id)initWithModel:(ResumeModel *)model
{
    self = [super init];
    
    _model = model;
    
    return self;
}

-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadModel
{
    _model = [[UserInfo sharedUserInfo].aryResume objectAtIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    
    [self setTitleText:@"编辑简历"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadModel) name:MESSAGE_FOR_RESUME_UPDATE_VC object:nil];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateHighlighted];
    
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftBtn:btnBack];
    
    UIView *tempView = [[UIView alloc] initWithFrame:Rect(0, 64,kScreenSourchWidth,60)];
    [tempView setBackgroundColor:MAIN_COLOR];
    [self.view addSubview:tempView];
    
    imgView = [[UIImageView alloc] initWithFrame:Rect(kScreenSourchWidth/2-42, tempView.y+tempView.height-42,84,84)];
    [self.view addSubview:imgView];
    NSString *strImg = [NSString stringWithFormat:@"%@pub/downloadJianLiPicture?token=%@&jianliid=%@&uesrid=%@",
                        KHttpServer,[UserInfo sharedUserInfo].strToken,_model.strJLId,[UserInfo sharedUserInfo].strUserId];
    DLog(@"strImg:%@",strImg);
    
    [imgView.layer setMasksToBounds:YES];
    [imgView.layer setCornerRadius:42];
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:strImg] placeholderImage:[UIImage imageNamed:@"moren_longin"]];
    imgView.userInteractionEnabled = YES;
    
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImgView)]];
    
    _tableView = [[UITableView alloc] initWithFrame:Rect(0,imgView.y+imgView.height+10, kScreenSourchWidth, kScreenSourchHeight-imgView.y+imgView.height+10) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionFooterHeight = 1.0;
    [_tableView setBackgroundColor:VIEW_BACK];
    
    UIView *headView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenSourchWidth, 45)];
    
    [_tableView setTableHeaderView:headView];
    
    [headView setBackgroundColor:RGB(255, 255, 255)];
    
    [self addLineView:headView heaght:0];
    [self addLineView:headView heaght:44.1];
    
    lblTitle = [[UILabel alloc] initWithFrame:Rect(10,0,200,44)];
    [lblTitle setTextColor:UIColorFromRGB(0x222222)];
    [lblTitle setText:(_model==nil) ? @"未命名的简历" : _model.strTitle];
    [lblTitle setFont:XFONT(14)];
    [headView addSubview:lblTitle];
    
    UITextField *txtEdit = [[UITextField alloc] initWithFrame:Rect(kScreenSourchWidth-130,0, 100,44)];
    [txtEdit setText:@"编辑"];
    txtEdit.font = XFONT(14);
    [txtEdit setTextColor:RGB(198, 198, 198)];
    txtEdit.userInteractionEnabled= NO;
    txtEdit.textAlignment = NSTextAlignmentRight;
    [headView addSubview:txtEdit];
    
    //22-6.5
    
    UIImageView *imgTest = [[UIImageView alloc] initWithFrame:Rect(kScreenSourchWidth-23,15.5,8,13)];
    [imgTest setImage:[UIImage imageNamed:@"more_ico"]];
    [headView addSubview:imgTest];
    
    [headView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateTitle)]];
    
    [self initHiddenView];
    [self initUpdateView];
    
}

-(void)updateTitle
{
    txtUpd.text = lblTitle.text;
    alView.hidden = NO;
    updateView.hidden = NO;
}

-(void)addLineView:(UIView *)headView heaght:(CGFloat)height
{
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, height, headView.width, 0.4)];
    line1.backgroundColor = LINE_COLOR;
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, height+0.4, headView.width,0.4)] ;
    line2.backgroundColor = [UIColor whiteColor];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [headView addSubview:line1];
    [headView addSubview:line2];
}

-(void)showImgView
{
    _hiddenView.hidden = NO;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==1)
    {
        return 5;
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strResumeEditView = @"strResumeEditView";
    
    RsMeSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:strResumeEditView];
    
    if (cell==nil)
    {
        cell = [[RsMeSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strResumeEditView];
    }
    
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            [cell.lblName setText:@"个人信息"];
        }
        else
        {
            [cell.lblName setText:@"自我评价"];
            [cell setLineFull];
        }
    }
    else if(indexPath.section==1)
    {
        if (indexPath.row==0) {
            [cell.lblName setText:@"教育背景"];
        }
        else if(indexPath.row==1)
        {
            [cell.lblName setText:@"学生奖励"];
        }
        else if(indexPath.row==2)
        {
            [cell.lblName setText:@"实践经验"];
        }
        else if(indexPath.row==3)
        {
            [cell.lblName setText:@"语言能力"];
        }
        else if(indexPath.row==4)
        {
            [cell.lblName setText:@"培训经历"];
            [cell setLineFull];
        }
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(void)setPersonInfo
{
    RsMeViewController *rsView = [[RsMeViewController alloc] initWithModel:_model];
    [self presentViewController:rsView animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_bLoading)
    {
        [self.view makeToast:@"正在更新简历信息"];
        return;
    }
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0)
            {
                [self setPersonInfo];
            }
            else if(indexPath.row==1)
            {
                EvaluationViewController *evaluView = [[EvaluationViewController alloc] initWithModel:_model];
                
                [self presentViewController:evaluView animated:YES completion:nil];
            }
        }
        break;
        case 1:
        {
            if (indexPath.row==0)
            {
                StudentViewController *stuView = [[StudentViewController alloc] initWithModel:_model];
                [self presentViewController:stuView animated:YES completion:nil];
            }
            else if(indexPath.row==1)
            {
                StuHorViewController *stuView = [[StuHorViewController alloc] initWithModel:_model];
                [self presentViewController:stuView animated:YES completion:nil];
            }
            else if(indexPath.row == 2)
            {
                TrueJobViewController *trueView = [[TrueJobViewController alloc] initWithModel:_model];
                [self presentViewController:trueView animated:YES completion:nil];
            }
            else if(indexPath.row ==3)
            {
                LangugeViewController *langView = [[LangugeViewController alloc] initWithModel:_model];
                [self presentViewController:langView animated:YES completion:nil];
            }
            else if(indexPath.row ==4 )
            {
                PeixViewController *perView = [[PeixViewController alloc] initWithModel:_model];
                [self presentViewController:perView animated:YES completion:nil];
            }
            
        }
            break;
        default:
            break;
    }
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenSourchWidth, 30)];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(10, 0, 200, 30)];
    
    [lblName setTextColor:MAIN_COLOR];
    
    [lblName setFont:XFONT(13)];
    
    if (section==0)
    {
        [lblName setText:@"基本信息"];
    }
    else
    {
        [lblName setText:@"重要信息"];
    }
    [headView addSubview:lblName];
    return headView;
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
    [self uploadImage:croppedImage];
}

-(void)uploadImage:(UIImage*)image
{
    __weak ResumeEditViewController *__self = self;
    NSString *strUploadPic = [NSString stringWithFormat:@"%@pub/uploadJianLiPicture?token=%@&userid=%@&type=jpg&jianliid=%@",KHttpServer,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId,_model.strJLId];
    DLog(@"strUploadPic:%@",strUploadPic);
    [BaseService postUploadWithUrl:strUploadPic image:image success:^(id response)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
        NSString *strTest = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        DLog(@"strTest:%@",strTest);
        if ([[dict objectForKey:@"status"] intValue]==200)
        {
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__self updateImgView:image];
                __self.hiddenView.hidden = YES;
                [__self.view makeToast:@"上传成功"];
            });
        }
    } fail:nil];
}

-(void)updateImgView:(UIImage *)image
{
    NSString *strImg = [NSString stringWithFormat:@"%@pub/downloadJianLiPicture?token=%@&jianliid=%@&uesrid=%@",
                        KHttpServer,[UserInfo sharedUserInfo].strToken,_model.strJLId,[UserInfo sharedUserInfo].strUserId];
    [[SDImageCache sharedImageCache] removeImageForKey:strImg];
    [imgView sd_setImageWithURL:[NSURL URLWithString:strImg] placeholderImage:[UIImage imageNamed:@"moren_longin"]];
}

@end
