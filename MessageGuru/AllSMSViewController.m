//
//  ViewController.m
//  POHorizontalList
//
//  Created by Polat Olu on 15/02/2013.
//  Copyright (c) 2013 Polat Olu. All rights reserved.
//

#import "AllSMSViewController.h"
#import "RMDataCenter.h"
#import "RMCategory.h"
#import "RMCategoryItem.h"
#import "RMSmsDataCenter.h"
#import "Constants.h"
#import "RMTimelineViewController.h"
#import "RMViewController+Aux.h"

@interface AllSMSViewController ()
{
}
@end

@implementation AllSMSViewController
@synthesize categoryArray,categoryListItemArray;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if(IOS7)
    {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    [self loadData];
    [self addMobisageBanner];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma tableview data source
- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return categoryListItemArray?categoryListItemArray.count:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    RMCategory* category = [self.categoryArray objectAtIndex:indexPath.row];
    NSString *title = category.name;
    
    POHorizontalList *list = [[[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 155.0) title:title items:[self.categoryListItemArray objectAtIndex:indexPath.row]]autorelease];
    
    [list setDelegate:self];
    [cell.contentView addSubview:list];
    
    return cell;
}

#pragma mark  POHorizontalListDelegate
//从item的name对应的db文件中，读取数据
-(RMCategoryItem*)categoryItemForItem:(NSString*)displayName
{
    for (RMCategory* category in self.categoryArray) {
        for (RMCategoryItem* item in category.itemArray) {
            if ([displayName isEqualToString:item.name]) {
                return item;
            }
        }
    }
    return nil;
}
- (void) didSelectItem:(ListItem *)item {
    [RMTimelineViewController openItemController:[self categoryItemForItem:item.imageTitle] withinController:self];
}

#pragma mark data loading
-(void)loadData
{
    RMDataCenter* dataCenter = [RMDataCenter sharedInstance];
    self.categoryArray = [dataCenter category:kSMSCategory];
    
    for (RMCategory* data in self.categoryArray) {
        if (data && data.name && data.itemArray) {
            NSMutableArray* listArray = [NSMutableArray new];
            for (RMCategoryItem* item in data.itemArray) {
                UIImage* image = [UIImage imageNamed:item.icon];
                if (!image) {
                    image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",item.name]];
                }
                if (!image) {
                    image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpeg",item.name]];
                }
                [listArray addObject:[[ListItem alloc] initWithFrame:CGRectZero image:image text:item.name]];
            }
            
            if (!self.categoryListItemArray) {
                self.categoryListItemArray = [NSMutableArray new];
            }
            [self.categoryListItemArray addObject:listArray];
        }
    }
}
#pragma mark mobisage banner
-(void)addMobisageBanner
{
    UIView* banner = [self getMobisageBanner];
    self.tableView.tableFooterView = banner;
    [self.tableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
}

@end