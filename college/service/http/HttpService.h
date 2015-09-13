//
//  HttpService.h
//  college
//
//  Created by xiongchi on 15/8/30.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpService : NSObject
-(void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)())fail;
@end
