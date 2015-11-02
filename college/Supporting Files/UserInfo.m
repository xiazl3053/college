//
//  UserInfo.m
//  college
//
//  Created by xiongchi on 15/9/1.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

DEFINE_SINGLETON_FOR_CLASS(UserInfo)

-(void)setUserDict:(NSDictionary *)dict
{
    
    _strMobile = [dict objectForKey:@"mobile"];
    _strPwd = [dict objectForKey:@"password"];
    _strUserId = [dict objectForKey:@"userid"];
    _strNickName = [dict objectForKey:@"nickname"];
    _strSchool = [dict objectForKey:@"organization"];
    
}

@end
