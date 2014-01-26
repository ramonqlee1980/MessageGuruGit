//
//  ViewController.h
//  POHorizontalList
//
//  Created by Polat Olu on 17/02/2013.
//  Copyright (c) 2013 Polat Olu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POHorizontalList.h"

//#define kEnableData

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, POHorizontalListDelegate> {
#ifdef kEnableData
    NSMutableArray *freeList;
    NSMutableArray *paidList;
    NSMutableArray *grossingList;
#endif
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
