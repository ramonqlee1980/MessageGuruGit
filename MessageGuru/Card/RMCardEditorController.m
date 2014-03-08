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
#import "RMDataCenter.h"


@interface RMCardEditorController ()
{
    UITableView *bottomTableview;
    NSArray* backgroundImages;
}
@property(nonatomic,retain)NSArray* backgroundImages;
@end

@implementation RMCardEditorController
@synthesize msg,background,category,backgroundImages;

//TODO::不同类别返回对应的背景图，有缺省背景图
//并检查图片是否有效
+(NSArray*)getBackgroundFiles:(NSString*)categoryName
{
    NSArray* array = [[RMDataCenter sharedInstance]cards:categoryName];
    NSMutableArray* ret = [[[NSMutableArray alloc]initWithCapacity:array.count]autorelease];
    
    for (NSString* backgroundFileName  in array) {
        if(![RMCardEditorController getImage:backgroundFileName])
        {
            continue;
        }
        [ret addObject:backgroundFileName];
    }
    
    return ret;
}

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
    _backgroundImageView =[[UIImageView alloc]init];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    _textView = [[UITextView alloc]init];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.textView addGestureRecognizer:pan];
    [pan release];
    
    [self initExtraViews];
    
    if (self.textView) {
        [self.textView setText:msg];
    }
    
    if (self.background) {
        self.backgroundImageView.image = self.background;
    }
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
    
    [self setTextViewBoundingBox:NO];
    self.backgroundImages = [RMCardEditorController getBackgroundFiles:self.category];
    if(self.backgroundImages.count)
    {
        self.backgroundImageView.image = [RMCardEditorController  getImage:[self.backgroundImages objectAtIndex:0]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    [self.textView resignFirstResponder];
    
    UIImage* cardShot = [self generateScreenShot:[self clientView]];
    
    //显示分享界面，发送
    [self showShareView:self withText:@"" withImage:cardShot];
}

//textview 边框
-(void)setTextViewBoundingBox:(BOOL)visible
{
    CGColorRef colr = visible?[UIColor grayColor].CGColor:[UIColor clearColor].CGColor;
    
    self.textView.layer.borderColor = colr;
    self.textView.layer.borderWidth = 2.0;
    self.textView.layer.cornerRadius =5.0;
    self.textView.backgroundColor = [UIColor clearColor];
}
//TODO::获取指定区域的截图，生成贺卡
-(UIImage*)generateScreenShot:(UIView*)view
{
    if (bottomTableview) {
        bottomTableview.hidden = YES;
    }
    //支持retina高分的关键
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }

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
-(void)initExtraViews
{
    const static CGFloat kBottomBarMargin = 0;//上下margin
    const static CGFloat kBottomBarHeight = 60;
    //set backgroundview size
    CGRect frame = [[UIScreen mainScreen]bounds];
    CGRect backgroundFrame = frame;
    
    //去除statusbar，navigationbar高度
    UIView* adapterView = [self clientView];
    
    backgroundFrame.size.height = adapterView.frame.size.height;
    
    //adapterview for adapt view of ios7 and previous version
    //留出出底部的状态条高度
    backgroundFrame.size.height -= (kBottomBarHeight+2*kBottomBarMargin);
    self.backgroundImageView.frame = backgroundFrame;
    
    [self.backgroundImageView removeFromSuperview];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [adapterView addSubview:self.backgroundImageView];
    
    _textView.layer.anchorPoint = CGPointMake(0, 0);
//    _textView.font = [UIFont fontWithName:@"Arial" size:18.0f];
    CGRect rect = _textView.frame;
    rect.origin = CGPointZero;
    rect.size = backgroundFrame.size;
    rect.size.height /=  2;
    _textView.frame = rect;
    _textView.layer.position = CGPointZero;
    [adapterView addSubview:_textView];
    
    if (bottomTableview) {
        return;
    }
    bottomTableview  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kBottomBarHeight, self.view.frame.size.width)];
    bottomTableview.backgroundColor = [UIColor clearColor];
    bottomTableview.showsVerticalScrollIndicator = NO;
    
    
    CGFloat y = backgroundFrame.origin.y+backgroundFrame.size.height+kBottomBarHeight;
    bottomTableview.frame = CGRectMake(0, 0,kBottomBarHeight,frame.size.width);
    bottomTableview.rowHeight = kBottomBarHeight;
    NSLog(@"%f,%f,%f,%f",bottomTableview.frame.origin.x,bottomTableview.frame.origin.y,bottomTableview.frame.size.width,bottomTableview.frame.size.height);

    [bottomTableview.layer setPosition:CGPointMake(0, y)];
    [bottomTableview.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    bottomTableview.transform = CGAffineTransformMakeRotation(-M_PI_2);
    //TODO::旋转坐标系下设定位置
    
    bottomTableview.delegate = self;
    bottomTableview.dataSource = self;
    [bottomTableview removeFromSuperview];
    [adapterView addSubview:bottomTableview];
    
    [bottomTableview release];
}


#pragma mark tableview datasource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return backgroundImages.count;//背景图//和字体设置
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString* backgroundFileName = [backgroundImages objectAtIndex:indexPath.row];
    UIImage* image = [RMCardEditorController getImage:backgroundFileName];
    
    cell.imageView.image = image;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"--------->%d",indexPath.row);
    //TODO::暂时仅加入背景图替换，测试效果
    //获取背景图文件名，预览效果，其中0代表恢复初始效果
    NSString* backgroundFileName = [[RMCardEditorController getBackgroundFiles:self.category]objectAtIndex:indexPath.row];
    
    UIImage* image = [RMCardEditorController getImage:backgroundFileName];
    
    if (self.background && image) {
        self.backgroundImageView.image = image;
    }
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
}
//首先尝试全路径加载，然后尝试从资源目录加载
+(UIImage*)getImage:(NSString*)fileName
{
    UIImage* image = [UIImage imageWithContentsOfFile:fileName];
    if (!image) {
        image = [UIImage imageNamed:fileName];
    }
//    NSLog(@"(%f,%f)",image.size.width,image.size.height);
    
    
    return image;
}
@end
