//
//  XContentViewController.h
//  college
//
//  Created by xiongchi on 15/9/11.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "CustomViewController.h"

typedef void(^XControlBackString)(NSString *strInfo);

@interface XContentViewController : CustomViewController

-(id)initWithTitle:(NSString *)strTitle content:(NSString *)strContent;

-(void)setContent:(NSString *)strInfo;

@property (nonatomic,copy) XControlBackString stringBlock;

@end
