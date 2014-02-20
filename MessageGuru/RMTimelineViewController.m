//
//  RMTimelineViewController.m
//  MessageGuru
//
//  Created by ramonqlee on 2/20/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMTimelineViewController.h"


@interface RMTimelineViewController ()

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
    return 12;
}

- (UIView *)leftCellForRow:(NSUInteger)index//左边的view
{
    UILabel* monthlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, index*50, 40, 30)];
    monthlabel.text = [NSString stringWithFormat:@"Month %d",index+1];//[arrayMonths objectAtIndex:i];
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
    
    int x = 50;
    NSString *str = [NSString stringWithFormat:@"You have %d notes",x];
    [label setText:str];
    label.font = [UIFont fontWithName:@"Noteworthy-Light" size:10];
    label.backgroundColor = [UIColor clearColor];
    
    [massageView addSubview:label];
    
    return massageView;
}

- (UIView *)detailCellForRow:(NSUInteger)index//展开后的view，缺省状态下隐藏
{
    UILabel* label = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)]autorelease];
    label.textAlignment= 1;
    
    int x = 50;
    NSString *str = [NSString stringWithFormat:@"detail view %d notes",x];
    [label setText:str];
    label.font = [UIFont fontWithName:@"Noteworthy-Light" size:10];
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}
@end
