//
//  RMCategory.m
//  MessageGuru
//
//  Created by Ramonqlee on 1/25/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMCategoryItem.h"

@implementation RMCategoryItem
@synthesize name,fromFile,tablename,icon,date,cards;
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
    //TODO::获取日期
    id d = [data objectForKey:@"date"];
    if (d) {
        NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        ret.date = [dateFormatter dateFromString:(NSString*)d];
    }
    
    //TODO::解析card，保存到数组中
    NSString* cards = [data objectForKey:@"card"];
    if(!ret.cards)
    {
        ret.cards = [NSMutableArray new];
    }
    [ret.cards addObject:@"b1.jpg"];
        
    return ret;
}
@end
