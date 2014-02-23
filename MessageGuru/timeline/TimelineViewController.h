//
//  WorkViewController.h
//  Testhuitu
//
//  Created by gg on 7/1/13.
//  Copyright (c) 2013 sunland.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MakeLine.h"
#import <QuartzCore/QuartzCore.h>

//时间线view的数据回调接口
//时间线布局
/**
 *******************************************************
 ***leftcell(no:i)******************rightcell***********
 ***leftcell(no:i+1)****************detailcell**********
 ***********************************detailcell**********
 ***********************************detailcell**********
 ***leftcell(no:i+2)****************rightcell***********
 *******************************************************
 */
@protocol RMTimelineViewDataSource<NSObject>

@required

- (NSUInteger)numberOfItem;//时间线上的元素项数

- (UIView *)leftCellForRow:(NSUInteger)index;//左边的view

- (UIView *)rightCellForRow:(NSUInteger)index;//右边的view

- (UIView *)detailCellForRow:(NSUInteger)index;//展开后的view，缺省状态下隐藏

-(void)decorateButton:(UIButton*)button withinContainer:(UIView*)parent forPos:(NSUInteger)index;//显示时间线上的button后的回调
@end

@interface TimelineViewController : UIViewController<LineDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) id<RMTimelineViewDataSource> dataSource;

-(id)initWithRect:(CGRect)rc;
-(void)setBackground:(UIImage*)backgroundImage;//设置背景页面

@end
