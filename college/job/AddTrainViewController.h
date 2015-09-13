//
//  AddTrainViewController.h
//  college
//
//  Created by xiongchi on 15/9/6.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "CustomViewController.h"

@class ResumeModel;
@class XTrain;
@interface AddTrainViewController : CustomViewController


-(id)initWithModel:(XTrain *)model;

-(id)initWithAdd:(ResumeModel *)model;

@end
