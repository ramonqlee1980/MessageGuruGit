//
//  RMCategoryList.m
//  MessageGuru
//
//  Created by Ramonqlee on 1/25/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMCategory.h"
#import "RMCategoryItem.h"

@implementation RMCategory
@synthesize name,itemArray;
-(id)init
{
    self = [super init];
    if (self) {
        itemArray = [NSMutableArray new];
    }
    return self;
}
+(id)initWithDict:(NSDictionary*)item
{
    RMCategory* rc = [[RMCategory new]autorelease];
    rc.name = [item objectForKey:@"category"];
    rc.hot = (nil!=[item objectForKey:@"hot"]);
    
    NSArray* arr = [item objectForKey:@"data"];
    for (NSDictionary* temp in arr) {
        RMCategoryItem* ci = [RMCategoryItem initWithJson:temp];
        //按照时间进行排序
        if (rc.itemArray.count==0 || (!ci.date)) {
            [rc.itemArray addObject:ci];
        }
        else
        {
            NSInteger i =0;
            for (; i<rc.itemArray.count; ++i) {
                RMCategoryItem* currentItem = [rc.itemArray objectAtIndex:i];
                if (!currentItem.date) {
                    continue;
                }
                if ([currentItem.date compare:ci.date]==NSOrderedDescending) {
                    [rc.itemArray insertObject:ci atIndex:i];
                    break;
                }
            }
            
            if (i==rc.itemArray.count) {
                [rc.itemArray addObject:ci];
            }
        }
    }
    
    return rc;
}
@end
