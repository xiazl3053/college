//
//  XImageView.h
//  college
//
//  Created by xiongchi on 15/9/13.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XImageView : UIView

@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UIImageView *imgView;

-(void)addTouchEvent:(void(^)())handle;

@end
