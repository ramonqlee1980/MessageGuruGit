//
//  RMCardEditorController.m
//  MessageGuru
//
//  Created by ramonqlee on 2/26/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMCardEditorController.h"
#import <QuartzCore/QuartzCore.h>

@interface RMCardEditorController ()

@end

@implementation RMCardEditorController
@synthesize msg,background;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.msgTextView) {
        [self.msgTextView setText:msg];
    }
    
    if (self.background) {
        self.backgroundImageView.image = self.background;
    }
    
    //TODO::左右button，左边返回，右边发送
    SEL selector = @selector(addNavigationButton:withRightButton:);
    if ([self respondsToSelector:selector]) {
        [self addNavigationButton:nil withRightButton:nil];
    }
    
    [self textViewBoundingBox:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark util methods
//textview 边框
-(void)textViewBoundingBox:(BOOL)visible
{
    CGColorRef colr = visible?[UIColor grayColor].CGColor:[UIColor clearColor].CGColor;
    
    self.msgTextView.layer.borderColor = colr;
    self.msgTextView.layer.borderWidth = 2.0;
    self.msgTextView.layer.cornerRadius =5.0;
}
//TODO::获取指定区域的截图，生成贺卡
-(UIImage*)generateScreenShot
{
    return nil;
}

@end
