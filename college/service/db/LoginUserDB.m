//
//  LoginUserDB.m
//  FreeIp
//
//  Created by 夏钟林 on 15/3/18.
//  Copyright (c) 2015年 xiazl. All rights reserved.
//

#import "LoginUserDB.h"
#import "UserModel.h"
#import "UtilsMacro.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#define kDataLoginPath [kDocumentPath stringByAppendingPathComponent:@"lepat.db"]
@implementation LoginUserDB
+(FMDatabase *)initDatabaseUser
{
    FMDatabase *db= [FMDatabase databaseWithPath:kDataLoginPath];
    if(![db open])
    {
        DLog(@"open fail");
    }
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS userInfo (id integer primary key asc autoincrement, username text unique, pwd text,token text,nLogin number)"];
    
    return db;
}
+(BOOL)addLoginUser:(UserModel *)userModel
{
    //INSERT OR ignore
    NSString *strSql = @"insert or replace into userInfo (username,pwd,token,nLogin) values (?,?,?,?)";
    FMDatabase *db = [LoginUserDB initDatabaseUser];
    [db beginTransaction];
    BOOL bReturn = [db executeUpdate:strSql,userModel.strUser,userModel.strPwd];
    [db commit];
    [db close];
    return bReturn ;
}

+(BOOL)updateSaveInfo:(UserModel *)user
{
    NSString *strSql = @"insert or replace into userInfo (id,username,pwd,token,nLogin) values (1,?,?,?,?);";
    FMDatabase *db = [LoginUserDB initDatabaseUser];
    [db beginTransaction];
    BOOL bRetrun = [db executeUpdate:strSql,user.strUser,user.strPwd,user.strToken,[NSNumber numberWithInt:user.nLogin]];
    [db commit];
    [db close];
    return bRetrun;
}

+(UserModel*)querySaveInfo
{
    
    NSString *strSql = @"select * from userInfo";
    FMDatabase *db = [LoginUserDB initDatabaseUser];
    FMResultSet *rs = [db executeQuery:strSql];
    if (rs.next)
    {
        //username,pwd,token,nLogin
        UserModel *user = [[UserModel alloc] init];
        user.strUser = [rs stringForColumn:@"username"];
        user.strPwd = [rs stringForColumn:@"pwd"];
        user.strToken = [rs stringForColumn:@"token"];
        user.nLogin = [[rs stringForColumn:@"nLogin"] intValue];
        return user;
    }
    return nil;
}

+(NSString*)querySaveInfo:(int *)nSave login:(int *)nLogin
{
    NSString *strSql = @"select * from userInfo";
    FMDatabase *db = [LoginUserDB initDatabaseUser];
    FMResultSet *rs = [db executeQuery:strSql];
    if(rs.next)
    {
        *nSave = [[rs stringForColumn:@"save"] intValue];
        *nLogin = [[rs stringForColumn:@"login"] intValue];
        
        NSString *strUserName = [[NSString alloc] initWithString:[rs stringForColumn:@"username"]];
        [rs close];
        [db close];
        return strUserName;
    }
    return nil;
}

+(NSString*)queryUserPwd:(NSString *)strUser
{
    NSString *strSql = @"select * from userInfo where username = ?";
    FMDatabase *db = [LoginUserDB initDatabaseUser];
    FMResultSet *rs = [db executeQuery:strSql,strUser];
    if (rs.next)
    {
        if (![[rs stringForColumn:@"pwd"] isEqualToString:@""]) {
             NSString *strPwd = [NSString stringWithString:[rs stringForColumn:@"pwd"]];
             return strPwd;
        }
        else
        {
            return @"";
        }
    }
    return nil;
}

@end
