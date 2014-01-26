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
+(NSArray*)getSqlData:(NSString*)dbName withSQL:(NSString*)query
{
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:[NSString stringWithFormat:@"%@",dbName]]autorelease];
    
    NSMutableArray* data = [[[NSMutableArray alloc]init]autorelease];
    //
    
    //clean null rows
    //[dbManager doQuery:@"DELETE FROM Content WHERE Title is null"];
//    NSLog(@"query:%@",query);
    NSArray* rows=[dbManager getRowsForQuery:query];
    
    for (NSDictionary* row in rows) {
        
        NSString* msg = [row objectForKey:@"M1"];
        if (!msg) {
            msg = [row objectForKey:@"M2"];
        }
        if (msg) {
            msg = [[msg
                    stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                   stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString* url = [row objectForKey:@"PageUrl"];
            RMSMS* message= [[RMSMS new]autorelease];
            message.content = msg;
            message.url = url;
            [data addObject:message];
        }
    }
    
    [dbManager closeDatabase];
    
    return data;
}
@end
