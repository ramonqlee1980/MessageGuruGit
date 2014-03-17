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
#import "Constants.h"
#import "Favorite.h"
#import "Toast+UIView.h"
#import "Flurry.h"
#import "Card/RMCardEditorController.h"
#import "Utils.h"
#import "RMViewController+Aux.h"

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
    [self addMobisageBanner];
}
-(void)addMobisageBanner
{
    UIView* banner = [self getMobisageBanner];
    self.tableView.tableHeaderView = banner;
    [self.tableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
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
    RMSMS* message = [self getMessage:indexPath];
    // Configure the cell...
#ifdef kEnableData
    cell.detailLabel.text = [NSString stringWithFormat:@"text no %d",indexPath.row];
#else
    cell.detailLabel.text = message.content;
#endif
    cell.fromUrl = message.url;
    cell.category = message.category;
    
    //如果还没有使用过短信贺卡功能，则对第一个的短信贺卡分享按钮添加特效
    if (indexPath.row==0) {
        [self decorateSendCardButton:cell];
    }
    return cell;
}

-(void)decorateSendCardButton:(SMSMessageCell *)cell
{
    //获取是否点击过的标示
    if ([Utils sendCardTouched]) {
        return;
    }
    [self pulsingView:cell.sendCardButton];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self share:nil withText:[self getMessage:indexPath]];
}
#pragma mark util methods
-(RMSMS*)getMessage:(NSIndexPath*)indexPath
{
    RMSMS* message = [self.smsArray objectAtIndex:indexPath.row];
//    message.category = self.categroy;
    
    return message;
}
#pragma mark dismiss selector
-(IBAction)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark delegate methods
-(void)share:(id)sender withText:(RMSMS*)message
{
    [self showShareView:sender withText:message.content withImage:nil];
}

-(void)add2Favorite:(id)sender withMessage:(RMSMS *)msg
{
    NSDictionary* dict = [NSDictionary dictionaryWithObject:msg.content forKey:kSaveSMS];
    [Flurry logEvent:kSaveSMS withParameters:dict];
    
    [Favorite addToSMSFavorite:msg];
    [self.view makeToast:NSLocalizedString(@"Add2FavoriteToast", "") duration:CSToastDefaultDuration position:CSToastCenterPosition];
}
-(void)sendCard:(id)sender withMessage:(RMSMS*)msg
{
    RMCardEditorController* cardController = [RMCardEditorController new];
    
    UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:cardController];
    cardController.msg = msg.content;
    cardController.category = msg.category;
    UIImage* background = [UIImage imageNamed:@"chris.jpg"];
    cardController.background = background;
    
    [self  presentViewController:navi animated:YES completion:nil];
    
    [Utils touchSendCard];
}

#pragma mark util methods
- (void)showShareView:(id)sender withText:(NSString*)text withImage:(UIImage*)image{
    NSDictionary* dict = [NSDictionary dictionaryWithObject:text forKey:kSNSShareEvent];
    [Flurry logEvent:kSNSShareEvent withParameters:dict];
    
    //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUMeng_App_Key
                                      shareText:text
                                     shareImage:image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSms,UMShareToEmail,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToTencent,
                                                 /*UMShareToYXSession,UMShareToYXTimeline,UMShareToLWSession,UMShareToLWTimeline,*/UMShareToRenren,UMShareToDouban,UMShareToQzone,UMShareToFacebook,UMShareToTwitter,nil]
                                       delegate:self];
}
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    //weixin
//    if ([platformName isEqualToString:UMShareToWechatSession] ||
//        [platformName isEqualToString:UMShareToWechatTimeline] ) {
//        socialData.extConfig.wxMessageType = UMSocialWXMessageTypeApp;
//        socialData.extConfig.title = NSLocalizedString(@"Title", @"");
//        socialData.extConfig.appUrl = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8",kAppleId];
//    }
}

#pragma mark umeng sns delegate
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        NSString* snsName = [[response.data allKeys] objectAtIndex:0];
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:snsName,kSNSPlatformKey, nil];
        [Flurry logEvent:kShareBySNSResponseEvent withParameters:dict];
    }
}

@end
