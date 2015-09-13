//
//  LoginUserDB.h
//  FreeIp
//
//  Created by 夏钟林 on 15/3/18.
//  Copyright (c) 2015年 xiazl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;
@interface LoginUserDB : NSObject


+(BOOL)addLoginUser:(UserModel*)userModel;

+(UserModel*)querySaveInfo;
+(NSString*)queryUserPwd:(NSString *)strUser;

+(BOOL)updateSaveInfo:(UserModel *)user;


@end
