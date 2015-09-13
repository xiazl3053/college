//
//  JobModel.m
//  college
//
//  Created by xiongchi on 15/8/26.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "JobModel.h"

@implementation JobModel

-(id)initWithItem:(NSArray *)item
{
    self = [super init];
    
    _strTitle = item[0];
    _strJobTime = item[1];
    _fPrice = [item[2] floatValue];
    _strDate = item[3];
    
    return self;
}

-(id)initWIthDict:(NSDictionary *)dict
{
    self = [self  init];
    
    _strTitle = [dict objectForKey:@"title"];
    
//    if([dict objectForKey:@"updatetime"])
//    {
        
//    }
//    _strJobTime = [dict objectForKey:@""];
    
    _strJobTime = @"周末";
    
    if([dict objectForKey:@"price"]==nil)
    {
        _strPrice = @"面谈";
    }
    else
    {
        _strPrice = [dict objectForKey:@"price"];
    }
    
    if ([dict objectForKey:@"company"]==nil)
    {
        _strCompany = @"个人";
    }
    else
    {
        _strCompany = [dict objectForKey:@"company"];
    }
    
    if ([dict objectForKey:@"address"]==nil)
    {
        _strAddress = @"大地";
    }
    else
    {
        _strAddress = [dict objectForKey:@"address"];
    }
    
    _strUserId = [dict objectForKey:@"userid"];
    
    CGFloat fTIme = [[dict objectForKey:@"createtime"] floatValue]/1000;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:fTIme];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    [format setLocale:usLocale];
    
    format.dateFormat = @"yyyy-MM-dd";
    
    _strDate = [format stringFromDate:date];
    
    _strJZId = [dict objectForKey:@"jianzhiid"];
    
    return self;
}

@end
