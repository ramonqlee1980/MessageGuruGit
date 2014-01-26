//
//  RMCategoryList.h
//  MessageGuru
//
//  Created by Ramonqlee on 1/25/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMCategory : NSObject
@property(nonatomic,copy)NSString* name;
@property(nonatomic,assign)BOOL hot;//是否热门
@property(nonatomic,retain)NSMutableArray* itemArray;
+(id)initWithDict:(NSDictionary*)data;
@end
