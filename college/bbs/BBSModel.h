//
//  BBSModel.h
//  college
//
//  Created by xiongchi on 15/9/9.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSModel : NSObject

-(id)initWithDict:(NSDictionary *)dict;

@property(nonatomic,copy) NSString *strUserId;
@property (nonatomic,copy) NSString *strCreateTime;
@property (nonatomic,copy) NSString *strUpdateTime;
@property (nonatomic,copy) NSString *strTitile;
@property (nonatomic,copy) NSString *strCost;
@property (nonatomic,copy) NSString *strContent;
@property (nonatomic,copy) NSString *strRePly;
@property (nonatomic,copy) NSString *strClickNum;
@property (nonatomic,copy) NSString *strBBSId;
@property (nonatomic,copy) NSString *strNick;
@property (nonatomic,copy) NSString *strType;
@property (nonatomic,copy) NSString *strImg;

@end
