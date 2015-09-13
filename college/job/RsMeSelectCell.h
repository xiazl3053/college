//
//  RsMeSelectCell.h
//  college
//
//  Created by xiongchi on 15/9/5.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RsMeSelectCell : UITableViewCell

@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,strong) UITextField *txtName;

-(void)setLineFull;

@end
