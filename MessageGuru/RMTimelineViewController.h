//
//  RMTimelineViewController.h
//  MessageGuru
//
//  Created by ramonqlee on 2/20/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineViewController.h"
#import "POHorizontalList.h"
#import "RMCategoryItem.h"

@interface RMTimelineViewController : UIViewController<RMTimelineViewDataSource,POHorizontalListDelegate>

//进入指定类别的详细列表
+ (void) openItemController:(RMCategoryItem *)categoryItem withinController:(UIViewController*)controller;
@end
