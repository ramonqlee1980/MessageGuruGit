//
//  DailyBoothViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//
// Copyright (c) 2011 Peter Boctor
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

#import "TabbedViewController.h"
#import "Favorite.h"
#import "AllSMSViewController.h"
#import "SMSListViewController.h"
#import "RMFavoriteViewController.h"
#import "SettingsViewController.h"
#import "HotViewController.h"


@interface TabbedViewController()
{
}
@end

@implementation TabbedViewController

-(void)willAppearIn:(UINavigationController *)navigationController
{
    [self addCenterButtonWithImage:[UIImage imageNamed:@"camera_button_take.png"] highlightImage:[UIImage imageNamed:@"tabBar_cameraButton_ready_matte.png"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewControllers = [NSArray arrayWithObjects:
                            [self hotViewController],
                            [self categoryController],
                            [self viewControllerWithTabTitle:@"" image:nil],
                            [self favoriteController],
                            [self aboutController], nil];
}

#pragma mark view controllers
-(UIViewController*)hotViewController
{
    HotViewController* categoryViewController = [[HotViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    categoryViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"热门" image:[UIImage imageNamed:@"tab_live"] tag:0] autorelease];
    
    return categoryViewController;
}
-(UIViewController*)aboutController
{
    SettingsViewController* ret = [[SettingsViewController new]autorelease];
    ret.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"关于" image:[UIImage imageNamed:@"tab_messages.png"] tag:0] autorelease];
    return ret;
}

-(UIViewController*)categoryController
{
    AllSMSViewController* categoryViewController = [[AllSMSViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    categoryViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"短信大全" image:[UIImage imageNamed:@"tab_feed.png"] tag:0] autorelease];
    
    return categoryViewController;
}

-(UIViewController*)favoriteController
{
    RMFavoriteViewController* favoriteController = [[RMFavoriteViewController new]autorelease];
    favoriteController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"收藏" image:[UIImage imageNamed:@"tab_feed_profile.png"] tag:0] autorelease];
    return favoriteController;
}


@end
