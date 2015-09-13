//
//  XRegField.m
//  college
//
//  Created by xiongchi on 15/8/22.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "XRegField.h"

@implementation XRegField

-(id)initWithFrame:(CGRect)frame imageName:(NSString *)strImg
{
    self = [super initWithFrame:frame];
   
    [self setBackgroundColor:RGB(255, 255, 255)];
    
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self setFont:XFONT(12)];
    
    [self setTextColor:RGB(0, 0, 0)];
    
    self.layer.borderColor = UIColorFromRGB(0x9eadb2).CGColor;
    
    self.layer.borderWidth = 0.5;
    
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:5.0f];
    
    UIView *leftView = [[UIView alloc] initWithFrame:Rect(0, 0, 45, 45)];
    
    UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:Rect(12, 12, 21, 21)];
    
    [leftView addSubview:imgLeft];
    
    [imgLeft setImage:[UIImage imageNamed:strImg]];
    
    self.leftView = leftView;
    
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    self.leftViewMode = UITextFieldViewModeAlways;
    
    self.keyboardType = UIKeyboardTypeDefault;
    
    return self;
}

@end
