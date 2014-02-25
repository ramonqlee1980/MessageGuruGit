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

@end
