//
//  ShareTools.m
//  Elong_iPad
//
//  Created by Wang Shuguang on 12-8-8.
//  Copyright 2012 elong. All rights reserved.
//

#import "ShareTools.h"
#import "ElongClientAppDelegate.h"
#import <sys/sysctl.h>
#import "WXApi.h"
#import "HotelSearchResultManager.h"
#import "TonightHotelListMode.h"
static ShareTools *shareTools = nil; 
static float lat;
static float lon;
@implementation ShareTools
@synthesize contentViewController;
@synthesize contentView;
@synthesize message;
@synthesize hotelImage;
@synthesize imageUrl;
@synthesize mailTitle;
@synthesize lat;
@synthesize lon;
@synthesize mailContent;
@synthesize msgContent;
@synthesize weiBoContent;
@synthesize mailImage;
@synthesize mailView;
@synthesize grouponId;
@synthesize needLoading;
@synthesize sharefrom;

static NSString *shareTypeNameForWX = nil;   //用来区别不同的微信分享

+(void)setShareTypeNameForWX:(NSString *)name{
    shareTypeNameForWX = name;
}

+(NSString *)shareTypeNameForWX{
    return shareTypeNameForWX;
}

+ (id) shared{
	if (shareTools == nil) {
		shareTools = [[ShareTools alloc] init];
		lat = 0;
		lon = 0;
        shareTools.hotelId = nil;
        shareTools.grouponId = 0;
	}
	return shareTools;
}

- (void) setLat:(float)tlat{
	lat = tlat;
}

- (void) setLon:(float)tlon{
	lon = tlon;
}

- (float) lat{
	return lat;
}

- (float) lon{
	return lon;
}

- (void) dealloc{
	[message release];
	[hotelImage release];
	[imageUrl release];
	[mailTitle release];
	[mailContent release];
	[msgContent release];
	[weiBoContent release];
	[mailImage release];
	[mailView release];
	[super dealloc];
}

- (void) showItems{
	UIApplication *app = [UIApplication sharedApplication];
	ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)app.delegate;
    UIViewController *controller = [appDelegate.navigationController.viewControllers lastObject];
    if ([controller isKindOfClass:[HotelSearchResultManager class]]|| [controller isKindOfClass:[TonightHotelListMode class]]) {
        customActionSheet = [[CustomActionSheet alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    }
    else
    {
        customActionSheet = [[CustomActionSheet alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    }
	customActionSheet.delegate = self;
	[customActionSheet showInView:appDelegate.window];
	
	[customActionSheet release];
}

#pragma mark -
#pragma mark CustomActionSheet delegate
-(void)clickShareCancel{
	[customActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void) clickActionSheet:(int)tag{
    
	[customActionSheet dismissWithClickedButtonIndex:0 animated:YES];

	if(tag == 3){
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
			Class messageClass = NSClassFromString(@"MFMessageComposeViewController");
			if(messageClass != nil){
				if([messageClass canSendText]){
					[self performSelector:@selector(displaySMSComposer)];
				}
				else {
					//					[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
					
					UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持短信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
					[alertView show];
					[alertView release];
				}
			}
		}else {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该系统版本不支持短信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
		
	}
	else if(tag == 2){
		Class mailClass = NSClassFromString(@"MFMailComposeViewController");
		if(mailClass != nil){
			if([mailClass canSendMail]){
				[self performSelector:@selector(displayMailComposer)];
			}
			else {				
				NSURL *url = [NSURL URLWithString:@"mailto:"];
				if([[UIApplication sharedApplication] canOpenURL:url]){
					UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"邮箱尚未设置" message:@"分享前请设置邮件账户" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"现在设置",nil];
					[alertView show];
					[alertView release];
				}else {
					UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您未安装Mail或已卸载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
					[alertView show];
					[alertView release];
				}
				
			}
		}
	}
	else if(tag == 0){
        NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
        
        if ([info objectForKey:@"sina_access_tokenV2"] == nil) {
            [[ShareKit instance] loginSinaWithType:@"send"];
            return;
        }
        if (![[ShareKit instance] checkTime:[info objectForKey:@"SinaLastTime"]]) {
            [[ShareKit instance] loginSinaWithType:@"send"];
            return;
        }
        
        //进入信息编辑页面
        [[ShareKit instance] presentSinaSendPage];
	}
	else if(tag == 1){
        NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
        
        if ([info objectForKey:@"TX_accessToken"] == nil) {
            [[ShareKit instance] loginTencentWithType:@"send"];
            return;
        }
        
        if (![[ShareKit instance] checkTime:[info objectForKey:@"TencentLastTime"]]) {
            [[ShareKit instance] loginTencentWithType:@"send"];
            return;
        }
        
        //进入信息编辑页面
        [[ShareKit instance] prensentTencentSendPage];
	}
	else if(tag==4){
        if ([[ServiceConfig share] monkeySwitch]){
            // 开着monkey时不发生事件
            return;
        }
        
        if(![WXApi isWXAppInstalled]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您没有安装微信哟！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        [ShareTools setShareTypeNameForWX:@"APPShareForWX"];    //来自app内部的分享

        
        if(self.grouponId || self.hotelId){
            WXMediaMessage *wxmessage = [WXMediaMessage message];
            wxmessage.description = msgContent;
            wxmessage.title = @"订酒店，用艺龙！";
            [wxmessage setThumbImage:[UIImage noCacheImageNamed:@"Icon.png"]];
            WXWebpageObject *ext = [WXWebpageObject object];
            if (self.grouponId) {
                ext.webpageUrl = [NSString stringWithFormat:@"http://m.elong.com/Groupon/Detail?prodId=%d",self.grouponId];
            }else if(self.hotelId){
                ext.webpageUrl = [NSString stringWithFormat:@"http://m.elong.com/hotel/detail?hotelid=%@",self.hotelId];
            }
            
            wxmessage.mediaObject = ext;
            SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
            req.bText = NO;
            req.message = wxmessage;
            req.scene = WXSceneSession; // 会话
            [WXApi sendReq:req];
        }else{
            //来自 成功页面
            SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
            req.bText = YES;
            req.text = msgContent;
            req.scene = WXSceneSession; // 会话
            [WXApi sendReq:req];
        }
        
        
	}else if(tag == 5){
        if ([[ServiceConfig share] monkeySwitch]){
            // 开着monkey时不发生事件
            return;
        }
        
        if(![WXApi isWXAppInstalled]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您没有安装微信哟！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        [ShareTools setShareTypeNameForWX:@"APPShareForWX"];    //来自app内部的分享
        
        if(self.grouponId || self.hotelId){
            WXMediaMessage *wxmessage = [WXMediaMessage message];
            wxmessage.description = msgContent;
            wxmessage.title = @"订酒店，用艺龙！";
            [wxmessage setThumbImage:[UIImage noCacheImageNamed:@"Icon.png"]];
            WXWebpageObject *ext = [WXWebpageObject object];
            
            if (self.grouponId) {
                ext.webpageUrl = [NSString stringWithFormat:@"http://m.elong.com/Groupon/Detail?prodId=%d",self.grouponId];
            }else if(self.hotelId){
                ext.webpageUrl = [NSString stringWithFormat:@"http://m.elong.com/hotel/detail?hotelid=%@",self.hotelId];
            }
            
            wxmessage.mediaObject = ext;
            SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
            req.bText = NO;
            req.message = wxmessage;
            req.scene = WXSceneTimeline;        // 朋友圈
            [WXApi sendReq:req];
        }else{
            //来自 成功页面
            SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
            req.bText = YES;
            req.text = msgContent;
            req.scene = WXSceneTimeline;        // 朋友圈
            [WXApi sendReq:req];
        }
    }
	
}


-(void) displaySMSComposer{
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.navDrawEnabled = YES;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
		MFMessageComposeViewController *messageComposeVC = [[MFMessageComposeViewController alloc] init];
		messageComposeVC.messageComposeDelegate = self;

						
		//NSString *messageBody = @"订单已成功！\n第二行\n第三行";
		[messageComposeVC setBody:msgContent];
//、        messageComposeVC.recipients = [NSArray arrayWithObject:@""];
		
		//messageComposeVC.modalPresentationStyle = UIModalPresentationFormSheet;

		if (IOSVersion_7) {
            messageComposeVC.transitioningDelegate = [ModalAnimationContainer shared];
            messageComposeVC.modalPresentationStyle = UIModalPresentationCustom;
        }
        if (IOSVersion_7) {
            [contentViewController presentViewController:messageComposeVC animated:YES completion:nil];
        }else{
            [contentViewController presentModalViewController:messageComposeVC animated:YES];
        }
		[messageComposeVC release];
	}
}

-(void) displayMailComposer{
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.navDrawEnabled = YES;
	MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
	
	mailComposeVC.mailComposeDelegate = self;
	
	[mailComposeVC setSubject:mailTitle];
	
	[mailComposeVC setMessageBody:mailContent isHTML:NO];
	UIImage *orderImage;
	if (mailView) {
		orderImage = [mailView imageByRenderingViewWithSize:mailView.frame.size];
		NSData *imageData = UIImageJPEGRepresentation(orderImage, 1.0);
		if (hotelImage) {
			[mailComposeVC addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"hotel.jpg"];
		}else {
			[mailComposeVC addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"order.jpg"];
		}
	}else if (mailImage) {
		NSData *imageData = UIImageJPEGRepresentation(mailImage, 1.0);
		if (hotelImage) {
			[mailComposeVC addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"hotel.jpg"];
		}else {
			[mailComposeVC addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"order.jpg"];
		}
	}

	
	//mailComposeVC.modalPresentationStyle = UIModalPresentationFormSheet;
	if (IOSVersion_7) {
        mailComposeVC.transitioningDelegate = [ModalAnimationContainer shared];
        mailComposeVC.modalPresentationStyle = UIModalPresentationCustom;
    }
    if (IOSVersion_7) {
        [self.contentViewController presentViewController:mailComposeVC animated:YES completion:nil];
    }else{
        [self.contentViewController presentModalViewController:mailComposeVC animated:YES];
	}
	[mailComposeVC release];
}

#pragma mark -
#pragma mark mailCompose delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
	NSString *messageResult = @"";
	if(result == MFMailComposeResultFailed){
		messageResult = @"邮件发送失败";
		UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
														   message:messageResult
														  delegate:nil
												 cancelButtonTitle:@"确定" 
												 otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	else if(result == MFMailComposeResultSent){
		messageResult = @"邮件发送成功";
		UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
														   message:messageResult
														  delegate:nil
												 cancelButtonTitle:@"确定" 
												 otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}

    if (IOSVersion_7) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }else{
        [controller dismissModalViewControllerAnimated:YES];
    }
	
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	delegate.navDrawEnabled = NO;
}



#pragma mark -
#pragma mark MessageCompose delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
	NSString *messageResult = @"";
	if(result == MessageComposeResultFailed){
		messageResult = @"短信发送失败";
		UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
														   message:messageResult
														  delegate:nil
												 cancelButtonTitle:@"确定" 
												 otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	else if(result == MessageComposeResultSent){
		messageResult = @"短信发送成功";
		UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
														   message:messageResult
														  delegate:nil
												 cancelButtonTitle:@"确定" 
												 otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	

    if (IOSVersion_7) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }else{
        [controller dismissModalViewControllerAnimated:YES];
    }
	
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	delegate.navDrawEnabled = NO;
}

#pragma mark -
#pragma mark UIAlertView delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex == 1){
		NSURL *url = [NSURL URLWithString:@"mailto:"];
		[[UIApplication sharedApplication] newOpenURL:url];
	}
}


- (id) init{
	if (self = [super init]) {
	}
	return self;
}


@end
