//
//  HotelZhifubaoSuccessController.h
//  ElongClient
//
//  Created by chenggong on 13-10-21.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlipayViewController.h"

@interface HotelZhifubaoSuccessController : DPNav <HttpUtilDelegate, AlipayViewControllerDelegate>

@property (nonatomic, retain) NSNumber *orderNo;

@property (nonatomic, assign) IBOutlet UIButton *payButton;
@property (nonatomic, assign) IBOutlet UILabel *orderNoLabel;
@property (nonatomic, assign) IBOutlet UILabel *payMoney;
@property (nonatomic, assign) IBOutlet UILabel *hotelName;

- (id)initWithOrderNo:(NSNumber *)orderNo;

- (IBAction)pay:(id)sender;

- (IBAction)orderList:(id)sender;

@end
