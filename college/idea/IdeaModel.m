//
//  IdeaModel.m
//  college
//
//  Created by xiongchi on 15/9/10.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "IdeaModel.h"

@implementation IdeaModel

-(id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    _strIdeaId = [dict objectForKey:@"ideaid"];
    
    _strUserId = [dict objectForKey:@"userid"];
    _strTitle = [dict objectForKey:@"title"];
    _strContent = [dict objectForKey:@"content"];
//    _strRePly = [dict objectForKey:@"replay"];
//    _strClickNum = [dict objectForKey:@""];
    _strCost = [dict objectForKey:@"price"];
//    _strAllNum = [dict objectForKey:@""];
//    _strTeachId = [dict objectForKey:@"id"];
    _strIntrol = [dict objectForKey:@"jieshao"] ? [dict objectForKey:@"jieshao"] : @"";
//    _strIntrol = [dict objectForKey:@""];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [fmt setLocale:usLocale];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    long lCreateTime = (long)[[dict objectForKey:@"createtime"] doubleValue]/1000;
    NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:lCreateTime];
    _strCreateTime = [fmt stringFromDate:createTime];
    
    long lUpdateTime = (long)[[dict objectForKey:@"updatetime"] doubleValue]/1000;
    NSDate *updateTime = [NSDate dateWithTimeIntervalSince1970:lUpdateTime];
    _strUpdateTime = [fmt stringFromDate:updateTime];
    
    NSDictionary *userDict = [dict objectForKey:@"user"];
    if (userDict)
    {
        _strNick = [userDict objectForKey:@"nickname"];
    }
    
    _strImg = [dict objectForKey:@"pictures"];
    
    _strSell = [dict objectForKey:@"sellstatus"]?[dict objectForKey:@"sellstatus"]:@"N";
    
    return self;
}

@end
