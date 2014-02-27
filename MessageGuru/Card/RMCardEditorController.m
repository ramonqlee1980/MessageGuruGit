//
//  RMCardEditorController.m
//  MessageGuru
//
//  Created by ramonqlee on 2/26/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMCardEditorController.h"
#import <QuartzCore/QuartzCore.h>
#import "Flurry.h"
#import "Constants.h"
#import "REMenuItem.h"
#import "REMenu.h"
#import "PPRevealSideViewController.h"

@interface RMCardEditorController ()
{
    REMenu* _menu;
}
@end

@implementation RMCardEditorController
@synthesize msg,background;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadEx
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.msgTextView addGestureRecognizer:pan];
    [pan release];
}

/* 识别拖动 */
- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translatedPoint = [gestureRecognizer translationInView:self.view];
    NSLog(@"gesture translatedPoint  is %@", NSStringFromCGPoint(translatedPoint));
    CGFloat x = gestureRecognizer.view.center.x + translatedPoint.x;
    CGFloat y = gestureRecognizer.view.center.y + translatedPoint.y;
    
    gestureRecognizer.view.center = CGPointMake(x, y);
    
    NSLog(@"pan gesture testPanView moving  is %@,%@", NSStringFromCGPoint(gestureRecognizer.view.center), NSStringFromCGRect(gestureRecognizer.view.frame));
    
    [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadEx];
    
    // Do any additional setup after loading the view from its nib.
    if (self.msgTextView) {
        [self.msgTextView setText:msg];
    }
    
    if (self.background) {
        self.backgroundImageView.image = self.background;
    }
    
    //TODO::左右button，左边返回，右边发送
    //选择按钮
    NSArray *buttonNames = [NSArray arrayWithObjects:NSLocalizedString(@"Setting", @""), NSLocalizedString(@"Send", @""), nil];
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:buttonNames];
    [segmentedControl setFrame:CGRectMake(0, 0, 100, 40)];
    segmentedControl.selectedSegmentIndex=1;
    
    //添加事件
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem* customBarButtonItem = [[[UIBarButtonItem alloc]initWithCustomView:segmentedControl]autorelease];
    [segmentedControl release];
    
    
    SEL selector = @selector(addNavigationButton:withRightButton:);
    if ([self respondsToSelector:selector]) {
        [self addNavigationButton:nil withRightButton:customBarButtonItem];
    }
    
    [self textViewBoundingBox:NO];
}
-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
//    const NSUInteger kSettingButtonIndex = 0;
    const NSUInteger kSendButtonIndex = 1;
    if (Index==kSendButtonIndex) {
        [self sendCard];
    }
    else
    {
        [self setting];
    }
    NSLog(@"Seg.selectedSegmentIndex:%d",Index);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark navigation action
-(void)sendCard
{
    //hide keyboard
    [self.msgTextView resignFirstResponder];
    
    UIImage* cardShot = [self generateScreenShot];
    
    //显示分享界面，发送
    [self showShareView:self withText:@"" withImage:cardShot];
}
-(void)setting
{
    [self showMenu];
}

#pragma mark util methods
- (void)showMenu
{
    if (_menu.isOpen)
        return [_menu close];
    
    // Sample icons from http://icons8.com/download-free-icons-for-ios-tab-bar
    //
    
    REMenuItem *fontItem = [[REMenuItem alloc] initWithTitle:@"Font"
                                                    subtitle:@"Return to Home Screen"
                                                       image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
                                                      }];
    
    REMenuItem *imageItem = [[REMenuItem alloc] initWithTitle:@"Background"
                                                       subtitle:@"Explore 47 additional options"
                                                          image:[UIImage imageNamed:@"Icon_Explore"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                         }];
    
    fontItem.tag = 0;
    imageItem.tag = 1;
    
    _menu = [[REMenu alloc] initWithItems:@[fontItem, imageItem]];
    _menu.cornerRadius = 4;
    _menu.shadowColor = [UIColor blackColor];
    _menu.shadowOffset = CGSizeMake(0, 1);
    _menu.shadowOpacity = 1;
    _menu.imageOffset = CGSizeMake(5, -1);
    
    [_menu showFromNavigationController:self.navigationController];
}
//textview 边框
-(void)textViewBoundingBox:(BOOL)visible
{
    CGColorRef colr = visible?[UIColor grayColor].CGColor:[UIColor clearColor].CGColor;
    
    self.msgTextView.layer.borderColor = colr;
    self.msgTextView.layer.borderWidth = 2.0;
    self.msgTextView.layer.cornerRadius =5.0;
    self.msgTextView.backgroundColor = [UIColor clearColor];
}
//TODO::获取指定区域的截图，生成贺卡
-(UIImage*)generateScreenShot
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *aImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return aImage;
}

#pragma mark util methods
- (void)showShareView:(id)sender withText:(NSString*)text withImage:(UIImage*)image{
    NSDictionary* dict = [NSDictionary dictionaryWithObject:text forKey:kSNSShareEvent];
    [Flurry logEvent:kSNSShareEvent withParameters:dict];
    
    //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUMeng_App_Key
                                      shareText:text
                                     shareImage:image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSms,UMShareToEmail,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToQzone,UMShareToFacebook,UMShareToTwitter,nil]
                                       delegate:self];
}
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    //weixin
    //    if ([platformName isEqualToString:UMShareToWechatSession] ||
    //        [platformName isEqualToString:UMShareToWechatTimeline] ) {
    //        socialData.extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    //        socialData.extConfig.title = NSLocalizedString(@"Title", @"");
    //        socialData.extConfig.appUrl = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8",kAppleId];
    //    }
}

#pragma mark umeng sns delegate
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        NSString* snsName = [[response.data allKeys] objectAtIndex:0];
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:snsName,kSNSPlatformKey, nil];
        [Flurry logEvent:kShareBySNSResponseEvent withParameters:dict];
    }
}


@end
