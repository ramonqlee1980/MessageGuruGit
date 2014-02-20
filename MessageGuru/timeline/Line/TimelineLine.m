//
//  PlanLine.m
//  Testhuitu
//
//  Created by gg on 7/1/13.
//  Copyright (c) 2013 sunland.com. All rights reserved.
//

#import "TimelineLine.h"

@implementation TimelineLine
@synthesize delegate;

-(void)setImageView:(UIImageView *)imageview setlineWidth:(float)lineWidth setColorRed:(float)colorR ColorBlue:(float)colorB ColorGreen:(float)colorG Alp:(float)alp setBeginPointX:(int)x BeginPointY:(int)y setOverPointX:(int)ox OverPointY:(int)oy
{
    UIGraphicsBeginImageContext(imageview.frame.size);
    [imageview.image drawInRect:CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height)];
    
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),lineWidth);//线条宽度
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);//是否圆角
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), colorR, colorB, colorG, alp);//颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());//开始绘制
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), x, y);//开始点
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), ox, oy);//结束点
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
@end
