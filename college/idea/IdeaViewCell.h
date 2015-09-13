//
//  IdeaViewCell.h
//  college
//
//  Created by xiongchi on 15/9/10.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IdeaModel;
@interface IdeaViewCell : UITableViewCell

-(void)setModel:(IdeaModel *)model;
-(void)setLineFull;
@end
