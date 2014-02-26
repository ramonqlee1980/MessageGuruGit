//
//  RMViewController+Aux.m
//  MessageGuru
//
//  Created by ramonqlee on 2/26/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMViewController+Aux.h"



@interface UIViewController(RMViewController_Aux_Private)

@end

@implementation UIViewController(RMViewController_Aux)

- (void)addNavigationButton:(UIBarButtonItem*)leftButtonItem withRightButton:(UIBarButtonItem*)rightButtonItem;
{
    // Dispose of any resources that can be recreated.
    if (!leftButtonItem) {
        self.navigationItem.leftBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"")
                                          style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(back)] autorelease];
    }
    
    if (leftButtonItem) {
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }
    if (rightButtonItem) {
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
}

#pragma mark dismiss selector
-(IBAction)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
