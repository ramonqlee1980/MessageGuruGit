//
//  RMTimelineViewController.m
//  MessageGuru
//
//  Created by ramonqlee on 2/20/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMTimelineViewController.h"
#import "RMDataCenter.h"
#import "RMCategory.h"
#import "SMSListViewController.h"
#import "RMSmsDataCenter.h"
#import "Constants.h"
#import "DMScrollingTicker.h"
#import "PulsingHaloLayer.h"
#import "Flurry.h"

const NSUInteger kMonthNumber= 12;//一年12个月份

//右侧标题显示效果，跑马灯动画相关
const NSUInteger kFreezing = 1;
const NSUInteger kMaxAnimationNumber = 0;//动画播放次数
const CGFloat kLeftTextViewTextOffsetY= 10.0f;

@interface RMTimelineViewController ()
{
    NSMutableArray* itemsAscByDateArray;//12个月的数组，废弃第0个，启动第12个；每个里面是一个数组，记录具体的信息
    DMScrollingTicker* scrollingTicker;
}
@end

@implementation RMTimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadData];
    
    
    CGRect rc = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height);
    
    TimelineViewController *childViewController = [[[TimelineViewController alloc]initWithRect:rc]autorelease];//[[[TimelineViewController alloc]initWithNibName:nil bundle:nil]autorelease];
    childViewController.dataSource = self;
    [self addChildViewController:childViewController];
    [self.view addSubview:childViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark RMTimelineViewDataSource
-(void)decorateButton:(UIButton*)button  withinContainer:(UIView*)parent forPos:(NSUInteger)index
{
    //当前月的进行decorate
    NSInteger month = [RMTimelineViewController convert2DateComponents:[NSDate date]].month;
    if(!button || !parent || month!=index+1)
    {
        return;
    }
    [self pulsingView:button];
}
- (NSUInteger)numberOfItem//时间线上的元素项数
{
    return kMonthNumber;
}

- (UIView *)leftCellForRow:(NSUInteger)index//左边的view
{
    UILabel* monthlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, index*50, 40, 30)];
    monthlabel.text = [NSString stringWithFormat:@"%d月",index+1];//[arrayMonths objectAtIndex:i];
    monthlabel.font = [UIFont fontWithName:@"Noteworthy-Light" size:13];
    monthlabel.textAlignment = NSTextAlignmentRight;
    monthlabel.backgroundColor = [UIColor clearColor];
    return monthlabel;
}

- (void)singleTapAnimationView:(id)sender
{
    LPScrollingTickerLabelItem *label = (LPScrollingTickerLabelItem *)sender;
    
    [self openItemController:label.titleLabel.text];
}

//缺省显示第一个节日，点击可以跑马灯效果滚动，点击停止
- (UIView *)rightCellForRow:(NSUInteger)index//右边的view
{
    scrollingTicker = [[DMScrollingTicker alloc] initWithFrame:CGRectMake(80, 0, 200, 30)];
//    scrollingTicker.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:scrollingTicker];
    NSMutableArray *l = [[NSMutableArray alloc] init];
    NSMutableArray *sizes = [[NSMutableArray alloc] init];
    
    id list = [itemsAscByDateArray objectAtIndex:index+1];
    if (list) {
        NSArray* listItems = (NSArray*)list;
        for (RMCategoryItem* item in listItems) {
            NSString *currentDateStr = @"";
            if (item.date) {
                NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
                [dateFormat setDateFormat:@"(M/d)"];//设定时间格式,这里可以设置成自己需要的格式
                currentDateStr = [dateFormat stringFromDate:item.date];
            }
            
            LPScrollingTickerLabelItem *label = [[LPScrollingTickerLabelItem alloc] initWithTitle:item.name
                                                                                      description:currentDateStr];

            [label layoutSubviews];
            
            CGRect frame = label.frame;
            frame.origin.y = kLeftTextViewTextOffsetY;
            label.frame = frame;
            
            //添加点击时间相应
            label.userInteractionEnabled = YES;
            [label addTarget:self action:@selector(singleTapAnimationView:) forControlEvents:UIControlEventTouchUpInside];

            [sizes addObject:[NSValue valueWithCGSize:label.frame.size]];
            [l addObject:label];
        }
    }

    
    if(scrollingTicker.tag==kFreezing)
    {
        [scrollingTicker scrollToOffset:CGPointMake(80, 0) animate:YES];
    }
    else
    {
        [scrollingTicker beginAnimationWithViews:l
                                   direction:LPScrollingDirection_FromRight
                                       speed:10.0f
                                       loops:kMaxAnimationNumber
                                completition:^(NSUInteger loopsDone, BOOL isFinished) {
                                    NSLog(@"loop %d, finished? %d",loopsDone,isFinished);
                                }];
    }
    
    return scrollingTicker;
}

- (UIView *)detailCellForRow:(NSUInteger)index//展开后的view，缺省状态下隐藏
{
    NSMutableArray* listArray = [[NSMutableArray new]autorelease];

    for (RMCategoryItem* item in [itemsAscByDateArray objectAtIndex:index+1]) {
        UIImage* image = [UIImage imageNamed:item.icon];
        if (!image) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",item.name]];
        }
        if (!image) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpeg",item.name]];
        }
        [listArray addObject:[[ListItem alloc] initWithFrame:CGRectZero image:image text:item.name]];
    }
    
    POHorizontalList *horList = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 0.0, 250.0, 155.0) title:@"" items:listArray];
    horList.userInteractionEnabled = YES;
    
    [horList setDelegate:self];
    return horList;
}

#pragma mark data loading
//提取包含日期属性的item，并且按照月份进行整理，同一月份的，按照日期进行升序排序
-(void)loadData
{
    RMDataCenter* dataCenter = [RMDataCenter sharedInstance];
    NSArray* categoryArray = [dataCenter category:kSMSCategory];
    
    NSMutableArray* listArray = [[NSMutableArray new]autorelease];
    for (RMCategory* data in categoryArray) {
        if (data && data.name && data.itemArray) {
            for (RMCategoryItem* item in data.itemArray) {
                if (!item.date) {//提取包含日期的item
                    continue;
                }
                [listArray addObject:item];
            }
            
        }
    }
    
    if (!itemsAscByDateArray) {
        itemsAscByDateArray = [[NSMutableArray alloc]initWithCapacity:kMonthNumber+1];//array starting from 0
        for (NSInteger i =0; i<kMonthNumber+1; ++i) {
            NSMutableArray* item = [[NSMutableArray new]autorelease];
            [itemsAscByDateArray addObject:item];
        }
    }
    
    //按照月份进行划分，然后按照日期进行划分
    //最后的组织形式
    //一个12维度的数组，和12月份相对应
    //每个月份里，一个数组，按照日期升序排列
    for (RMCategoryItem* item in listArray) {
        NSDate* date = item.date;
        
        NSInteger month = [RMTimelineViewController convert2DateComponents:date].month;
        if (month>0&&month<=kMonthNumber)
        {
            //内部排序
            id list = [itemsAscByDateArray objectAtIndex:month];
            if (list) {
                NSMutableArray* itemList = (NSMutableArray*)list;
                
                if (itemList.count==0) {
                    [itemList addObject:item];
                }
                else
                {
                    NSInteger i = 0;
                    for (; i< itemList.count; ++i) {
                        RMCategoryItem* currentItem = (RMCategoryItem*)[itemList objectAtIndex:i];
                        if ([currentItem.date compare:item.date]==NSOrderedDescending) {
                            [itemList insertObject:item atIndex:i];
                            break;
                        }
                    }
                    
                    //append it if fail to insert it
                    if (i==itemList.count) {
                        [itemList addObject:item];
                    }
                }
            }
        }
    }
    
}

+(NSDateComponents*)convert2DateComponents:(NSDate*)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date]; // Get necessary date components
    return components;
}

#pragma mark
//从item的name对应的db文件中，读取数据
-(RMCategoryItem*)categoryItemForItem:(NSString*)displayName
{
    for (NSArray* list in itemsAscByDateArray) {
        for (RMCategoryItem* item in list) {
            if ([displayName isEqualToString:item.name]) {
                return item;
            }
        }
    }
    return nil;
}
- (void) didSelectItem:(ListItem *)item
{
    NSLog(@"Horizontal List Item %@ selected", item.imageTitle);
    [self openItemController:item.imageTitle];
}

- (void) openItemController:(NSString *)title
{
    [RMTimelineViewController openItemController:[self categoryItemForItem:title] withinController:self];
}

//进入指定类别的详细列表
+ (void) openItemController:(RMCategoryItem *)categoryItem withinController:(UIViewController*)controller
{
    NSDictionary* dict = [NSDictionary dictionaryWithObject:categoryItem.name forKey:kOpenSMSCategory];
    [Flurry logEvent:kOpenSMSCategory withParameters:dict];
    
    SMSListViewController* detailMsgViewController = [[SMSListViewController new]autorelease];
    
    detailMsgViewController.smsArray = [[RMSmsDataCenter sharedInstance]sms:categoryItem.tablename fromDb:categoryItem.fromFile startFrom:0 tillEnd:kMaxLoadingNumber];
    
    UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:detailMsgViewController];
    detailMsgViewController.navigationItem.title = categoryItem.name;
    
    [controller presentViewController:navi animated:YES completion:nil];
}
@end
