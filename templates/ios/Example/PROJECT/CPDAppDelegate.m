//
//  CPDAppDelegate.m
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "CPDAppDelegate.h"
#import "CPDViewController.h"
#import <ZJModuleService/ZJModuleService.h>
#import <ZJAppConfig/ZJAppConfig.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface CPDAppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation CPDAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //设置 rootViewController
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self setupCommonRootViewController];
    
    
    
    return YES;
}


- (void)setupLoginRootViewController {
    
    [[ZJAppConfiguration sharedInstance] zj_setupTarget:ZJTargetTypeWPUser environment:ZJEnvironmentTypeDevelopment];
    
    if (![WPLoginManager wp_isUserLogin]) {
        UIViewController <WPLoginServiceProtocol>*loginController = [ZJServiceManager createServiceWithProtocol:@protocol(WPLoginServiceProtocol)];
        UINavigationController *nav;
        if (loginController) {
            nav = [[UINavigationController alloc] initWithRootViewController:loginController];
            self.window.rootViewController = nav;
        }
        [self.window makeKeyAndVisible];
    } else {
        [[ZJAppConfiguration sharedInstance] zj_setUserToken:[WPLoginManager wp_token]];
        [[ZJAppDelegateManager sharedInstance] trigger_applicationDidFinishLaunchingWithOptions:launchOptions];
        [self.window makeKeyAndVisible];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidLoginSuccess) name:kWPDidUserLoginSuccessNotification object:nil];
}

- (void)setupCommonRootViewController {
    //设置 rootViewController
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    CPDViewController *vc = [[CPDViewController alloc] init];
    UINavigationController *nav;
    nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
}

@end
