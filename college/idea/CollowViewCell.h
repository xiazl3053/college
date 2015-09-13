//
//  CollwViewCell.h
//  college
//
//  Created by xiongchi on 15/9/10.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollowModel;
@interface CollowViewCell : UITableViewCell

-(void)setModel:(CollowModel*)model;
-(void)setLineFull;
@end
