//
//  AddStuHorViewController.h
//  college
//
//  Created by xiongchi on 15/9/6.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "CustomViewController.h"

@class XStuHor;
@class  ResumeModel;
@interface AddStuHorViewController : CustomViewController

-(id)initWithModel:(XStuHor *)model;

-(id)initWithAdd:(ResumeModel *)model;

@end
