//
//  RMMessageCell.h
//  MessageGuru
//
//  Created by Ramonqlee on 1/25/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMSMS.h"

#define kMessageCellHeight 127.0f

@protocol MessageCellDelegate <NSObject>

-(void)share:(id)sender withText:(RMSMS*)msg;
-(void)add2Favorite:(id)sender withMessage:(RMSMS*)msg;
-(void)sendCard:(id)sender withMessage:(RMSMS*)msg;

@end

@interface SMSMessageCell : UITableViewCell

@property(nonatomic,retain)id<MessageCellDelegate> delegate;
@property(nonatomic,retain)IBOutlet UILabel* detailLabel;
@property(nonatomic,copy)NSString* fromUrl;
@property(nonatomic,retain)IBOutlet UIButton* favoriteButton;
@property(nonatomic,copy)NSString* category;

-(IBAction)shareBySNS:(id)sender;
-(IBAction)add2Favorite:(id)sender;
-(IBAction)copy2Pasteboard:(id)sender;
-(IBAction)sendCard:(id)sender;
@end
