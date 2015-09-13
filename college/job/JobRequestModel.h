//
//  JobRequestModel.h
//  college
//
//  Created by xiongchi on 15/9/3.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobRequestModel : NSObject

//id,兼职表id,发布人id,申请人id，简历id,申请时间,状态

@property (nonatomic,assign) int nRequestId;
@property (nonatomic,assign) int nJobId;
@property (nonatomic,assign) int nUserId;
@property (nonatomic,assign) int nJianliId;
@property (nonatomic,copy) NSString *strDate;
@property (nonatomic,assign) BOOL bStatus;

-(id)initWithDict:(NSDictionary *)dict;


@end
