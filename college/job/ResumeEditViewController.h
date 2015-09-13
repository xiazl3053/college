//
//  ResumeEditViewController.h
//  college
//
//  Created by xiongchi on 15/9/5.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "CustomViewController.h"

@class ResumeModel;

@interface ResumeEditViewController : CustomViewController

-(id)initWithModel:(ResumeModel *)model;

-(id)initWithNewModel:(ResumeModel *)model;

@end
