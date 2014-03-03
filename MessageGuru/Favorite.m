//
//  Favorite.m
//  MessageGuru
//
//  Created by Ramonqlee on 1/26/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "Favorite.h"
#import "SQLiteManager.h"
#import "StringUtil.h"
#import "Constants.h"

@implementation Favorite

+(void)addToSMSFavorite:(RMSMS*)message
{
    [Favorite makeSureDBExist];
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:FAVORITE_DB_NAME]autorelease];
    
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT INTO '%@' ('%@','%@','%@') VALUES ('%@','%@','%@')",
                     kDBTableName, kDBSMSMessageColumn,kDBSMSKeyColumn,kDBSMSCategoryColumn,message.content,message.url,message.category];
    [dbManager doQuery:sql];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kFavoriteDBChangedEvent object:nil];
}
+(void)makeSureDBExist
{
    SQLiteManager* dbManager = [[[SQLiteManager alloc]initWithDatabaseNamed:FAVORITE_DB_NAME]autorelease];
    if (![dbManager openDatabase]) {
        //create table
        
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT,%@ TEXT  PRIMARY KEY,%@ TEXT)",kDBTableName,kDBSMSMessageColumn,kDBSMSKeyColumn,kDBSMSCategoryColumn];
        [dbManager doQuery:sqlCreateTable];
        
        [dbManager closeDatabase];
    }
}
+(void)removeFromFavorite:(NSString*)url
{
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:FAVORITE_DB_NAME]autorelease];
    NSString *sql = [NSString stringWithFormat:@"delete from '%@' where '%@' = '%@'",kDBTableName,kDBSMSKeyColumn,url];
    [dbManager doQuery:sql];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kFavoriteDBChangedEvent object:nil];
}
+(NSArray*)getFavoriteValues:(NSRange)range
{
    return  [Favorite getTableValue:FAVORITE_DB_NAME withTableName:kDBTableName withRange:range];
}
+(NSArray*)getTableValue:(NSString*)dbName withTableName:(NSString*)tableName withRange:(NSRange)range
{
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:dbName]autorelease];
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %d OFFSET %d",tableName,range.length,range.location];
    
//    NSLog(@"query:%@",query);
    
    NSMutableArray* data = [[[NSMutableArray alloc]init]autorelease];
    
    NSArray* items =  [dbManager getRowsForQuery:query];
    //    for (NSDictionary* item in items)
    for (NSInteger i = items.count-1; i>=0;i--)//descending order
    {
        NSDictionary* item = [items objectAtIndex:i];
        RMSMS* message = [[[RMSMS alloc]init]autorelease];
       
        message.content = [item objectForKey:kDBSMSMessageColumn];
        message.url = [item objectForKey:kDBSMSKeyColumn];
        message.category = [item objectForKey:kDBSMSCategoryColumn];
        //
        if (!message.url|| message.url.length==0) {
            message.url = kChannelUrl;
        }
        message.url = [message.url sqliteUnescape];
        message.content = [message.content sqliteUnescape];
        [data addObject:message];
    }
    return data;
}
@end
