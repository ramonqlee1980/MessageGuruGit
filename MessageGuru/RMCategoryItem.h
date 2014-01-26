//
//  RMCategory.h
//  MessageGuru
//
//  Created by Ramonqlee on 1/25/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMCategoryItem : NSObject
@property(nonatomic,copy)NSString* name;//名字，一般作为db的名字
@property(nonatomic,copy)NSString* icon;
@property(nonatomic,copy)NSString* source;//来源文件，同name，deprecated

+(id)initWithJson:(NSDictionary*)data;
@end
