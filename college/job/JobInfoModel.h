//
//  JobInfoModel.h
//  college
//
//  Created by xiongchi on 15/8/28.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobInfoModel : NSObject


//id,发布人id,发布时间,过期时间,更新时间,是否过期,兼职工作名称
//职位标签,公司名称,工作地点,薪资.工作时间,招聘人数,职位描述,状态

@property (nonatomic,assign) int nJobId;
@property (nonatomic,assign) int nCreateId;
@property (nonatomic,copy) NSString *strJobName;//兼职工作名称
@property (nonatomic,copy) NSString *strCompany;//公司名称
@property (nonatomic,copy) NSString *strCreateTime;//发布日期
@property (nonatomic,copy) NSString *strAddress;//工作地址
@property (nonatomic,copy) NSString *strJobTime;//工作时间
@property (nonatomic,copy) NSString *strPrice;//薪资
@property (nonatomic,copy) NSString *strContent;//职位描述

-(id)initWithItems:(NSArray *)items;

-(id)initWithDict:(NSDictionary *)dict;

@end
