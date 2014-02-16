//
//  RMCategory.m
//  MessageGuru
//
//  Created by Ramonqlee on 1/25/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMCategoryItem.h"

@implementation RMCategoryItem
@synthesize name,fromFile,tablename,icon;
+(id)initWithJson:(NSDictionary*)data
{
    RMCategoryItem* ret = [[RMCategoryItem new]autorelease];
    if (!data) {
        return ret;
    }
    
    ret.name = [data objectForKey:@"name"];
    ret.icon = [data objectForKey:@"icon"];
    ret.tablename = [data objectForKey:@"tablename"];
    if (ret.tablename==nil || ret.tablename.length==0) {
        ret.tablename = ret.name;
    }
    ret.fromFile = [data objectForKey:@"file"];
    
    return ret;
}
@end
