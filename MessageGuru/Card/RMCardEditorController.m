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
#import "SWSnapshotStackView.h"
#import "Flurry.h"
#import "RMViewController+Aux.h"
#import "REMenu.h"


const NSUInteger kCellHeight = 44;

@interface RMCardEditorController ()<UITextViewDelegate>
{
    UITableView *bottomTableview;
    NSArray* backgroundImages;
    CGPoint _inputViewOriginalPoint;
}
@property(nonatomic,retain)NSArray* backgroundImages;
@property (retain, nonatomic) REMenu *menu;
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
    [self registerForKeyboardNotifications];
    _backgroundImageView =[[SWSnapshotStackView alloc]init];
    _backgroundImageView.displayAsStack = YES;
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _textView = [[UITextView alloc]init];
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textAlignment = NSTextAlignmentCenter;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.textView addGestureRecognizer:pan];
    [pan release];
    
    [self initExtraViews];
    
    if (self.textView) {
        [self.textView setText:msg];
        CGRect frame = self.textView.frame;
        frame.size = [RMCardEditorController boundingSize:self.textView.font withText:self.textView.text withinView:self.view];
        self.textView.frame = frame;
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
    
    self.backgroundImages = [RMCardEditorController getBackgroundFiles:self.category];
    if(self.backgroundImages.count)
    {
        self.backgroundImageView.image = [RMCardEditorController  getImage:[self.backgroundImages objectAtIndex:0]];
    }
    
    //flurry
    [Flurry logEvent:kEnterSMSCardUI];
    
    //add font menu
//    self.view.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
    [self addFontButton];
}
-(void)addFontButton
{
    //这里创建一个圆角矩形的按钮
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //    能够定义的button类型有以下6种，
    //    typedef enum {
    //        UIButtonTypeCustom = 0,          自定义风格
    //        UIButtonTypeRoundedRect,         圆角矩形
    //        UIButtonTypeDetailDisclosure,    蓝色小箭头按钮，主要做详细说明用
    //        UIButtonTypeInfoLight,           亮色感叹号
    //        UIButtonTypeInfoDark,            暗色感叹号
    //        UIButtonTypeContactAdd,          十字加号按钮
    //    } UIButtonType;
    
    //给定button在view上的位置
    button1.frame = CGRectMake(20, 20, 100, 50);
    
    //button背景色
    button1.backgroundColor = [UIColor clearColor];
    
    //设置button填充图片
    //[button1 setImage:[UIImage imageNamed:@"btng.png"] forState:UIControlStateNormal];
    
    //设置button标题
    [button1 setTitle:@"字体" forState:UIControlStateNormal];
    
    /* forState: 这个参数的作用是定义按钮的文字或图片在何种状态下才会显现*/
    //以下是几种状态
    //    enum {
    //        UIControlStateNormal       = 0,         常规状态显现
    //        UIControlStateHighlighted  = 1 << 0,    高亮状态显现
    //        UIControlStateDisabled     = 1 << 1,    禁用的状态才会显现
    //        UIControlStateSelected     = 1 << 2,    选中状态
    //        UIControlStateApplication  = 0x00FF0000, 当应用程序标志时
    //        UIControlStateReserved     = 0xFF000000  为内部框架预留，可以不管他
    //    };
    
    /*
     * 默认情况下，当按钮高亮的情况下，图像的颜色会被画深一点，如果这下面的这个属性设置为no，
     * 那么可以去掉这个功能
     */
    button1.adjustsImageWhenHighlighted = NO;
    /*跟上面的情况一样，默认情况下，当按钮禁用的时候，图像会被画得深一点，设置NO可以取消设置*/
    button1.adjustsImageWhenDisabled = NO;
    /* 下面的这个属性设置为yes的状态下，按钮按下会发光*/
    button1.showsTouchWhenHighlighted = YES;
    
    /* 给button添加事件，事件有很多种，我会单独开一篇博文介绍它们，下面这个时间的意思是
     按下按钮，并且手指离开屏幕的时候触发这个事件，跟web中的click事件一样。
     触发了这个事件以后，执行butClick:这个方法，addTarget:self 的意思是说，这个方法在本类中
     也可以传入其他类的指针*/
    [button1 addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    
    //显示控件
    self.navigationItem.titleView = button1;
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
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:text,kSNSShareEvent,@"image",kSNSImageShareEvent, nil];
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
    backgroundFrame.size.height -= (kBottomBarHeight+kBottomBarMargin);
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
    bottomTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    static const NSUInteger kImageViewTag = 0x1000;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGRect frame = cell.frame;
        frame.origin = CGPointZero;
        frame.size.width = kCellHeight;
        frame.size.height = kCellHeight;
        
        
        SWSnapshotStackView* imageView = [[SWSnapshotStackView alloc]initWithFrame:frame];
        imageView.displayAsStack = NO;
        imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.tag = kImageViewTag;
        
        [cell.contentView addSubview:imageView];
        [imageView release];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString* backgroundFileName = [backgroundImages objectAtIndex:indexPath.row];
    UIImage* image = [RMCardEditorController getImage:backgroundFileName];
    UIImageView* imageView = (UIImageView*)[cell.contentView viewWithTag:kImageViewTag];
    imageView.image = image;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"--------->%d",indexPath.row);
    //TODO::暂时仅加入背景图替换，测试效果
    //获取背景图文件名，预览效果，其中0代表恢复初始效果
    NSString* backgroundFileName = [[RMCardEditorController getBackgroundFiles:self.category]objectAtIndex:indexPath.row];
    
    UIImage* image = [RMCardEditorController getImage:backgroundFileName];
    
    if (image) {
        self.backgroundImageView.image = image;
    }
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [Flurry logEvent:kSwitchBackgroundInCardUI];
}
//首先尝试全路径加载，然后尝试从资源目录加载
+(UIImage*)getImage:(NSString*)fileName
{
    UIImage* image = [UIImage imageWithContentsOfFile:fileName];
    if (!image) {
        image = [UIImage imageNamed:fileName];
    }
    
    //try to find under directory -card
    NSString *homeDir = [[NSBundle mainBundle] resourcePath];
    NSString* cardFileName = [NSString stringWithFormat:@"%@/card/%@",homeDir,fileName];
    if (!image) {
        image = [UIImage imageWithContentsOfFile:cardFileName];
    }
    //    NSLog(@"(%f,%f)",image.size.width,image.size.height);
    return image;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_textView isExclusiveTouch]) {
        [_textView resignFirstResponder];
    }
}

#pragma mark textview overlapped by keyboard
- (void) registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void) keyboardWillShow:(NSNotification *) notification {
    
    //取得键盘frame，注意，因为键盘是window的层面弹出来的，所以其frame坐标也是对应window窗口的
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGPoint endOrigin = endRect.origin;
    
    NSLog(@"keyboard frame = %@",NSStringFromCGRect(endRect));
    //把键盘的frame坐标转换到与UITextView一致的父view上来
    UIView* inputView = self.textView;
    UIView* parentView = [self clientView];
    _inputViewOriginalPoint = inputView.frame.origin;
    
    endOrigin = [parentView convertPoint:endOrigin fromView:[UIApplication sharedApplication].keyWindow];
    NSLog(@"endOrigin = %@",NSStringFromCGPoint(endOrigin));
    //调整inputView的位置
    CGFloat inputView_Y =parentView.frame.size.height - endRect.size.height - inputView.frame.size.height;
    
    //move it or not
    if (inputView_Y>_inputViewOriginalPoint.y) {
        return;
    }
    [UIView beginAnimations:nil context:nil];
    inputView.frame = CGRectMake(inputView.frame.origin.x, inputView_Y, inputView.frame.size.width, inputView.frame.size.height);
    [UIView commitAnimations];
}

- (void) keyboardWillBeHidden:(NSNotification *) notification {
    //reposition it
    [UIView beginAnimations:nil context:nil];
    
    CGRect frame = self.textView.frame;
    frame.origin = _inputViewOriginalPoint;
    self.textView.frame = frame;
    [UIView commitAnimations];
    
    NSLog(@"keyboardWillBeHidden resizing = %@",NSStringFromCGRect(frame));
    frame.size = [RMCardEditorController boundingSize:self.textView.font withText:self.textView.text withinView:self.view];
    NSLog(@"keyboardWillBeHidden resized = %@",NSStringFromCGRect(frame));
    self.textView.frame = frame;
}
#pragma mark textviewdelegate
- (void)textViewDidChange:(UITextView *)textView
{
    //resize it
    CGRect frame = self.textView.frame;
    NSLog(@"textViewDidChange resizing = %@",NSStringFromCGRect(frame));
    frame.size = [RMCardEditorController boundingSize:self.textView.font withText:self.textView.text withinView:self.view];
    NSLog(@"textViewDidChange resized = %@",NSStringFromCGRect(frame));
    self.textView.frame = frame;
    self.textView.contentSize = frame.size;
   
    NSLog(@"textViewDidChange contentOffset = %@",NSStringFromCGPoint(self.textView.contentOffset));
    NSLog(@"textViewDidChange contentSize = %@",NSStringFromCGSize(self.textView.contentSize));
}

#pragma mark text bounding box
+(CGSize)boundingSize:(UIFont*)font withText:(NSString*)text withinView:(UIView*)view
{
    CGSize constraint = CGSizeMake(view.frame.size.width, 20000.0f);
    
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSAttributedString *attributedText =
    [[[NSAttributedString alloc]
     initWithString:text
     attributes:attributes]autorelease];
    CGSize size = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil].size;
    size.height +=  10;//clip size
    
    return size;
}

#pragma mark REMenu

- (void)showMenu
{
    if (_menu.isOpen)
        return [_menu close];
    
    // Sample icons from http://icons8.com/download-free-icons-for-ios-tab-bar
    //
    
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"Home"
                                                    subtitle:@"Return to Home Screen"
                                                       image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
                                                      }];
    
    REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"Explore"
                                                       subtitle:@"Explore 47 additional options"
                                                          image:[UIImage imageNamed:@"Icon_Explore"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                         }];
    
    REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"Activity"
                                                        subtitle:@"Perform 3 additional activities"
                                                           image:[UIImage imageNamed:@"Icon_Activity"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                          }];
    
    REMenuItem *profileItem = [[REMenuItem alloc] initWithTitle:@"Profile"
                                                          image:[UIImage imageNamed:@"Icon_Profile"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                         }];
    
    homeItem.tag = 0;
    exploreItem.tag = 1;
    activityItem.tag = 2;
    profileItem.tag = 3;
    
    _menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem]];
    _menu.cornerRadius = 4;
    _menu.shadowColor = [UIColor blackColor];
    _menu.shadowOffset = CGSizeMake(0, 1);
    _menu.shadowOpacity = 1;
    _menu.imageOffset = CGSizeMake(5, -1);
    
    [_menu showFromNavigationController:self.navigationController];
}

#pragma mark -
#pragma mark Rotation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
