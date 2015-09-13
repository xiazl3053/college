//
//  AddEvalutionViewController.h
//  college
//
//  Created by xiongchi on 15/9/6.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "CustomViewController.h"

@class ResumeModel;
@class XEducation;

@interface AddEvalutionViewController : CustomViewController

-(id)initWithModel:(XEducation*)model;

-(id)initWithAdd:(ResumeModel *)model;

@end
