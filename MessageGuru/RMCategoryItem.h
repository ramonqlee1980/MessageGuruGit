//
//  RMCategory.h
//  MessageGuru
//
//  Created by Ramonqlee on 1/25/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMCategoryItem : NSObject
@property(nonatomic,copy)NSString* name;//显示用名字
@property(nonatomic,copy)NSString* icon;
@property(nonatomic,copy)NSString* tablename;//表名
@property(nonatomic,copy)NSString* fromFile;//来源db文件
@property(nonatomic,copy)NSDate* date;
@property(nonatomic,retain)NSMutableArray* cards;//背景图数组

+(id)initWithJson:(NSDictionary*)data;
@end
