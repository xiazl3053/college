//
//  AddTrueJobViewController.h
//  college
//
//  Created by xiongchi on 15/9/6.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "CustomViewController.h"
@class XTrueJob;
@class  ResumeModel;
@interface AddTrueJobViewController : CustomViewController

-(id)initWithModel:(XTrueJob *)model;

-(id)initWithAdd:(ResumeModel *)model;
@end
