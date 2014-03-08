//
//  RMCardEditorController.h
//  MessageGuru
//
//  Created by ramonqlee on 2/26/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//
//短信贺卡编辑界面
//1.编辑贺卡中的文字；
//2.发送给好友
//3.返回之前的界面
#import <UIKit/UIKit.h>
#import "UMSocial.h"

@interface RMCardEditorController : UIViewController<UMSocialUIDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,copy)NSString* category;//类别
@property(nonatomic,copy)NSString* msg;//信息文本
@property(nonatomic,copy)UIImage* background;//信息背景

@property(nonatomic,retain)UIImageView* backgroundImageView;
@property(nonatomic,retain)IBOutlet UITextView*  textView;
@end
