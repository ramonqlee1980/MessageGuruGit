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

@interface RMCardEditorController ()
{
    UITableView *bottomTableview;
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
    
    [self loadBottomSettingView];
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
    
    //左右button，左边返回，右边发送
    UIBarButtonItem * rigthBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Send", @"")
                                      style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(sendCard)] autorelease];
    
    
    SEL selector = @selector(addNavigationButton:withRightButton:);
    if ([self respondsToSelector:selector]) {
        [self addNavigationButton:nil withRightButton:rigthBarButtonItem];
    }
    
    [self textViewBoundingBox:NO];
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
    if (bottomTableview) {
        bottomTableview.hidden = YES;
    }
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *aImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (bottomTableview) {
        bottomTableview.hidden = NO;
    }
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

#pragma mark load bottom view
-(void)loadBottomSettingView
{
    const static NSUInteger kBottomBarMargin = 30;
    const static NSUInteger kBottomBarHeight = 60;
    
    bottomTableview  = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 60, 480)];
    bottomTableview.backgroundColor = [UIColor whiteColor];
    [bottomTableview.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    bottomTableview.transform = CGAffineTransformMakeRotation(-M_PI_2);
    bottomTableview.showsVerticalScrollIndicator = NO;
    
    CGRect frame = self.view.frame;
    
    bottomTableview.frame = CGRectMake(0, frame.size.height-kBottomBarMargin-kBottomBarHeight,frame.size.width, kBottomBarHeight);
    bottomTableview.rowHeight = 60.0;
    NSLog(@"%f,%f,%f,%f",bottomTableview.frame.origin.x,bottomTableview.frame.origin.y,bottomTableview.frame.size.width,bottomTableview.frame.size.height);

    bottomTableview.delegate = self;
    bottomTableview.dataSource = self;
    [self.view addSubview:bottomTableview];
    [bottomTableview release];
}

#pragma mark tableview datasource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 16;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.backgroundColor = [UIColor redColor];
        cell.textLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    cell.backgroundColor = [UIColor yellowColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"--------->%d",indexPath.row);
}

@end
