//
//  BBSModel.m
//  college
//
//  Created by xiongchi on 15/9/9.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "BBSModel.h"

@implementation BBSModel

-(id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    _strUserId = [dict objectForKey:@"userid"];
    _strTitile = [dict objectForKey:@"title"];
    _strContent = [dict objectForKey:@"content"];
    _strRePly = [dict objectForKey:@"replynumber"]==nil ? @"0" : [dict objectForKey:@"replynumber"];
    _strClickNum = [dict objectForKey:@"clicknumber"]==nil?@"0":[dict objectForKey:@"clicknumber"];
    _strBBSId = [dict objectForKey:@"bbsid"];
    _strType = [dict objectForKey:@"type"];
    _strImg = [dict objectForKey:@"pictures"];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [fmt setLocale:usLocale];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
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
    
    return self;
}

@end
