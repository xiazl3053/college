//
//  PlayJoinModel.h
//  college
//
//  Created by xiongchi on 15/9/3.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayJoinModel : NSObject

//发布人id
//参与人id
//支付金额
//支付状态
//支付方式
//手续费
//状态
@property (nonatomic,copy) NSString *strInfo;
@property (nonatomic,assign) BOOL bStatus;
@property (nonatomic,assign) CGFloat fCost;
@property (nonatomic,assign) int nCreateId;
@property (nonatomic,assign) int nCostId;
@property (nonatomic,assign) CGFloat fPrice;

-(id)initWithDict:(NSDictionary *)dict;

@end
