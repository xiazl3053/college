//
//  AppDelegate.m
//  college
//
//  Created by xiongchi on 15/7/16.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "AppDelegate.h"
#import "WWSideslipViewController.h"
#import "UserInfo.h"
#import "UserModel.h"
#import "LoginUserDB.h"
#import "LeftViewController.h"
#import "MainViewController.h"
#import "IndexViewController.h"
#import "IQKeyboardManager.h"
#import "LoginViewController.h"

@interface AppDelegate ()

{
    WWSideslipViewController *_sider;
    LeftViewController *leftView;
    IndexViewController *indexView;
}

@end

@implementation AppDelegate

-(void)setLeftRoorView
{
    [_window setRootViewController:leftView];
}

-(void)setMainRootView
{
    if (_sider==nil)
    {
        leftView = [[LeftViewController alloc] init];
        indexView = [[IndexViewController alloc] init];
        _sider = [[WWSideslipViewController alloc] initWithLeftView:leftView andMainView:indexView andRightView:nil andBackgroundImage:nil];
    }
    else
    {
        [leftView getAllResume];
        [indexView initHttpInfo];
    }
    [_window setRootViewController:_sider];
}

-(void)showLeftView
{
    [_sider showLeftView];
}

-(void)showLoginView
{
    LoginViewController *loginView = [[LoginViewController alloc] init];
    [_window setRootViewController:loginView];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [_window setBackgroundColor:RGB(255, 255, 255)];
    
    [_window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UserModel *user = [LoginUserDB querySaveInfo];
    if (user.nLogin)
    {
        [UserInfo sharedUserInfo].strToken = user.strToken;
        [UserInfo sharedUserInfo].strUserId = user.strUser;
        [UserInfo sharedUserInfo].strPwd = user.strPwd;
        [self setMainRootView];
    }
    else
    {
        LoginViewController *loginView = [[LoginViewController alloc] init];
        [_window setRootViewController:loginView];
    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
