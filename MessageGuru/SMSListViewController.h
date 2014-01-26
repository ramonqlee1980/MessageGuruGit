//
//  RMMessageListViewController.h
//  MessageGuru
//
//  Created by Ramonqlee on 1/25/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSMessageCell.h"
#import "UMSocial.h"

//#define kEnableData
@interface SMSListViewController : UITableViewController<MessageCellDelegate,UMSocialUIDelegate>

@property(nonatomic,retain)NSArray* smsArray;
@end
