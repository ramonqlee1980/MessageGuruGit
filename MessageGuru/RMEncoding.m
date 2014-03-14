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
    return @"";
}
+(NSString*)SC2Juhua:(NSString*)str//
{
    //TODO::简体转菊花文
    unichar utf16_string[] = {0x0489};
    NSString *tmp = [[NSString alloc] initWithBytes:utf16_string
                                             length:sizeof(utf16_string) / sizeof(utf16_string[0])
                                           encoding:NSUTF16StringEncoding
                     ];
    const char *utf8_string = [tmp UTF8String];
    
    NSString* r = [NSString stringWithFormat:@"我%@爱%@",tmp,tmp];
    return r;
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
