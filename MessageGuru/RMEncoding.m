//
//  RMEncoding.m
//  MessageGuru
//
//  Created by ramonqlee on 3/13/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMEncoding.h"
#import "OBCConvertor.h"

@implementation RMEncoding
+(NSString*)SC2Huoxing:(NSString*)str//
{
    //TODO::简体转火星文
    return str;
}
+(NSString*)SC2Kuang:(NSString*)str
{
    //简体转边框文
    NSMutableString* ret = [[[NSMutableString alloc]init]autorelease];
    const unichar topLine = 773;
    const unichar bottomLine = 818;
    
    [ret appendFormat:@"[%C%C",topLine,bottomLine];
    for (int i=0;i<str.length;++i) {
        [ret appendFormat:@"%C%C%C",[str characterAtIndex:i],topLine,bottomLine];
    }
    [ret appendString:@"]"];
    return ret;
}
+(NSString*)SC2Juhua:(NSString*)str
{
    //简体转菊花文
    NSMutableString* ret = [[[NSMutableString alloc]init]autorelease];
    const unichar juhua = 0x0489;
    for (int i=0;i<str.length;++i) {
        [ret appendFormat:@"%C%C",[str characterAtIndex:i],juhua];
    }
    return ret;
}

+(NSString*)SC2TC:(NSString*)str
{
    //简体转繁体
    NSString* string = [[OBCConvertor getInstance] s2t:str];
    NSLog(@"%@", string);
    return string;
}


+(NSString*)SC2Pinyin:(NSString*)str withDiacritics:(BOOL)enable
{
    //简体转拼音
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, (CFStringRef)str);CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);//to pinyin
    if(!enable)
    {
        CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    }
    
    NSLog(@"%@", string);
    return (NSString*)string;
}

@end
