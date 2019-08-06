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
    
    [[ZJAppDelegateManager sharedInstance] trigger_applicationDidFinishLaunchingWithOptions:launchOptions];
    return YES;
}


@end
