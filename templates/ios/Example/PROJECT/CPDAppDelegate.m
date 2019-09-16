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
#import <WPLogin/WPLoginManager.h>
#import <WPGlobal/WPGlobal.h>
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
    
    
    
    [[ZJAppConfiguration sharedInstance] zj_setupTarget:ZJTargetTypeWPUser environment:ZJEnvironmentTypeInternalTest];
    
    [self setLoginRootViewController];
    
    //[self setUnloginRootViewController];
    
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)setLoginRootViewController {
    if (![WPUserManager wp_isUserLogin]) {
        UIViewController <WPLoginServiceProtocol>*loginController = [ZJServiceManager createServiceWithProtocol:@protocol(WPLoginServiceProtocol)];
        UINavigationController *nav;
        if (loginController) {
            nav = [[UINavigationController alloc] initWithRootViewController:loginController];
            self.window.rootViewController = nav;
        }
    } else {
        [[ZJAppConfiguration sharedInstance] zj_setUserToken:[WPUserManager wp_token]];
        
        id<ZJAppHomeProtocol> appHome = [ZJServiceManager createServiceWithProtocol:@protocol(ZJAppHomeProtocol)];
        self.window.rootViewController = [appHome setupRootViewController];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidLoginSuccess:) name:kWPDidUserLoginSuccessNotification object:nil];
    
}

- (void)setUnloginRootViewController {
    CPDViewController *vc = [[CPDViewController alloc] init];
    UINavigationController *nav;
    nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
}

- (void)appDidLoginSuccess:(NSNotification *)noti {
    if (noti.object) {
        id<ZJAppHomeProtocol> appHome = [ZJServiceManager createServiceWithProtocol:@protocol(ZJAppHomeProtocol)];
        self.window.rootViewController = [appHome setupRootViewController];
    }
}

@end
