//
//  ResumeModel.h
//  college
//
//  Created by xiongchi on 15/9/5.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResumeModel : NSObject

@property (nonatomic,copy) NSString *strName;
@property (nonatomic,copy) NSString *strBirthDay;
@property (nonatomic,copy) NSString *strSex;
@property (nonatomic,copy) NSString *strCard;
@property (nonatomic,copy) NSString *strMobile;
@property (nonatomic,copy) NSString *strEmail;
@property (nonatomic,copy) NSString *strAddress;
@property (nonatomic,copy) NSString *strTitle;
@property (nonatomic,copy) NSString *strJLId;
@property (nonatomic,copy) NSString *strCreateTime;
@property (nonatomic,copy) NSString *strUpdTime;
@property (nonatomic,copy) NSString *strEvaluation;

@property (nonatomic,strong) NSMutableArray *aryEduca;//
@property (nonatomic,strong) NSMutableArray *aryStuHor;//
@property (nonatomic,strong) NSMutableArray *aryLang;
@property (nonatomic,strong) NSMutableArray *aryTrain;//
@property (nonatomic,strong) NSMutableArray *aryTrueJob;


-(id)initWithDict:(NSDictionary *)dict;

@end

@interface XEducation : NSObject

@property (nonatomic,copy) NSString *strStart;
@property (nonatomic,copy) NSString *strEnd;
@property (nonatomic,copy) NSString *strSchool;
@property (nonatomic,copy) NSString *strZhuanye;
@property (nonatomic,strong) NSString *strLevel;

-(id)initWithDict:(NSDictionary *)dict;

@end

@interface XStuHor : NSObject

@property (nonatomic,copy) NSString *strTime;
@property (nonatomic,copy) NSString *strName;
@property (nonatomic,copy) NSString *strLevel;

-(id)initWithDict:(NSDictionary *)dict;

@end

@interface XTrain : NSObject

@property (nonatomic,copy) NSString *strTime;
@property (nonatomic,copy) NSString *strCompany;
@property (nonatomic,copy) NSString *strZhengshu;
@property (nonatomic,copy) NSString *strAddress;
@property (nonatomic,copy) NSString *strKecheng;

-(id)initWithDict:(NSDictionary *)dict;

@end

@interface XTrueJob : NSObject

@property (nonatomic,copy) NSString *strTime;
@property (nonatomic,copy) NSString *strCompany;
@property (nonatomic,copy) NSString *strZhiwei;
@property (nonatomic,copy) NSString *strAddress;
@property (nonatomic,copy) NSString *strContent;

-(id)initWithDict:(NSDictionary *)dict;

@end

@interface XLanguage : NSObject

@property (nonatomic,copy) NSString *strType;
@property (nonatomic,copy) NSString *strHear;
@property (nonatomic,copy) NSString *strChengdu;
@property (nonatomic,copy) NSString *strWrite;
@property (nonatomic,copy) NSString *strLevel;

-(id)initWithDict:(NSDictionary *)dict;

@end