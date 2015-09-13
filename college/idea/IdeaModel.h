//
//  IdeaModel.h
//  college
//
//  Created by xiongchi on 15/9/10.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdeaModel : NSObject

@property (nonatomic,copy) NSString *strCreateTime;
@property (nonatomic,copy) NSString *strUpdateTime;
@property (nonatomic,copy) NSString *strTitle;
@property (nonatomic,copy) NSString *strContent;
@property (nonatomic,copy) NSString *strIntrol;
@property (nonatomic,copy) NSString *strNick;
@property (nonatomic,copy) NSString *strUserId;
@property (nonatomic,copy) NSString *strCost;
@property (nonatomic,copy) NSString *strAssess;
@property (nonatomic,copy) NSString *strNumber;


-(id)initWitkhDict:(NSDictionary *)dict;

@end
