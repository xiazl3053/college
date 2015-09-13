//
//  XViewTextField.h
//  college
//
//  Created by xiongchi on 15/9/8.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XViewTextField : UIView

@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UITextField *txtContent;

-(void)AddEvent;
-(void)addLineView;

@end
