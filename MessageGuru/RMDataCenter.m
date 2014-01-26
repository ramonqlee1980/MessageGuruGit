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
                RMCategory* rc = [RMCategory new];
                rc.name = [item objectForKey:@"category"];
                
                NSArray* arr = [item objectForKey:@"data"];
                for (NSDictionary* temp in arr) {
                    RMCategoryItem* ci = [RMCategoryItem initWithJson:temp];
                    [rc.itemArray addObject:ci];
                }
                [cArray addObject:rc];
            }
            
            [rootDict setValue:cArray forKey:key];
        }
    }
}
-(NSArray*)category:(NSString*)rootName
{
    [self loadJsonFile];
    
    return [rootDict objectForKey:rootName];
}

@end
