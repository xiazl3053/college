//
//  LeftViewController.h
//  college
//
//  Created by xiongchi on 15/7/16.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "CustomViewController.h"
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface LeftViewController : UIViewController

@property (strong, readonly, nonatomic) RESideMenu *sideMenu;

-(void)getAllResume;

@end

@interface LeftCellInfo : NSObject

-(id)initWithTitle:(NSString *)strTitle normal:(NSString *)strNormal;

@property (nonatomic,copy) NSString *strNorImg;
@property (nonatomic,copy) NSString *strTitle;

@end