//
//  WorkViewController.m
//  Testhuitu
//
//  Created by gg on 7/1/13.
//  Copyright (c) 2013 sunland.com. All rights reserved.
//

#import "TimelineViewController.h"
#import "TimelineLine.h"
#import <QuartzCore/QuartzCore.h>

#define kRightMessageTipViewOffsetX 80.0f

@interface TimelineViewController ()
{
    UIImageView *backgroundImageView;
    UIView* detailCell;
    CGRect viewFrame;
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *timelineRoundButton;

//动态array
@property (strong, nonatomic) NSMutableArray *rightMessageTipViewArray;
@property (strong, nonatomic) NSMutableArray *timelineRoundbuttonArray;
@property (strong, nonatomic) NSMutableArray *leftCellViewArray;
@property (strong, nonatomic) UIImageView * animationImageView;
@property (strong, nonatomic) UIImageView *timelineLineImageView;
@property (strong, nonatomic) CATransition *timelineLineAnimation;

@property int previousPos;
@property int currentPos;

@end

@implementation TimelineViewController
//@synthesize imageView;
@synthesize scrollView;
@synthesize timelineRoundButton;
@synthesize rightMessageTipViewArray;
@synthesize timelineRoundbuttonArray;
@synthesize leftCellViewArray;
@synthesize previousPos;
@synthesize animationImageView;
@synthesize timelineLineImageView;
@synthesize timelineLineAnimation;
@synthesize currentPos;
@synthesize dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Time line";
    }
    return self;
}
-(id)initWithRect:(CGRect)rc
{
    self = [super init];
    viewFrame = rc;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //背景
//    [self setBackground:[UIImage imageNamed:@"kk.jpg"]];
    
    [self.navigationController setToolbarHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.toolbar.tintColor = [UIColor blackColor];

    [self addTimelineView:self.dataSource?self.dataSource.numberOfItem:0];
}

#pragma 设置背景
-(void)setBackground:(UIImage*)backgroundImage
{
    if (!backgroundImage) {
        return;
    }
    
    if(backgroundImageView)
    {
        [backgroundImageView setImage:backgroundImage];
        return;
    }
    
    backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [backgroundImageView setImage:backgroundImage];
    [self.view addSubview:backgroundImageView];
    
    [self.view sendSubviewToBack:backgroundImageView];
}
#pragma mark 初始化scrollview
//初始化scrollview
-(void)makeScrollView:(int)number
{
    if (self.scrollView) {
        return;
    }
    CGRect rc = CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height);
    self.scrollView = [[[UIScrollView alloc]initWithFrame:rc]autorelease];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, number*50+200);
    [self.view addSubview:scrollView];
}

#pragma mark 时间线绘制
//绘制完整的时间线
-(void)addTimelineView:(NSUInteger)itemCount
{
    [self makeScrollView:itemCount];
    
    //时间线本身线的绘制的绘制
    [self addTimeline];
    
    //时间线上元素(button)的绘制
    [self addTimelineButtons:itemCount];
    
    //时间线上右边初始view的填充
    [self addInitRightViews:itemCount];
}

//时间线本身线的绘制的绘制
-(void)addTimeline
{
    UIImageView* imageView = [[[UIImageView alloc]init]autorelease];
    imageView.frame = CGRectMake(0, 0, scrollView.bounds.size.width, scrollView.contentSize.height);
    [scrollView addSubview:imageView];

    self.view.backgroundColor = [UIColor whiteColor];
    TimelineLine *plan = [[TimelineLine alloc]init];
    plan.delegate = self;
    [plan setImageView:imageView setlineWidth:5.0 setColorRed:0 ColorBlue:1 ColorGreen:0 Alp:1 setBeginPointX:60 BeginPointY:0 setOverPointX:60 OverPointY:scrollView.contentSize.height];
    [plan release];
}

//添加时间线上的buttons
-(void)addTimelineButtons:(int)number
{
    self.leftCellViewArray = [[NSMutableArray alloc]initWithCapacity:10];
    self.timelineRoundbuttonArray = [[NSMutableArray alloc]initWithCapacity:10];
    for (int i = 0; i < number; i++)
    {
        self.timelineRoundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"timeline_button.png"];
        [timelineRoundButton setImage:image forState:UIControlStateNormal];
        timelineRoundButton.frame = CGRectMake(46, i*50, 30, 30);
        timelineRoundButton.tag = i;
        [timelineRoundButton addTarget:self action:@selector(showDetailView:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:timelineRoundButton];
        [timelineRoundbuttonArray addObject:timelineRoundButton];
       
        if (self.dataSource) {
            [self.dataSource decorateButton:timelineRoundButton withinContainer:scrollView forPos:i];
            
            UIView* leftCell = [self.dataSource leftCellForRow:i];
            leftCell.frame = CGRectMake(0, i*50, 40, 30);
            
            [scrollView addSubview:leftCell];
            [leftCellViewArray addObject:leftCell];
        }
    }
    
}

//添加初始的右边页面
-(void)addInitRightViews:(int)number
{
    self.rightMessageTipViewArray = [[NSMutableArray alloc]initWithCapacity:10];
    
    for (int i = 0; i < number; i++)
    {
        if (self.dataSource) {
            UIView* rightCell = [self.dataSource rightCellForRow:i];
            rightCell.frame = CGRectMake(kRightMessageTipViewOffsetX, i*50, 200, 30);
            
//            [rightCell setUserInteractionEnabled:NO];
            [rightMessageTipViewArray addObject:rightCell];
            
            [scrollView addSubview:rightCell];
        }
    }
}

#pragma mark 事件响应
//展开详情页
-(void)showDetailView:(id)sender
{
    UIButton *button = (UIButton *)sender;
    currentPos = button.tag;
    NSLog(@"currentPos = %d",currentPos);
    NSLog(@"previousPos = %d",previousPos);
    if (previousPos==currentPos) {
        return;
    }
    
    //移除功能
    if (detailCell)
    {
        [animationImageView removeFromSuperview];
        [animationImageView release];
        [timelineLineImageView removeFromSuperview];
        [timelineLineImageView release];
        
        //remove former view
        [detailCell removeFromSuperview];
        detailCell = nil;
    }
    
    //时间段线段
    previousPos = button.tag;
    
    CGFloat yOffset = 200.0f;
    
    TimelineLine *plan = [[TimelineLine alloc]init];
    self.timelineLineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scrollView.bounds.size.width, scrollView.contentSize.height)];
    [plan setImageView:timelineLineImageView setlineWidth:5.0 setColorRed:255 ColorBlue:0 ColorGreen:0 Alp:1 setBeginPointX:60 BeginPointY:button.tag*50+30 setOverPointX:60 OverPointY:(button.tag + 1 )*50+yOffset];
    timelineLineAnimation = [CATransition animation];
    timelineLineAnimation.delegate =self;
    timelineLineAnimation.duration = 2.0f;
    timelineLineAnimation.timingFunction = UIViewAnimationCurveEaseInOut;
    timelineLineAnimation.type = kCATransitionMoveIn;
    timelineLineAnimation.subtype = kCATransitionReveal;

    [timelineLineImageView.layer addAnimation:timelineLineAnimation forKey:@"animation"];
    [timelineLineImageView setUserInteractionEnabled:NO];
    
    
    [plan release];
    
    [scrollView addSubview:timelineLineImageView];
    
    //实例化弹出界面
    [[rightMessageTipViewArray objectAtIndex:button.tag] setFrame:CGRectMake(kRightMessageTipViewOffsetX, button.tag*50, 200, 200)];
    
    CATransition *animation = [CATransition animation];
    animation.delegate =self;
    animation.duration = 2.0f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransition;
    [[[rightMessageTipViewArray objectAtIndex:button.tag] layer] addAnimation:animation forKey:@"animation"];
    [[rightMessageTipViewArray objectAtIndex:button.tag] setUserInteractionEnabled:YES];
    UIView *view = [rightMessageTipViewArray objectAtIndex:button.tag];
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOffset:CGSizeMake(10, 10)];
    [view.layer setShadowOpacity:0.5];
//    view.backgroundColor = [UIColor purpleColor];
    
    
    [[timelineRoundbuttonArray objectAtIndex:button.tag] setFrame:CGRectMake(46, button.tag*50, 30, 30)];
    [[leftCellViewArray objectAtIndex:button.tag] setFrame:CGRectMake(5, button.tag*50, 40, 30)];
    
    //add new view
    UIView* cellView = [rightMessageTipViewArray objectAtIndex:button.tag];
    [cellView setFrame:CGRectMake(kRightMessageTipViewOffsetX, button.tag*50, 200, 200)];
    if (self.dataSource) {
        detailCell = [self.dataSource detailCellForRow:button.tag];
        CGRect frame =detailCell.frame;
        frame.origin.y = 50;//调整到合适的位置
        frame.origin.x = -10;
        detailCell.frame = frame;
        
        [cellView addSubview:detailCell];
    }

    //位置调整 分上下 注意！！！！
    //点击处上面的
    
    if (button.tag)
    {
        for (int i = 0; i < button.tag; i++)
        {
            [[rightMessageTipViewArray objectAtIndex:i] setFrame:CGRectMake(kRightMessageTipViewOffsetX, 0+i*50, 200, 30)];
            [[rightMessageTipViewArray objectAtIndex:i] setBackgroundColor:[UIColor clearColor]];
//            [[massageViewArray objectAtIndex:i] setUserInteractionEnabled:NO];
            
            
            [[timelineRoundbuttonArray objectAtIndex:i] setFrame:CGRectMake(46, 0+i*50, 30, 30)];
            
            [[leftCellViewArray objectAtIndex:i] setFrame:CGRectMake(5, 0+i*50, 40, 30)];
            
        }
        
        [[rightMessageTipViewArray objectAtIndex:button.tag-1] setFrame:CGRectMake(kRightMessageTipViewOffsetX, (button.tag-1)*50, 200, 30)];
        [[timelineRoundbuttonArray objectAtIndex:button.tag-1] setFrame:CGRectMake(46, (button.tag-1)*50, 30, 30)];
        [[leftCellViewArray objectAtIndex:button.tag-1] setFrame:CGRectMake(5, (button.tag-1)*50, 40, 30)];
        
    }
   
    //点击处下面的
    for (int i = button.tag + 1; i < [rightMessageTipViewArray count]; i++)
    {
        [[rightMessageTipViewArray objectAtIndex:i] setFrame:CGRectMake(kRightMessageTipViewOffsetX, yOffset+i*50, 200, 30)];
        [[rightMessageTipViewArray objectAtIndex:i] setBackgroundColor:[UIColor clearColor]];
//        [[massageViewArray objectAtIndex:i] setUserInteractionEnabled:NO];
        UIView *view = [rightMessageTipViewArray objectAtIndex:i];
        CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
        [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y-200)]];
        [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)]];
        [positionAnim setDelegate:self];
        [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [positionAnim setDuration:0.1f];
        [view.layer addAnimation:positionAnim forKey:@"positon"];
        [view setCenter:CGPointMake(view.center.x, view.center.y)];
        
        [[timelineRoundbuttonArray objectAtIndex:i] setFrame:CGRectMake(46, yOffset+i*50, 30, 30)];
        
        UIButton *button = [timelineRoundbuttonArray objectAtIndex:i];
        CABasicAnimation *positionAnim1=[CABasicAnimation animationWithKeyPath:@"position"];
        [positionAnim1 setFromValue:[NSValue valueWithCGPoint:CGPointMake(button.center.x, button.center.y-200)]];
        [positionAnim1 setToValue:[NSValue valueWithCGPoint:CGPointMake(button.center.x, button.center.y)]];
        [positionAnim1 setDelegate:self];
        [positionAnim1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [positionAnim1 setDuration:0.5f];
        [button.layer addAnimation:positionAnim1 forKey:nil];
        [button setCenter:CGPointMake(button.center.x, button.center.y)];
        
        [[leftCellViewArray objectAtIndex:i] setFrame:CGRectMake(5, yOffset+i*50, 40, 30)];
        
        UILabel *label1 = [leftCellViewArray objectAtIndex:i];
        CABasicAnimation *positionAnim2=[CABasicAnimation animationWithKeyPath:@"position"];
        [positionAnim2 setFromValue:[NSValue valueWithCGPoint:CGPointMake(label1.center.x, label1.center.y-200)]];
        [positionAnim2 setToValue:[NSValue valueWithCGPoint:CGPointMake(label1.center.x, label1.center.y)]];
        [positionAnim2 setDelegate:self];
        [positionAnim2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [positionAnim2 setDuration:0.5f];
        [label1.layer addAnimation:positionAnim2 forKey:@"positon"];
        [label1 setCenter:CGPointMake(label1.center.x, label1.center.y)];
        
    }
}

//点击后进入详情页
-(void)gotoNext
{
    NSLog(@"asd");
#if 0
    kkViewController *kk = [[[kkViewController alloc]initWithNibName:nil bundle:nil]autorelease];
    
    kk.uTag = currentPos;
    
    [self.navigationController pushViewController:kk animated:YES];
#endif
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
