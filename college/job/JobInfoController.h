//
//  JobInfoController.h
//  college
//
//  Created by xiongchi on 15/8/27.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "CustomViewController.h"

@class  JobModel;
@interface JobInfoController : CustomViewController

-(id)initWIthJZId:(int)nId;

-(id)initWIthModel:(JobModel *)jobModel;

@end
