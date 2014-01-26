//
//  SettingsViewController.m
//  SettingsExample
//
//  Created by Jake Marsh on 10/8/11.
//  Copyright (c) 2011 Rubber Duck Software. All rights reserved.
//

#import "SettingsViewController.h"
#import "Constants.h"
#import "iRate.h"
#import "resConstants.h"
#import "UMFeedback.h"
#import "Flurry.h"
//#import "Define.h"
//#import "UIBarButtonItem+Customed.h"


NSString* reuseIdentifier = @"UITableViewCellStyleDefault";

@interface SettingsViewController ()
@end

@implementation SettingsViewController

- (id) init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) return nil;
    
//	self.title = NSLocalizedString(Tab_Title_Setting, @"Settings");
//    self.tabBarItem.image = [UIImage imageNamed:kIconSetting];
    
	return self;
}
-(void)dealloc
{
    [super dealloc];
}


#pragma mark - View lifecycle
- (void) viewDidLoad {
    [super viewDidLoad];
    
    //set status bar color
    [self.view window].backgroundColor = [UIColor blackColor];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
//    UIBarButtonItem *button =
//    [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"top_navigation_back.png"]
//                        selectedImage:[UIImage imageNamed:@"top_navigation_back.png"]
//                               target:self
//                               action:@selector(back)];
//    self.navigationItem.leftBarButtonItem = button;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self removeAllSections];
    [self addSections];
}
- (void) viewDidUnload {
    [super viewDidUnload];
    
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Workaround

- (void)mailComposeController:(MFMailComposeViewController*)controller             didFinishWithResult:(MFMailComposeResult)result                          error:(NSError*)error;
{
    if (result == MFMailComposeResultSent)
    {
        UIAlertView* alert = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"EmailAlertViewTitle", @"") message:NSLocalizedString(@"EmailAlertViewMsg", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil]autorelease];
        [alert show];
    }
    //    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#define kEmailFeedbackBody @"kEmailFeedbackBody"
// Launches the Mail application on the device.
-(void)launchMailAppOnDevice:(BOOL)feeback
{
    //    NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
    //    NSString *body = @"&body=It is raining in sunny California!";
    
    NSString * email = [NSString stringWithFormat:@"mailto:&subject=%@&body=%@", NSLocalizedString(@"Title", @""), NSLocalizedString(kEmailFeedbackBody, @"")];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayComposerSheet:(BOOL)feedback
{
    MFMailComposeViewController *picker = [[[MFMailComposeViewController alloc] init]autorelease];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:NSLocalizedString(@"Title", @"")];
    [picker setMessageBody:NSLocalizedString(kEmailFeedbackBody, @"") isHTML:NO];
    
    // Set up recipients
    //    NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
    //    NSArray *bccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    NSArray *recipients = [NSArray arrayWithObject:kDefaultEmailRecipients];
    
    //
    //    [picker setToRecipients:toRecipients];
    [picker setToRecipients:recipients];
    
    //    [self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
}
-(IBAction)feedback:(id)sender
{
#if 1
    [Flurry logEvent:kOpenFeedbackEvent];
    
    [UMFeedback showFeedback:self withAppkey:CP_UMeng_App_Key];
#else
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet:YES];
        }
        else
        {
            [self launchMailAppOnDevice:YES];
        }
    }
    else
    {
        [self launchMailAppOnDevice:YES];
    }
#endif
}
#pragma mark about
-(void)rate
{
    NSInteger appleId = kAppleId.intValue;
    if (kInvalidID!=appleId) {
        iRate* rate = [iRate sharedInstance];
        rate.appStoreID = appleId;
        
        //enable preview mode
        [rate openRatingsPageInAppStore];
        
        [Flurry logEvent:kOpenRateInSettingEvent];
    }
}
- (IBAction)modalViewAction:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(kAboutTitle, @"") message:NSLocalizedString(@"About", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK","") otherButtonTitles:nil]autorelease];
    [alert show];
}

#pragma mark addSections
-(void)addGeneralSection
{
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier =reuseIdentifier;
			cell.selectionStyle = UITableViewCellStyleDefault;
            
			cell.textLabel.text = NSLocalizedString(@"AboutTitle", @"");
            //cell.imageView.image = [UIImage imageNamed:@"General"];
		} whenSelected:^(NSIndexPath *indexPath) {
			[self modalViewAction:nil];
		}];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.cellStyle = UITableViewCellStyleDefault;
			staticContentCell.reuseIdentifier = reuseIdentifier;
            
			cell.textLabel.text = NSLocalizedString(@"kMoreFeedBackKey", @"");
            //cell.imageView.image = [UIImage imageNamed:@"Mail"];
		} whenSelected:^(NSIndexPath *indexPath) {
			[self feedback:nil];
		}];
        
        NSInteger appleId =kAppleId.intValue;
        if (kInvalidID!=appleId) {
            [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
                staticContentCell.cellStyle = UITableViewCellStyleDefault;
                staticContentCell.reuseIdentifier = reuseIdentifier;
                
                cell.textLabel.text = NSLocalizedString(@"kMoreRateKey", @"");
                //cell.imageView.image = [UIImage imageNamed:@"AppStore"];
            } whenSelected:^(NSIndexPath *indexPath) {
                [self rate];
            }];
        }
    }];
}

-(void)addSections
{
    [self addGeneralSection];
    
    [self.tableView reloadData];
}
-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end