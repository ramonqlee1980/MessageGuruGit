//
//  MakeLine.h
//  Testhuitu
//
//  Created by gg on 7/1/13.
//  Copyright (c) 2013 sunland.com. All rights reserved.
//
/*
 1、创建对象并自动将背景设置成透明
 2、按照方法输入数值自动将两点绘制成直线
 3、自定义宽度、颜色、透明度
*/
#import <Foundation/Foundation.h>

@protocol LineDelegate <NSObject>
@optional
-(void)setImageView:(UIImageView *)imageview setlineWidth:(float)lineWidth setColorRed:(float)colorR ColorBlue:(float)colorB ColorGreen:(float)colorG Alp:(float)alp setBeginPointX:(int)x BeginPointY:(int)y setOverPointX:(int)ox OverPointY:(int)oy;
@end
