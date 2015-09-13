//
//  BBSViewController.m
//  college
//
//  Created by xiongchi on 15/9/13.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "BBSViewController.h"
#import "BBSModel.h"

@interface BBSViewController ()
{
    
}
@property (nonatomic,strong) BBSModel *model;
@end

@implementation BBSViewController

-(id)initWithModel:(BBSModel *)model
{
    self = [super init];
    _model = model;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
