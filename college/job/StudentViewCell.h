//
//  StudentViewCell.h
//  college
//
//  Created by xiongchi on 15/9/6.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XEducation;

@interface StudentViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *lblSchool;
@property (nonatomic,strong) UILabel *lblTime;

-(void)setModel:(XEducation *)edu;

@end
