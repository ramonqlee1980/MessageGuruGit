//
//  RMCategoryList.m
//  MessageGuru
//
//  Created by Ramonqlee on 1/25/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMCategory.h"

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
@end
