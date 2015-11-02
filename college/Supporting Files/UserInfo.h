//
//  UserInfo.h
//  college
//
//  Created by xiongchi on 15/9/1.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

DEFINE_SINGLETON_FOR_HEADER(UserInfo)

-(void)setUserDict:(NSDictionary *)dict;

@property (nonatomic,strong) NSMutableArray *aryResume;
@property (nonatomic,copy) NSString *strMobile;
@property (nonatomic,copy) NSString *strPwd;
@property (nonatomic,copy) NSString *strToken;
@property (nonatomic,copy) NSString *strUserId;
@property (nonatomic,copy) NSString *strJianliId;
@property (nonatomic,copy) NSString *strNickName;
@property (nonatomic,copy) NSString *strName;
@property (nonatomic,copy) NSString *strSchool;

@end
