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
#if 0//deprecated
    NSString* cards = [data objectForKey:@"card"];
    if(cards)
    {
        ret.cards = [[NSMutableArray alloc]init];
        // "card":"b1.jpg;b2.jpg",
        [ret.cards addObjectsFromArray:[cards componentsSeparatedByString:@";"]];
    }
#endif
    
    NSBundle* bundle = [NSBundle mainBundle];
    NSString *homeDir = [bundle resourcePath];
    homeDir = [NSString stringWithFormat:@"%@/card/%@/",homeDir,ret.name];
    NSArray* allFiles = [RMCategoryItem getFilenamelistOfType:@"" fromDirPath:homeDir];
    if (allFiles&&allFiles.count>0) {
        ret.cards = [[NSMutableArray alloc]init];
        [ret.cards addObjectsFromArray:allFiles];
    }
    
    
    return ret;
}
+(NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath
{
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:10];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullpath]) {
            if ((type==nil||type.length==0)||[[filename pathExtension] isEqualToString:type]) {
                [filenamelist  addObject:fullpath];
            }
        }
    }
    
    return filenamelist;
}
+(BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}
@end
