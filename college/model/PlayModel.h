//
//  PlayModel.h
//  college
//
//  Created by xiongchi on 15/8/26.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayModel : NSObject

//id,名称，地址，发布时间，过期时间
//发布人id
//消费:AA,免费,金钱
//活动介绍,活动时间,可参与人数,参与人支付金额
//图片集
//{"status":200,"msg":"检索活动成功","list":[{"partyid":3,"userid":4,"createtime":1441354661000,"updatetime":1441354661000,"title":"周末假面舞会","address":"XX广场","cost":"无","partytime":"本周六晚7点-9点","people":0,"tag":"舞会"}]}

//@property (nonatomic,copy) 
@property (nonatomic,copy) NSString *strFile;
@property (nonatomic,copy) NSString *strTitle; // 名称
@property (nonatomic,copy) NSString *strContent; // 活动介绍
@property (nonatomic,copy) NSString *strPartyTime;   //活动时间
@property (nonatomic,copy) NSString *strAddress; //活动地址
@property (nonatomic,copy) NSString *strPrice;
@property (nonatomic,copy) NSString *strCreateTime;
@property (nonatomic,copy) NSString *strNumber;
@property (nonatomic,assign) int nCreateId;
@property (nonatomic,copy) NSString *strPartyid;
@property (nonatomic,copy) NSString *strUserid;
@property (nonatomic,copy) NSString *strUpdateTime;
@property (nonatomic,copy) NSString *strImg;

-(id)initWithItem:(NSArray *)item;

-(id)initWithDict:(NSDictionary *)dict;

@end
