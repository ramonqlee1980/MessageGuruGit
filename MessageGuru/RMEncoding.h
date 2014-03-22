//
//  RMEncoding.h
//  MessageGuru
//
//  Created by ramonqlee on 3/13/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMEncoding : NSObject
+(NSString*)SC2Kuang:(NSString*)str;//转边框文
+(NSString*)SC2TC:(NSString*)str;//简体转繁体
+(NSString*)SC2Huoxing:(NSString*)str;//简体转火星文
+(NSString*)SC2Pinyin:(NSString*)str withDiacritics:(BOOL)enable;//简体转拼音
+(NSString*)SC2Juhua:(NSString*)str;//简体转菊花文
@end
