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
#import "HomeViewController.h"
#import "SMSListViewController.h"
#import "Favorite.h"
#import "RMFavoriteViewController.h"
#import "SettingsViewController.h"


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
    
#warning 热门待添加，关于待添加
  self.viewControllers = [NSArray arrayWithObjects:
                          [self viewControllerWithTabTitle:@"热门" image:[UIImage imageNamed:@"tab_live"]],
                          [self categoryController],
                            [self viewControllerWithTabTitle:@"" image:nil],
                            [self favoriteController],
                            [self aboutController], nil];
}

#pragma mark view controllers
-(UIViewController*)aboutController
{
    SettingsViewController* ret = [[SettingsViewController new]autorelease];
    ret.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"关于" image:[UIImage imageNamed:@"tab_messages.png"] tag:0] autorelease];
    return ret;
}
-(UIViewController*)categoryController
{
    HomeViewController* categoryViewController = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    categoryViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"短信" image:[UIImage imageNamed:@"tab_feed.png"] tag:0] autorelease];
    
    return categoryViewController;
}

-(UIViewController*)favoriteController
{
    RMFavoriteViewController* favoriteController = [[RMFavoriteViewController new]autorelease];
    favoriteController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"收藏" image:[UIImage imageNamed:@"tab_feed_profile.png"] tag:0] autorelease];
    return favoriteController;
}


@end
