//
//  HotViewController.m
//  MessageGuru
//
//  Created by Ramonqlee on 1/27/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "HotViewController.h"
#import "RMDataCenter.h"
#import "RMCategory.h"
#import "RMCategoryItem.h"

@interface HotViewController ()

@end

@implementation HotViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark data loading
-(void)loadData
{
    RMDataCenter* dataCenter = [RMDataCenter sharedInstance];
    NSMutableArray* cArray = [[NSMutableArray new]autorelease];
    self.categoryArray = [dataCenter category:kSMSCategory];
    
    for (RMCategory* data in self.categoryArray) {
        
        if (data && data.name && data.hot && data.itemArray) {//filter hot only
            [cArray addObject:data];
            NSMutableArray* listArray = [NSMutableArray new];
            for (RMCategoryItem* item in data.itemArray) {
                [listArray addObject:[[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:item.icon] text:item.name]];
            }
            
            if (!self.categoryListItemArray) {
                self.categoryListItemArray = [NSMutableArray new];
            }
            [self.categoryListItemArray addObject:listArray];
        }
    }
    
    self.categoryArray = cArray;
}
@end
