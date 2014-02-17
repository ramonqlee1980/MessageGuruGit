//
//  RMMessageListViewController.m
//  MessageGuru
//
//  Created by Ramonqlee on 1/25/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "SMSListViewController.h"
#import "SMSMessageCell.h"
#import "UMSocialControllerService.h"
#import "WXApi.h"
#import "Constants.h"
#import "Favorite.h"
#import "Toast+UIView.h"

NSString *CellIdentifier = @"SMSMessageCell";

@interface SMSListViewController ()

@end

@implementation SMSListViewController
@synthesize smsArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设定返回按钮
    self.navigationItem.leftBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@"返回"
                                      style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(back)] autorelease];
    
    // 注册自定义Cell的到TableView中，并设置cell标识符为CellIdentifier
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMessageCellHeight;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
#ifdef kEnableData
    return 2;
#else
    return self.smsArray?self.smsArray.count:0;
#endif
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMSMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    // Configure the cell...
#ifdef kEnableData
    cell.detailLabel.text = [NSString stringWithFormat:@"text no %d",indexPath.row];
#else
    cell.detailLabel.text = [self getMessage:indexPath].content;
#endif
    cell.fromUrl = [self getMessage:indexPath].url;
    return cell;
}
-(RMSMS*)getMessage:(NSIndexPath*)indexPath
{
    return [self.smsArray objectAtIndex:indexPath.row];
}
#pragma mark dismiss selector
-(IBAction)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)share:(id)sender withText:(RMSMS*)message
{
    [self showShareView:sender withText:message.content withImage:nil];
}

-(void)add2Favorite:(id)sender withMessage:(RMSMS *)msg
{
    [Favorite addToSMSFavorite:msg];
    [self.view makeToast:NSLocalizedString(@"Add2FavoriteToast", "") duration:CSToastDefaultDuration position:CSToastCenterPosition];
}

- (void)showShareView:(id)sender withText:(NSString*)text withImage:(UIImage*)image{
    //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:CP_UMeng_App_Key
                                      shareText:text
                                     shareImage:image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSms,UMShareToEmail,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToQzone,UMShareToFacebook,UMShareToTwitter,nil]
                                       delegate:self];
}
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    //weixin
//    if ([platformName isEqualToString:UMShareToWechatSession] ||
//        [platformName isEqualToString:UMShareToWechatTimeline] ) {
//        socialData.extConfig.wxMessageType = UMSocialWXMessageTypeApp;
//        socialData.extConfig.appUrl = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8",kAppleId];
//    }
}

#pragma mark umeng sns delegate
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
//        NSString* snsName = [[response.data allKeys] objectAtIndex:0];
//        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:snsName,kSNSPlatformKey, nil];
    }
}

@end
