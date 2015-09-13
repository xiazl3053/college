//
//  PlayModel.m
//  college
//
//  Created by xiongchi on 15/8/26.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "PlayModel.h"

@implementation PlayModel

-(id)initWithItem:(NSArray *)item
{
    self = [super init];
    
    _strTitle = item[0];
    _strContent = item[1];
    _strAddress = item[2];
    _strPartyTime = item[3];
    
    return self;
}
//{"status":200,"msg":"检索活动成功","list":[{"partyid":3,"userid":4,"createtime":1441354661000,"updatetime":1441354661000,"title":"周末假面舞会","address":"XX广场","cost":"无","partytime":"本周六晚7点-9点","people":0,"tag":"舞会"}]}

-(id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    _strTitle = [dict objectForKey:@"title"];
    _strPrice = [dict objectForKey:@"cost"];
//    _strPartyTime = [dict objectForKey:@""];
    _strAddress = [dict objectForKey:@"address"];
    _strContent = [dict objectForKey:@"content"];
    _strPartyid = [dict objectForKey:@"partyid"];
    _strNumber = [dict objectForKey:@"people"];
    _strUserid = [dict objectForKey:@"userid"];
    
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
    
    long partyTime = (long)[[dict objectForKey:@"partytime"] doubleValue]/1000;
    NSDate *partyDate = [NSDate dateWithTimeIntervalSince1970:partyTime];
    _strPartyTime = [fmt stringFromDate:partyDate];
    
    _strImg = [dict objectForKey:@"pictures"];
    _strPartyid = [dict objectForKey:@"partyid"];
    
    return self;
}

@end
