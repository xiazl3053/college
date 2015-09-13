//
//  RsMeTxtCell.h
//  college
//
//  Created by xiongchi on 15/9/4.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RsMeTxtCell : UITableViewCell

@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,strong) UITextField *txtName;

-(void)setLineFull;

@end
