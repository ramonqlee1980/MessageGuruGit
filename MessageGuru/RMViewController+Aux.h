//
//  RMViewController+Aux.h
//  MessageGuru
//
//  Created by ramonqlee on 2/26/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonDelegate <NSObject>

-(UIBarButtonItem*)buttonItem;
-(void)buttonAction;

@end

@interface UIViewController(RMViewController_Aux)

- (void)addNavigationButton:(UIBarButtonItem*)leftButtonItem withRightButton:(UIBarButtonItem*)rightButtonItem;
-(UIView*)getMobisageBanner;
-(UIView*)clientView;
//采用一个跳动的view进行装饰当前view
-(void)pulsingView:(UIView*)decoratedView;
-(void)pulsingView:(UIView*)decoratedView withRadius:(CGFloat)radius withColor:(UIColor *)color;
@end
