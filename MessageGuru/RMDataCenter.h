//
//  RMDataCenter.h
//  MessageGuru
//
//  Created by Ramonqlee on 1/25/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"

#define kSMSCategory @"sms"

@interface RMDataCenter : NSObject
Decl_Singleton(RMDataCenter);
-(NSArray*)category:(NSString*)rootName;
-(NSArray*)cards:(NSString*)tableName;//某个具体类别的背景图数组
@end
