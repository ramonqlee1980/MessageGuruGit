//
//  RMSmsDataCenter.h
//  MessageGuru
//
//  Created by Ramonqlee on 1/25/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"

@interface RMSmsDataCenter : NSObject
Decl_Singleton(RMSmsDataCenter);

//-(NSArray*)sms:(NSString*)categoryName startFrom:(NSUInteger)start tillEnd:(NSUInteger)end __attribute__((deprecated));

-(NSArray*)sms:(NSString*)tableName fromDb:(NSString*)dbName startFrom:(NSUInteger)start tillEnd:(NSUInteger)end;

@end
