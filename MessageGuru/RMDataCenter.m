//
//  RMDataCenter.m
//  MessageGuru
//
//  Created by Ramonqlee on 1/25/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMDataCenter.h"
#import "RMCategoryItem.h"
#import "RMCategory.h"

@interface RMDataCenter()
{
    NSMutableDictionary* rootDict;
    NSMutableDictionary* categoryItems;
}
@end
@implementation RMDataCenter
Impl_Singleton(RMDataCenter)

-(void)loadJsonFile
{
    if (rootDict) {
        return;
    }
    
    
    //load data from json file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (res && [res isKindOfClass:[NSDictionary class]]) {
        rootDict = [NSMutableDictionary new];
        
        for (NSString* key in [res allKeys]) {
            NSArray* categoryArray = [res objectForKey:key];
            NSMutableArray* cArray = [NSMutableArray new];
            for (NSDictionary* item in categoryArray) {
                [cArray addObject:[RMCategory initWithDict:item]];
            }
            
            [rootDict setValue:cArray forKey:key];
        }
    }
}

-(NSArray*)cards:(NSString*)tableName
{
    //default backgrounds
    NSArray* defaultRet = [NSArray arrayWithObjects:@"chris.jpg",@"b1.jpg",@"b2.jpg",@"b3.jpg",@"b4.jpg",@"b5.jpg",@"b6.jpg",nil];
    if (tableName==nil||tableName.length==0)
    {
        return defaultRet;
    }
    
    //make sure json file loaded
    [self loadJsonFile];
    
    //cache rmcategoryitems with name as key
    if(!categoryItems)
    {
        categoryItems = [NSMutableDictionary new];
    }
    //TODO::某个具体类别的背景图数组
    //find cache first
    id obj = [categoryItems objectForKey:tableName];
    if (obj) {
        NSArray* cards = ((RMCategoryItem*)obj).cards;
        return (cards&&cards.count>0)?cards:defaultRet;
    }
    
    //search and cache items
    for (NSString* rootKey in [rootDict allKeys]) {
        for (RMCategory* category in [rootDict objectForKey:rootKey]) {
            for (RMCategoryItem* item in category.itemArray) {
                [categoryItems setValue:item forKey:item.name];
                if ([tableName isEqualToString:item.name]) {
                    return (item.cards && item.cards.count>0)?item.cards:defaultRet;
                }
            }
        }
    }
    return defaultRet;
}

-(NSArray*)category:(NSString*)rootName
{
    [self loadJsonFile];
    
    return [rootDict objectForKey:rootName];
}

@end
