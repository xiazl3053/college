//
//  JobViewCell.h
//  college
//
//  Created by xiongchi on 15/8/26.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JobModel.h"

@interface JobViewCell : UITableViewCell

-(void)setJobModel:(JobModel*)model;

-(void)setLineFull;

@end
