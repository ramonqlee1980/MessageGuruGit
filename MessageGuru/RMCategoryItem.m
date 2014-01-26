//
//  RMCategory.m
//  MessageGuru
//
//  Created by Ramonqlee on 1/25/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMCategoryItem.h"

@implementation RMCategoryItem
@synthesize name,source;
+(id)initWithJson:(NSDictionary*)data
{
    RMCategoryItem* ret = [[RMCategoryItem new]autorelease];
    if (!data) {
        return ret;
    }
    
    ret.name = [data objectForKey:@"name"];
    ret.icon = [data objectForKey:@"icon"];
    ret.source = [data objectForKey:@"file"];
    
    return ret;
}
@end
