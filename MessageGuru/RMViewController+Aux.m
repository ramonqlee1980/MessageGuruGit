//
//  RMViewController+Aux.m
//  MessageGuru
//
//  Created by ramonqlee on 2/26/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMViewController+Aux.h"
#import "MobiSageSDK.h"


@interface UIViewController(RMViewController_Aux_Private)<MobiSageAdBannerDelegate>

@end

@implementation UIViewController(RMViewController_Aux)

- (void)addNavigationButton:(UIBarButtonItem*)leftButtonItem withRightButton:(UIBarButtonItem*)rightButtonItem;
{
    // Dispose of any resources that can be recreated.
    if (!leftButtonItem) {
        self.navigationItem.leftBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"")
                                          style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(back)] autorelease];
    }
    
    if (leftButtonItem) {
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }
    if (rightButtonItem) {
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
}

#pragma mark dismiss selector
-(IBAction)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark mobisage banner
-(UIView*)getMobisageBanner
{
    MobiSageAdBanner* adBanner = nil;
    if (adBanner == nil) {
        if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom) {
            adBanner = [[[MobiSageAdBanner alloc] initWithAdSize:Ad_728X90 withDelegate:self]autorelease];
            adBanner.frame = CGRectMake(20, 80, 728, 90);
        }
        else {
            adBanner = [[[MobiSageAdBanner alloc] initWithAdSize:Ad_320X50 withDelegate:self]autorelease];
            adBanner.frame = CGRectMake(0, 80, 320, 50);
        }
        
        //设置广告轮播动画效果
        [adBanner setSwitchAnimeType:Random];
    }
    return adBanner;
}

#pragma  mark MobiSageAdBannerDelegate
#pragma mark
- (UIViewController *)viewControllerToPresent
{
    return self;
}

/**
 *  横幅广告被点击
 *  @param adBanner
 */
- (void)mobiSageAdBannerClick:(MobiSageAdBanner*)adBanner
{
    NSLog(@"横幅广告被点击");
}

/**
 *  adBanner请求成功并展示广告
 *  @param adBanner
 */
- (void)mobiSageAdBannerSuccessToShowAd:(MobiSageAdBanner*)adBanner
{
    NSLog(@"横幅广告请求成功并展示广告");
}
/**
 *  adBanner请求失败
 *  @param adBanner
 */
- (void)mobiSageAdBannerFaildToShowAd:(MobiSageAdBanner*)adBanner
{
    NSLog(@"横幅广告请求失败");
}
/**
 *  adBanner被点击后弹出LandingSit
 *  @param adBanner
 */
- (void)mobiSageAdBannerPopADWindow:(MobiSageAdBanner*)adBanner
{
    NSLog(@"被点击后弹出LandingSit");
}
/**
 *  adBanner弹出的LandingSit被关闭
 *  @param adBanner
 */
- (void)mobiSageAdBannerHideADWindow:(MobiSageAdBanner*)adBanner
{
    NSLog(@"弹出的LandingSit被关闭");
}
@end
