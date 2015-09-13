//
//  ResumeModel.m
//  college
//
//  Created by xiongchi on 15/9/5.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "ResumeModel.h"

@implementation ResumeModel


-(id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    _strName = [dict objectForKey:@"name"];
    _strAddress = [dict objectForKey:@"address"];
    _strCard = [dict objectForKey:@"card"];
    _strEmail = [dict objectForKey:@"email"];
    _strTitle = [dict objectForKey:@"title"];
    _strMobile = [dict objectForKey:@"mobile"];
    _strJLId = [dict objectForKey:@"jianliid"];
    _strSex = [[dict objectForKey:@"sex"] isEqualToString:@"1"] ? @"男" : @"女";
    _strEvaluation = [dict objectForKey:@"evaluation"];
    long nTime = (long)[[dict objectForKey:@"birthdate"] doubleValue]/1000;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:nTime];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [fmt setLocale:usLocale];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    _strBirthDay = [fmt stringFromDate:date];
    
    long lCreateTime = (long)[[dict objectForKey:@"createtime"] doubleValue]/1000;
    NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:lCreateTime];
    _strCreateTime = [fmt stringFromDate:createTime];
    
    long lUpdateTime = (long)[[dict objectForKey:@"updatetime"] doubleValue]/1000;
    NSDate *updateTime = [NSDate dateWithTimeIntervalSince1970:lUpdateTime];
    _strUpdTime = [fmt stringFromDate:updateTime];
    
    _aryEduca = [NSMutableArray array];
    
    if ([dict objectForKey:@"_education"]!=nil)
    {
        NSArray *ary = [dict objectForKey:@"_education"];
        
        for (NSDictionary *dictEdu in ary)
        {
            XEducation *eduId = [[XEducation alloc] initWithDict:dictEdu];
            [_aryEduca addObject:eduId];
        }
        
    }
    
    _aryStuHor = [NSMutableArray array];
    if ([dict objectForKey:@"_zhengshu"]!=nil)
    {
        NSArray *ary = [dict objectForKey:@"_zhengshu"];
        for (NSDictionary *dictHor in ary)
        {
            XStuHor *horId = [[XStuHor alloc] initWithDict:dictHor];
            [_aryStuHor addObject:horId];
        }
    }
    
    _aryTrain = [NSMutableArray array];
    if ([dict objectForKey:@"_train"]!=nil)
    {
        NSArray *ary = [dict objectForKey:@"_train"];
        for (NSDictionary *dictHor in ary)
        {
            XTrain *horId = [[XTrain alloc] initWithDict:dictHor];
            [_aryTrain addObject:horId];
        }
    }
    _aryTrueJob = [NSMutableArray array];
    if ([dict objectForKey:@"_experience"]!=nil)
    {
        NSArray *ary = [dict objectForKey:@"_experience"];
        for (NSDictionary *dictHor in ary)
        {
            XTrueJob *horId = [[XTrueJob alloc] initWithDict:dictHor];
            [_aryTrueJob addObject:horId];
        }
    }
    
    _aryLang = [NSMutableArray array];
    if ([dict objectForKey:@"_language"]!=nil)
    {
        NSArray *ary = [dict objectForKey:@"_language"];
        
        for (NSDictionary *dictHor in ary)
        {
            XLanguage *horId = [[XLanguage alloc] initWithDict:dictHor];
            [_aryLang addObject:horId];
        }
    }
    
    return self;
}

@end


@implementation XEducation

-(id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    NSString *strTime = [dict objectForKey:@"time"];
    
    NSArray *aryTime = [strTime componentsSeparatedByString:@"-"];
    
    _strStart = aryTime[0];
    _strEnd = aryTime[1];
    _strSchool = [dict objectForKey:@"school"];
    _strZhuanye = [dict objectForKey:@"zhuanye"];
    _strLevel = [dict objectForKey:@"xueli"];
    
    return self;
}

@end

@implementation XStuHor

-(id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    _strTime = [dict objectForKey:@"time"];
    _strName = [dict objectForKey:@"name"];
    _strLevel = [dict objectForKey:@"dengji"];
    
    return self;
}

@end

@implementation XTrain

-(id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    _strTime = [dict objectForKey:@"time"];
    _strCompany = [dict objectForKey:@"company"];
    _strKecheng = [dict objectForKey:@"kecheng"];
    _strAddress = [dict objectForKey:@"address"];
    _strZhengshu = [dict objectForKey:@"zhengshu"];
    
    return self;
}

@end

@implementation XTrueJob

-(id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    _strTime = [dict objectForKey:@"time"];
    _strCompany = [dict objectForKey:@"company"];
    _strZhiwei = [dict objectForKey:@"zhiwei"];
    _strAddress = [dict objectForKey:@"address"];
    _strContent = [dict objectForKey:@"miaoshu"];
    
    return self;
}

@end

@implementation XLanguage

-(id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    _strChengdu = [dict objectForKey:@"chengdu"];
    _strType = [dict objectForKey:@"zhonglei"];
    _strLevel = [dict objectForKey:@"dengji"];
    _strWrite = [dict objectForKey:@"duxie"];
    _strHear = [dict objectForKey:@"tingshuo"];
    
    return self;
}

@end