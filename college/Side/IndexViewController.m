//
//  IndexViewController.m
//  FreeCar
//
//  Created by xiongchi on 15/8/5.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "IndexViewController.h"
#import "MainViewController.h"
#import "IdeaViewController.h"
#import "NewViewController.h"
#import "LoginViewController.h"
#import "XCollTab.h"
#import "PlayViewController.h"
#import "StudyViewController.h"
//#import "DownRecordViewController.h"
//#import "SettingViewController.h"
#import "JobViewController.h"

@interface IndexViewController ()<XCollTabDelegate>
{
//    DownRecordViewController *recordViewControl;
//    RecordViewController *localRecord;
//    UIViewController *tempControl;
//    SettingViewController *settingControl;
    MainViewController *mainViewControl;
    LoginViewController *loginView;
    XCollTab *_tabInfo;
    
    PlayViewController *playControl;
    NewViewController *newControl;
    JobViewController *jobControl;
    IdeaViewController *ideaControl;
    StudyViewController *studyView;
}


@end

@implementation IndexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    
    XCOLLInfo *bInfo1 = [[XCOLLInfo alloc] initWithItem:@[@"view_news_icon",@"view_news_icon_pressed",@"view_news_icon_pressed",@"新闻"]];
    
    XCOLLInfo *bInfo2 = [[XCOLLInfo alloc] initWithItem:@[@"view_learn_icon",@"view_learn_icon_pressed",@"view_learn_icon_pressed"
                                                                ,@"学术"]];
    XCOLLInfo *bInfo3 = [[XCOLLInfo alloc] initWithItem:@[@"view_job_icon",@"view_job_icon_pressed",@"view_job_icon_pressed",
                                                                @"兼职"]];
    XCOLLInfo *bInfo4 = [[XCOLLInfo alloc] initWithItem:@[@"view_idea_icon",@"view_idea_icon_pressed",@"view_idea_icon_pressed"
                                                                ,@"创意"]];
    XCOLLInfo *bInfo5 = [[XCOLLInfo alloc] initWithItem:@[@"view_play_icon",@"view_play_icon_pressed",@"view_play_icon_pressed",
                                                                @"娱乐"]];
    
    NSArray *aryFrame = [[NSArray alloc] initWithObjects:bInfo1,bInfo2,bInfo3,bInfo4,bInfo5, nil];
    
    _tabInfo = [[XCollTab alloc] initWithArrayItem:aryFrame frame:Rect(0, kScreenSourchHeight-50,kScreenSourchWidth, 50)];
    
    [self.view addSubview:_tabInfo];
    
    _tabInfo.delegate = self;
    
    jobControl = [[JobViewController alloc] init];
    [self addChildViewController:jobControl];
    
    newControl = [[NewViewController alloc] init];
    [self addChildViewController:newControl];
    
    playControl = [[PlayViewController alloc] init];
    [self addChildViewController:playControl];
    
    studyView = [[StudyViewController alloc] init];
    [self addChildViewController:studyView];
    
    ideaControl = [[IdeaViewController alloc] init];
    [self addChildViewController:ideaControl];
    
    [_tabInfo clickIndex:2];
    [self showSonView:jobControl];
}

-(void)showSonView:(UIViewController *)tempControl
{
    __weak UIViewController *__viewControl = tempControl;
    __weak IndexViewController *__self = self;
    __weak XCollTab *__tabInfo = _tabInfo;
    [UIView animateWithDuration:0.2f animations:^{
        if(__viewControl)
        {
            __viewControl.view.frame = Rect(0, 0,kScreenSourchWidth,kScreenSourchHeight-50);
            [__self.view insertSubview:__viewControl.view belowSubview:__tabInfo];
        }
    }
    completion:^(BOOL finish)
     {
         
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickView:(UIButton *)btnSender index:(int)nIndex
{
    DLog(@"index:%d",nIndex);
    UIViewController *tempView = nil;
    switch (nIndex)
    {
        case 0:
        {
            tempView = newControl;
        }
        break;
        case 1:
        {
            tempView = studyView;
        }
        break;
        case 2:
        {
            tempView = jobControl;
        }
        break;
        case 3:
        {
            tempView = ideaControl;
        }
            break;
        case 4:
        {
            tempView = playControl;
        }
        break;
        default:
            break;
    }
    [self showSonView:tempView];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)initHttpInfo
{
    [jobControl initData];
    
}

@end
