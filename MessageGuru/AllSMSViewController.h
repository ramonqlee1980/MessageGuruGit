//
//  ViewController.h
//  POHorizontalList
//
//  Created by Polat Olu on 17/02/2013.
//  Copyright (c) 2013 Polat Olu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POHorizontalList.h"

@interface AllSMSViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, POHorizontalListDelegate> {
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain)NSArray* categoryArray;//json data
@property(nonatomic,retain)NSMutableArray* categoryListItemArray;//ListItem data
@end
