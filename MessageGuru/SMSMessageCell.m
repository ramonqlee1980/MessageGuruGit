//
//  RMMessageCell.m
//  MessageGuru
//
//  Created by Ramonqlee on 1/25/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "SMSMessageCell.h"
#import "Toast+UIView.h"

@implementation SMSMessageCell
@synthesize fromUrl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma action
-(IBAction)shareBySNS:(id)sender
{
    if (self.delegate) {
        [self.delegate share:sender withText:[self getMessage]];
    }
}
-(IBAction)add2Favorite:(id)sender
{
    if (self.delegate) {
        [self.delegate add2Favorite:sender withMessage:[self getMessage]];
    }
}
-(IBAction)copy2Pasteboard:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self getMessage].content;
    
    [self makeToast:NSLocalizedString(@"copy2Pasteboard", "") duration:CSToastDefaultDuration position:CSToastCenterPosition];
}

-(RMSMS*)getMessage
{
    RMSMS* message = [[RMSMS new]autorelease];
    message.content = self.detailLabel.text;
    message.url = self.fromUrl;
    return message;
}
@end
