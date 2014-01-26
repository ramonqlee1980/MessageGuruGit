//
//  RMFavoriteViewController.m
//  MessageGuru
//
//  Created by Ramonqlee on 1/26/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMFavoriteViewController.h"
#import "SMSMessageCell.h"
#import "Favorite.h"
#import "Constants.h"

#define kMaxFavoriteCount 1000

@interface RMFavoriteViewController ()

@end

@implementation RMFavoriteViewController
//@synthesize favoriteButton;

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
    
	// Do any additional setup after loading the view.
    NSRange range = NSMakeRange(0, kMaxFavoriteCount);
    self.smsArray = [Favorite getFavoriteValues:range];
    //注册一个数据变更的通知处理，当数据变更时，更新数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notification:) name:kFavoriteDBChangedEvent object:nil];
}

-(void)notification:(NSNotification*)notify
{
    NSRange range = NSMakeRange(0, kMaxFavoriteCount);
    self.smsArray = [Favorite getFavoriteValues:range];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMSMessageCell *cell = (SMSMessageCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.favoriteButton.hidden = YES;

    return cell;
}
@end
