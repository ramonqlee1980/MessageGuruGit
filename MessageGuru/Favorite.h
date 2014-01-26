//
//  Favorite.h
//  MessageGuru
//
//  Created by Ramonqlee on 1/26/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMSMS.h"

@interface Favorite : NSObject
//收藏库的操作
+(void)addToSMSFavorite:(RMSMS*)message;//添加到收藏库中
+(void)removeFromFavorite:(NSString*)url;
+(NSArray*)getFavoriteValues:(NSRange)range;
@end
