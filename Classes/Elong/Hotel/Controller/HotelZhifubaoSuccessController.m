//
//  HotelZhifubaoSuccessController.m
//  ElongClient
//
//  Created by chenggong on 13-10-21.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HotelZhifubaoSuccessController.h"
#import "Utils.h"
#import "PostHeader.h"
#import "AccountManager.h"
#import "ElongURL.h"
#import "AlipayViewController.h"
#import "OrderManagement.h"

@interface HotelZhifubaoSuccessController ()

@end

@implementation HotelZhifubaoSuccessController

- (void)dealloc
{
    [_orderNo release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.payButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_normal.png"] forState:UIControlStateNormal];
    [self.payButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_press.png"] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.payButton = nil;
    self.orderNoLabel = nil;
    self.hotelName = nil;
}

- (id)initWithOrderNo:(NSNumber *)orderNo
{
    if (self = [super initWithTopImagePath:@"" andTitle:@"支付订单" style:_NavOnlyHomeBtnStyle_]) {
        self.orderNo = orderNo;
        
        self.orderNoLabel.text = [orderNo stringValue];
        self.payMoney.text = [NSString stringWithFormat:@"￥%0.f", [[HotelPostManager hotelorder] getTotalPrice]];
        self.hotelName.text = [[HotelDetailController hoteldetail] safeObjectForKey:@"HotelName"];
    }
    
    return self;
}

#pragma mark - Actions

- (IBAction)pay:(id)sender
{
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
    [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
    [mutDict safeSetObject:self.orderNo forKey:@"OrderId"];
    [mutDict safeSetObject:[[AccountManager instanse] cardNo] forKey:@"MemberId"];
        
    NSString *reqParam = [NSString stringWithFormat:@"action=SendThirdPartyPayment&version=1.2&compress=true&req=%@", [mutDict JSONRepresentationWithURLEncoding]];
    [Utils orderRequest:HOTELSEARCH req:reqParam delegate:self];
    [mutDict release];
}

- (IBAction)orderList:(id)sender
{
    OrderManagement *order = nil;
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	if (appDelegate.isNonmemberFlow) {
        order = [[OrderManagement alloc] initWithNibName:@"OrderManagementNoInterHotel" bundle:nil];
    }
    else {
        order = [[OrderManagement alloc] initWithNibName:nil bundle:nil];
    }
    order.isFromOrder = YES;
    [self.navigationController pushViewController:order animated:YES];
    [order release];
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[root objectForKey:@"PaymentUrl"]];
    
    AlipayViewController *alipayVC = [[AlipayViewController alloc] init];
    alipayVC.requestUrl = url;
    alipayVC.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:alipayVC];
    
    if (IOSVersion_7) {
        nav.transitioningDelegate = [ModalAnimationContainer shared];
        nav.modalPresentationStyle = UIModalPresentationCustom;
    }
    if (IOSVersion_7) {
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        [self presentModalViewController:nav animated:YES];
    }
    
    [alipayVC release];
    [nav release];
}

- (void)action
{    
    [[HotelPostManager hotelorder] setOrderNo:self.orderNo];
    HotelOrderSuccess *hotelordersuccess = [[HotelOrderSuccess alloc] init];
    [self.navigationController pushViewController:hotelordersuccess animated:YES];
    [hotelordersuccess release];
}

- (void)alipayDidPayed:(AlipayViewController *)controller
{
    [self performSelector:@selector(action) withObject:self afterDelay:0.5];
}

@end
