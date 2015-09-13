//
//  XTextViewController.h
//  college
//
//  Created by xiongchi on 15/9/12.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "CustomViewController.h"

typedef void(^XTextInfo)(NSString *strInfo,NSArray *arrary);

@interface XTextViewController : CustomViewController

-(id)initWithTitle:(NSString *)strTitle content:(NSString *)strContent ary:(NSArray *)array;

-(void)setContent:(NSString *)strInfo;

@property (nonatomic,copy) XTextInfo blockText;

@end
