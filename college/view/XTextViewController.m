//
//  XTextViewController.m
//  college
//
//  Created by xiongchi on 15/9/12.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "XTextViewController.h"
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"

@interface XTextViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString *_strTitle;
    UITextView *txtView;
    UIButton *btnImg;
    NSString *_strContent;
    UIView *keyView;
}

@property (nonatomic,strong) NSMutableArray *aryImage;
@property (nonatomic,strong) UIView * hiddenView;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) UIImagePickerController *camrePicker;

@end

@implementation XTextViewController

-(id)initWithTitle:(NSString *)strTitle content:(NSString *)strContent ary:(NSArray *)array
{
    self = [super init];
    _strTitle = strTitle;
    _strContent = strContent;
    if( array && array.count>0)
    {
        _aryImage = [NSMutableArray array];
        [_aryImage addObjectsFromArray:array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:_strTitle];
    if(_aryImage==nil)
    {
        _aryImage = [NSMutableArray array];
    }
    
    [self.view setBackgroundColor:VIEW_BACK];
    
    txtView = [[UITextView alloc] initWithFrame:Rect(0, 64, kScreenSourchWidth, kScreenSourchHeight-129)];
    [self.view addSubview:txtView];
    [txtView setDelegate:self];
    [txtView setFont:XFONT(12)];
    txtView.scrollEnabled = YES;
    
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
    
    btnImg = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    [self.view addSubview:btnImg];
    
    [btnImg setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    [btnImg setImage:[UIImage imageNamed:@"photo_h"] forState:UIControlStateHighlighted];
    btnImg.frame = Rect(10,3, 44, 44);
    
    keyView = [[UIView alloc] initWithFrame:Rect(0, kScreenSourchHeight-114,kScreenSourchWidth,50)];
    [self.view addSubview:keyView];
    [keyView setBackgroundColor:VIEW_BACK];
    [keyView addSubview:btnImg];
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setTitle:@"完成" forState:UIControlStateNormal];
    [btnDone setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [keyView addSubview:btnDone];
    btnDone.titleLabel.font = XFONT(14);
    btnDone.frame = Rect(kScreenSourchWidth-60,5, 50, 40);
    [btnDone addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    [self initHiddenView];
    
    [btnImg addTarget:self action:@selector(showImageEvent) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray *aryIndex = [NSMutableArray array];
    if(_strContent)
    {
        _strContent = [_strContent stringByReplacingOccurrencesOfString:@"\n" withString:@"\r\n"];
    }
    while (YES&&_strContent)
    {
        NSRange start = [_strContent rangeOfString:@"<img>"];
        if (start.location == NSNotFound)
        {
            break;
        }
        NSRange end = [_strContent rangeOfString:@"</img>"];
        NSLog(@"rang:%@",[_strContent substringWithRange:NSMakeRange(start.location,end.location+end.length-start.location)]);
        _strContent = [_strContent stringByReplacingCharactersInRange:NSMakeRange(start.location,end.location+end.length-start.location) withString:@""];
        
        [aryIndex addObject:[NSNumber numberWithInteger:start.location]];
    }
    txtView.text = _strContent;
    int nNumber = 0;
    for (NSNumber *number in aryIndex)
    {
        EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
        //Set tag and image
        emojiTextAttachment.emojiTag = @"<img>{width:100,height:100}</img>";
        emojiTextAttachment.image = [_aryImage objectAtIndex:nNumber];
        emojiTextAttachment.emojiSize = EMOJI_MAX_SIZE;
        [txtView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]
                                              atIndex:[number intValue]];
        nNumber++;
    }
}

-(void)closeKeyboard
{
    [txtView resignFirstResponder];
}

-(void)showImageEvent
{
//    _hiddenView.hidden = NO;
    _imagePicker = [[UIImagePickerController alloc] init];//
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = NO;
    [self presentViewController:_imagePicker animated:YES completion:^{}];
}

-(void)setContent:(NSString *)strInfo
{
    txtView.text = strInfo;
}

-(void)setEvent
{
    __weak XTextViewController *__self = self;
    [txtView.textStorage enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, txtView.textStorage.length)
                                    options:0
                                 usingBlock:^(id value, NSRange range, BOOL *stop)
                                 {
                                     if (value && [value isKindOfClass:[EmojiTextAttachment class]])
                                     {
                                         EmojiTextAttachment *emojiTextAttachment = (EmojiTextAttachment*)value;
                                         [__self.aryImage addObject:emojiTextAttachment.image];
                                     }
                                 }];
    DLog(@"[txtView.textStorage getPlainString]:%@",[txtView.textStorage getPlainString]);
    if (_blockText)
    {
        _blockText([txtView.textStorage getPlainString],_aryImage);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

-(void)insertEmoji:(UIImage*)image
{
    //Create emoji attachment
    EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
    
    //Set tag and image
    emojiTextAttachment.emojiTag = @"<img>{width:100,height:100}</img>";
    emojiTextAttachment.image = image;
    
    //Set emoji size
    emojiTextAttachment.emojiSize = EMOJI_MAX_SIZE;
    //Insert emoji image
    
    [txtView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]
                                          atIndex:txtView.selectedRange.location];
    //Move selection location
    txtView.selectedRange = NSMakeRange(txtView.selectedRange.location + 1, txtView.selectedRange.length);
    //Reset text style
    [self resetTextStyle];
}
- (void)resetTextStyle
{
    //After changing text selection, should reset style.
    NSRange wholeRange = NSMakeRange(0, txtView.textStorage.length);
    
    [txtView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    
    [txtView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:wholeRange];
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
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    
    [self insertEmoji:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}
-(void)keyboardHide
{
    txtView.frame = Rect(0, 64, kScreenSourchWidth,kScreenSourchHeight-129);
    keyView.frame = Rect(0,kScreenSourchHeight-114,kScreenSourchWidth,50);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)KeyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    //获取高度
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    /*关键的一句，网上关于获取键盘高度的解决办法，多到这句就over了。系统宏定义的UIKeyboardBoundsUserInfoKey等测试都不能获取正确的值。不知道为什么。。。*/
    CGSize keyboardSize = [value CGRectValue].size;
    
//    CGFloat move = (_txtFieldView.superview.y+_txtFieldView.y+_txtFieldView.height)-(self.view.height-keyboardSize.height);
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.30f];
    txtView.frame = Rect(0, 64, kScreenSourchWidth,kScreenSourchHeight-keyboardSize.height-50-30);
    keyView.frame = Rect(0,kScreenSourchHeight-keyboardSize.height-50+10, kScreenSourchWidth,50);
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    [UIView commitAnimations];
}

@end
