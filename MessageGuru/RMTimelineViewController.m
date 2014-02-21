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
#import "RMCategoryItem.h"

const NSUInteger kMonthNumber= 12;//一年12个月份

@interface RMTimelineViewController ()
{
    NSMutableArray* itemsAscByDateArray;
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
    TimelineViewController *childViewController = [[[TimelineViewController alloc]initWithNibName:nil bundle:nil]autorelease];
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
- (NSUInteger)numberOfItem//时间线上的元素项数
{
    return kMonthNumber;
}

- (UIView *)leftCellForRow:(NSUInteger)index//左边的view
{
    UILabel* monthlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, index*50, 40, 30)];
    monthlabel.text = [NSString stringWithFormat:@"%d月",index+1];//[arrayMonths objectAtIndex:i];
    monthlabel.font = [UIFont fontWithName:@"Noteworthy-Light" size:10];
    monthlabel.textAlignment = 1;
    monthlabel.backgroundColor = [UIColor clearColor];
    return monthlabel;
}

- (UIView *)rightCellForRow:(NSUInteger)index//右边的view
{
    UIView* massageView = [[[UIView alloc]initWithFrame:CGRectMake(80, 0, 200, 30)]autorelease];
    
    massageView.backgroundColor = [UIColor clearColor];
    UILabel* label = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, massageView.bounds.size.width, 30)]autorelease];
    label.textAlignment= 1;
    
    NSMutableString* stringBuilder = [[NSMutableString new]autorelease];
    id list = [itemsAscByDateArray objectAtIndex:index+1];
    if (list) {
        NSArray* listItems = (NSArray*)list;
        for (RMCategoryItem* item in listItems) {
            NSString *dateString = [NSDateFormatter localizedStringFromDate:item.date
                                                                  dateStyle:NSDateFormatterShortStyle
                                                                  timeStyle:NSDateFormatterShortStyle];
            NSLog(@"%@",dateString);
            [stringBuilder appendString:[NSString stringWithFormat:@"%@ %@\n",dateString,item.name]];
        }
    }
    
    [label setText:stringBuilder];
    label.font = [UIFont fontWithName:@"Noteworthy-Light" size:10];
    label.backgroundColor = [UIColor clearColor];
    
    [massageView addSubview:label];
    
    return massageView;
}

- (UIView *)detailCellForRow:(NSUInteger)index//展开后的view，缺省状态下隐藏
{
    UILabel* label = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)]autorelease];
    label.textAlignment= 1;
    
    NSMutableString* stringBuilder = [[NSMutableString new]autorelease];
    id list = [itemsAscByDateArray objectAtIndex:index+1];
    if (list) {
        NSArray* listItems = (NSArray*)list;
        for (RMCategoryItem* item in listItems) {
            NSString *dateString = [NSDateFormatter localizedStringFromDate:item.date
                                                                  dateStyle:NSDateFormatterShortStyle
                                                                  timeStyle:NSDateFormatterShortStyle];
            NSLog(@"%@",dateString);
            [stringBuilder appendString:[NSString stringWithFormat:@"%@ %@\n",dateString,item.name]];
        }
    }
    
    [label setText:stringBuilder];
    label.font = [UIFont fontWithName:@"Noteworthy-Light" size:10];
    label.backgroundColor = [UIColor clearColor];
    
    return label;
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
@end
