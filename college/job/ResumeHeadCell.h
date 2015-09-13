//
//  ResumeHeadCell.h
//  college
//
//  Created by xiongchi on 15/9/5.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResumeHeadDelegate;

@class ResumeModel;

@interface ResumeHeadCell : UITableViewCell

@property (nonatomic,strong) ResumeModel *model;
@property (nonatomic,assign) id<ResumeHeadDelegate> delegate;


-(void)setResumeInfo:(ResumeModel *)model;

@end

@protocol ResumeHeadDelegate <NSObject>

-(void)resumeEdit:(ResumeModel *)model;
-(void)resumeDelete:(ResumeModel *)model;

@end