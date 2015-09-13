//
//  JobInfoModel.m
//  college
//
//  Created by xiongchi on 15/8/28.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "JobInfoModel.h"

@implementation JobInfoModel

-(id)initWithItems:(NSArray *)items
{
    self = [super init];
    
    _strJobName = items[0];
    _strCompany = items[1];
    _strAddress = items[2];
    _strCreateTime = items[3];
    _strJobTime = items[4];
    _strPrice = items[5];
    _strContent = items[6];
    
    return self;
}

-(id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    
    
    
    
    
    
    return self;
}

@end
