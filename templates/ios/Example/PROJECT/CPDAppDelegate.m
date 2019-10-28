//
//  WPAppDelegate.m
//  WPPropertService
//
//  Created by zhangjiong on 09/29/2019.
//  Copyright (c) 2019 zhangjiong. All rights reserved.
//

#import "WPAppDelegate.h"
#import "WPViewController.h"
#import <ZJModuleService/ZJModuleService.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <ZJAppConfig/ZJAppConfig.h>
#import <WPLogin/WPLoginManager.h>
#import <WPLogin/WPLeelinSDKManager.h>
#import <WPGlobal/WPGlobal.h>
#import <WPKit/WPKit.h>
#import "LinSDK.h"
#import <WPWeakServiceComponent/WPWeakServiceComponent.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "JPUSHService.h"

@interface WPAppDelegate ()<UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>

@end

@implementation WPAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 配置环境
    [[ZJAppConfiguration sharedInstance] zj_setupTarget:ZJTargetTypeWPUser environment:ZJEnvironmentTypeInternalTest];
    
    // 配置键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    
    // 资源下载
     [[WPResourceDownloadManager sharedInstance] downloadResource];
    
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|UNAuthorizationOptionProvidesAppNotificationSettings;
        //应用内显示通知设置的按钮
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
      // 可以添加自定义 categories
      // NSSet<UNNotificationCategory *> *categories for iOS10 or later
      // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    [JPUSHService setupWithOption:launchOptions appKey:[ZJAppConfiguration sharedInstance].zj_jpushServiceKey channel:@"AppStore" apsForProduction:NO];
    
    //设置 rootViewController
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
        
        //        id<ZJAppHomeProtocol> appHome = [ZJServiceManager createServiceWithProtocol:@protocol(ZJAppHomeProtocol)];
        //        self.window.rootViewController = [appHome setupRootViewController];
        [self setUnloginRootViewController];
        [self leeLinLogin];
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
        [self leeLinLogin];
    }
}

- (void)leeLinLogin {
    
    if ([WPUserManager wp_userUserInfo][@"userIdLilin"]==nil) {
        return;
    }
    
    if ([WPUserManager wp_leelinAccountInfo]) {
        // 立林不登出  就一直处于登录状态
        return;
    }
    
    [[WPLeelinSDKManager sharedLilinManager] leelin_loginIn];
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

  /// Required - 注册 DeviceToken
  [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  //Optional
  NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
  if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    //从通知界面直接进入应用
  }else{
    //从通知设置界面进入应用
  }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
  // Required
  NSDictionary * userInfo = notification.request.content.userInfo;
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
  }
  completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
  // Required
  NSDictionary * userInfo = response.notification.request.content.userInfo;
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
  }
  completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

  // Required, iOS 7 Support
  [JPUSHService handleRemoteNotification:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
}



@end
