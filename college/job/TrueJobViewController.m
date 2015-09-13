//
//  TrueJobViewController.m
//  college
//
//  Created by xiongchi on 15/9/6.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "TrueJobViewController.h"
#import "ResumeModel.h"
#import "AddTrueJobViewController.h"
#import "UserInfo.h"
#import "BaseService.h"
#import "StudentViewCell.h"

@interface TrueJobViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) ResumeModel *model;

@end

@implementation TrueJobViewController

-(id)initWithModel:(ResumeModel *)model
{
    self = [super init];
    
    _model = model;
    
    return self;
}

-(void)updateEducation
{
    NSString *strInfo = [NSString stringWithFormat:@"%@pub/updateJianLi?token=%@&",KHttpServer,[UserInfo sharedUserInfo].strToken];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_model.strJLId forKey:@"jianliid"];
    [dict setValue:[UserInfo sharedUserInfo].strUserId forKey:@"userid"];
    NSMutableArray *array = [NSMutableArray array];
    for (XTrueJob *stuhor in _model.aryTrueJob)
    {
        NSDictionary *dict = @{@"time":stuhor.strTime,@"company":stuhor.strCompany,@"zhiwei":stuhor.strZhiwei,
                               @"address":(stuhor.strAddress==nil)?@"":stuhor.strAddress,
                               @"miaoshu":(stuhor.strContent==nil)?@"":stuhor.strContent};
        [array addObject:dict];
    }
    [dict setValue:array forKey:@"_experience"];
    [BaseService postJSONWithUrl:strInfo parameters:dict success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
    }
                            fail:^(NSError *error)
     {
         
     }];
}

-(void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addEducation
{
    AddTrueJobViewController *addView = [[AddTrueJobViewController alloc] initWithAdd:_model];
    
    [self presentViewController:addView animated:YES completion:nil];
}
-(void)updateLoad
{
    __weak TrueJobViewController *__self = self;
    if ([NSThread isMainThread])
    {
        [_tableView reloadData];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [__self.tableView reloadData];
                       });
    }
    dispatch_async(dispatch_get_global_queue(0, 0),
                   ^{
                       [__self updateEducation];
                   });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLoad) name:MESSAGE_FOR_TRUEJOB_VC object:nil];
    
    [self setTitleText:@"实践经历"];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateHighlighted];
    
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftBtn:btnBack];
    
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnSave setTitle:@"编辑" forState:UIControlStateNormal];
    
    [btnSave setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    
    [btnSave setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
    
    btnSave.titleLabel.font = XFONT(12);
    
    [btnSave addTarget:self action:@selector(addEducation) forControlEvents:UIControlEventTouchUpInside];
    
    [self setRightBtn:btnSave];
    
    
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 74, kScreenSourchWidth, kScreenSourchHeight-64)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    UIView *headView = [[UIView alloc] initWithFrame:Rect(0,0, kScreenSourchWidth,45)];
    
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [headView addSubview:btnAdd];
    
    btnAdd.frame = Rect(10, 0, kScreenSourchWidth-20, 40);
    
    [btnAdd setTitle:@"+ 添加实践经历" forState:UIControlStateNormal];
    
    [btnAdd setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    
    [btnAdd setTitleColor:RGB(255, 255, 255) forState:UIControlStateHighlighted];
    
    [btnAdd addTarget:self action:@selector(addEducation) forControlEvents:UIControlEventTouchUpInside];
    
    btnAdd.titleLabel.font = XFONT(12);
    
    [btnAdd.layer setMasksToBounds:YES];
    [btnAdd.layer setCornerRadius:2.0];
    [btnAdd.layer setBorderWidth:1];
    [btnAdd.layer setBorderColor:MAIN_COLOR.CGColor];
    
    [_tableView setTableHeaderView:headView];
    
    if (_model.aryTrueJob==nil)
    {
        _model.aryTrueJob = [NSMutableArray array];
        
    }
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 44.0, kScreenSourchWidth, 0.4)];
    line1.backgroundColor = LINE_COLOR;
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 44.4, kScreenSourchWidth ,0.4)] ;
    line2.backgroundColor = [UIColor whiteColor];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [headView addSubview:line1];
    [headView addSubview:line2];
    
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.aryTrueJob.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *strStudentViewIdentifier = @"kSTUHORVIEWIDENTIFIER";
    StudentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strStudentViewIdentifier];
    
    if (cell==nil)
    {
        cell = [[StudentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strStudentViewIdentifier];
    }
    
    XTrueJob *edu = [_model.aryTrueJob objectAtIndex:indexPath.row];
    
    [cell.lblSchool setText:edu.strZhiwei];
    [cell.lblTime setText:edu.strTime];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XTrueJob *eduModel = [_model.aryTrueJob objectAtIndex:indexPath.row];
    AddTrueJobViewController *addView = [[AddTrueJobViewController alloc] initWithModel:eduModel];
    [self presentViewController:addView animated:YES completion:nil];
}

@end
