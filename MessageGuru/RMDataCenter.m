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
    //TODO::某个具体类别的背景图数组
}
-(NSArray*)category:(NSString*)rootName
{
    [self loadJsonFile];
    
    return [rootDict objectForKey:rootName];
}

@end
