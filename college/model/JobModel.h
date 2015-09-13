//
//  JobModel.h
//  college
//
//  Created by xiongchi on 15/8/26.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobModel : NSObject

@property (nonatomic,copy) NSString *strTitle;//职位名称

@property (nonatomic,copy) NSString *strJobTime;//工作时间

@property (nonatomic,assign) CGFloat fPrice;

@property (nonatomic,copy) NSString *strPrice;//薪资

@property (nonatomic,copy) NSString *strDate;//创建日期

@property (nonatomic,copy) NSString *strContent;//职位描述

@property (nonatomic,copy) NSString *strJZId;//兼职id

@property (nonatomic,copy) NSString *strCompany;//公司

@property (nonatomic,copy) NSString *strAddress;//地址

@property (nonatomic,copy) NSString *strUserId;//兼职发布者id

@property (nonatomic,copy) NSString *strStauts;//任职要求

-(id)initWithItem:(NSArray *)item;

-(id)initWIthDict:(NSDictionary *)dict;


@end
