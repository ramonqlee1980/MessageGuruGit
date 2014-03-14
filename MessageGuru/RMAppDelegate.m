//
//  RMAppDelegate.m
//  MessageGuru
//
//  Created by Ramonqlee on 1/23/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMAppDelegate.h"
#import "TabbedViewController.h"
#include "UMSocial.h"
#include "Constants.h"
#include "Flurry.h"
#import "UMSocialWechatHandler.h"
#import "MobiSageSDK.h"
#import "RMEncoding.h"
@implementation RMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //fixme:test
//    [RMEncoding SC2Pinyin:@"我爱北京" withDiacritics:YES];
//    [RMEncoding SC2TC:@"我爱北京"];
//    [RMEncoding SC2Huoxing:@"我爱北京"];
//    [RMEncoding SC2Juhua:@"我爱北京"];
    //end
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    TabbedViewController* homepage = [[TabbedViewController new]autorelease];
    UINavigationController *navigationController = [[[UINavigationController alloc]initWithRootViewController:homepage]autorelease];
    navigationController.navigationBarHidden = YES;
    navigationController.delegate = self;
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
    self.window.rootViewController = navigationController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self initExtra];
    return YES;
}
-(void)initExtra
{
    //向微信注册
//    [WXApi registerApp:kWeixin_App_Id];
    //设置微信AppId，url地址传nil，将默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:kWeixin_App_Id url:nil];
    
    //设置友盟appkey
    [UMSocialData setAppKey:kUMeng_App_Key];

    //mobisage global setting
    [[MobiSageManager getInstance] setPublisherID:kMobisagePublisherId];
    [[MobiSageManager getInstance] showStoreInApp:YES];
    
    //flurry initialization
    [Flurry startSession:kFlurryAppId];
    [Flurry setSecureTransportEnabled:YES];
    [Flurry setCrashReportingEnabled:YES];
}

- (void)navigationController:(UINavigationController *)navController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController respondsToSelector:@selector(willAppearIn:)])
        [viewController performSelector:@selector(willAppearIn:) withObject:navController];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
