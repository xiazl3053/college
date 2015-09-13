//
//  NewModel.h
//  college
//
//  Created by xiongchi on 15/8/26.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewModel : NSObject

@property (nonatomic,copy) NSString *strTitle;
@property (nonatomic,copy) NSString *strContent;
@property (nonatomic,copy) NSString *strDate;

-(id)initWithItem:(NSArray *)item;

@end
