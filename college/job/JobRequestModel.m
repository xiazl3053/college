//
//  JobRequestModel.m
//  college
//
//  Created by xiongchi on 15/9/3.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "JobRequestModel.h"

@implementation JobRequestModel


-(id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
   /*
    
@property (nonatomic,assign) int nRequestId;
@property (nonatomic,assign) int nJobId;
@property (nonatomic,assign) int nUserId;
@property (nonatomic,assign) int nJianliId;
@property (nonatomic,copy) NSString *strDate;
@property (nonatomic,assign) BOOL bStatus;
    */
    _nUserId = [[dict objectForKey:@"userid"] intValue];
    
    _nJianliId = [[dict objectForKey:@"jianliid"] intValue];
    
    
    
    return self;
}


@end
