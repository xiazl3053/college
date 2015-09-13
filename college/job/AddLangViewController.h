//
//  AddLangViewController.h
//  college
//
//  Created by xiongchi on 15/9/6.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "CustomViewController.h"

@class XLanguage;
@class  ResumeModel;

@interface AddLangViewController : CustomViewController

-(id)initWithModel:(XLanguage *)model;

-(id)initWithAdd:(ResumeModel *)model;
@end
