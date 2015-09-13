//
//  NewModel.m
//  college
//
//  Created by xiongchi on 15/8/26.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "NewModel.h"

@implementation NewModel

-(id)initWithItem:(NSArray *)item
{
    self = [super init];
    
    _strTitle = item[0];
    _strContent = item[1];
    _strDate = item[2];
    
    return self;
}

@end
