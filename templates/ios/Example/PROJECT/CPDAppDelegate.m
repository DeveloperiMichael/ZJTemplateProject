//
//  WPAppDelegate.m
//  WPPropertService
//
//  Created by zhangjiong on 09/29/2019.
//  Copyright (c) 2019 zhangjiong. All rights reserved.
//

#import "CPDAppDelegate.h"
#import "WPViewController.h"
#import <ZJModuleService/ZJModuleService.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <ZJAppConfig/ZJAppConfig.h>
#import <WPLogin/WPLoginManager.h>
#import <WPGlobal/WPGlobal.h>
#import <WPWeakServiceComponent/WPWeakServiceComponent.h>
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
    [self setLoginRootViewController];
    //[self setUnloginRootViewController];
    
    // 配置环境
    [[ZJAppConfiguration sharedInstance] zj_setupTarget:ZJTargetTypeWPUser environment:ZJEnvironmentTypeDevelopment];
    
    // 配置键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    
    // 资源下载
     [[WPResourceDownloadManager sharedInstance] downloadResource];
    
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
        
        //        id<ZJAppHomeProtocol> appHome = [ZJServiceManager createServiceWithProtocol:@protocol(ZJAppHomeProtocol)];
        //        self.window.rootViewController = [appHome setupRootViewController];
        [self setUnloginRootViewController];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidLoginSuccess:) name:kWPDidUserLoginSuccessNotification object:nil];
    
}

- (void)setUnloginRootViewController {
    WPViewController *vc = [[WPViewController alloc] init];
    UINavigationController *nav;
    nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
}

- (void)appDidLoginSuccess:(NSNotification *)noti {
    if (noti.object) {
        //        id<ZJAppHomeProtocol> appHome = [ZJServiceManager createServiceWithProtocol:@protocol(ZJAppHomeProtocol)];
        //        self.window.rootViewController = [appHome setupRootViewController];
        [self setUnloginRootViewController];
    }
}

@end
