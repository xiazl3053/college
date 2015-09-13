//
//  XCollTab.h
//  college
//
//  Created by xiongchi on 15/8/26.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XCollTabDelegate <NSObject>

-(void)clickView:(UIButton*)btnSender index:(int)nIndex;

@end

@interface XCollTab : UIView
@property (nonatomic,assign) id<XCollTabDelegate> delegate;

-(id)initWithArrayItem:(NSArray *)item frame:(CGRect)srcFrame;


-(void)clickIndex:(int)nIndex;

@end

@interface XCOLLInfo : NSObject

@property (nonatomic,copy) NSString *strNorImg;
@property (nonatomic,copy) NSString *strSelectImg;
@property (nonatomic,copy) NSString *strHighImg;
@property (nonatomic,copy) NSString *strTitle;

-(id)initWithItem:(NSArray*)item;

@end