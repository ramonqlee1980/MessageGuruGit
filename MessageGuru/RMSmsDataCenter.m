//
//  RMSmsDataCenter.m
//  MessageGuru
//
//  Created by Ramonqlee on 1/25/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMSmsDataCenter.h"
#import "SQLiteManager.h"
#import "RMSMS.h"

@implementation RMSmsDataCenter

Impl_Singleton(RMSmsDataCenter)

-(NSArray*)sms:(NSString*)categoryName startFrom:(NSUInteger)start tillEnd:(NSUInteger)end
{
    NSString*dbName = [NSString stringWithFormat:@"%@.sqlite",categoryName];
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM Content"];
    return [RMSmsDataCenter getSqlData:dbName withSQL:query];
}
-(NSArray*)sms:(NSString*)tableName fromDb:(NSString*)dbName startFrom:(NSUInteger)start tillEnd:(NSUInteger)end
{
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    NSArray* ret = [RMSmsDataCenter getSqlData:dbName withSQL:query];
    
    //set category
    if ([ret isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray* mut = (NSMutableArray*)ret;
        for (RMSMS* message in mut) {
            message.category = tableName;
        }
    }
    return ret;
}

+(NSArray*)getSqlData:(NSString*)dbName withSQL:(NSString*)query
{
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:[NSString stringWithFormat:@"%@",dbName]]autorelease];
    
    NSMutableArray* data = [[[NSMutableArray alloc]init]autorelease];
    //
    
    //clean null rows
    //[dbManager doQuery:@"DELETE FROM Content WHERE Title is null"];
//    NSLog(@"query:%@",query);
    NSArray* rows=[dbManager getRowsForQuery:query];
    NSNull* kNull = [NSNull null];
    const NSUInteger kDupPrefixLength = 5;
    for (NSDictionary* row in rows) {
        
        id msg = [row objectForKey:@"M1"];
        if (msg==kNull) {
            msg = [row objectForKey:@"M2"];
        }
        if (msg!=kNull) {
            msg = [[msg
                    stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                   stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            if (msg && ((NSString*)msg).length!=0) {
                NSString* url = [row objectForKey:@"PageUrl"];
                RMSMS* message= [[RMSMS new]autorelease];
                message.category = dbName;
                message.content = msg;
                //remove duplicate bug(bug when collecting data)
                NSString* prefix = [message.content substringToIndex:MIN(kDupPrefixLength, message.content.length-1)];
                NSRange r = [message.content rangeOfString:prefix options:NSBackwardsSearch];
                if (r.length!=0) {
                    message.content = [message.content substringFromIndex:r.location];
                }
                message.url = url;
                
                [data addObject:message];
            }
        }
    }
    
    [dbManager closeDatabase];
    
    return data;
}
@end
