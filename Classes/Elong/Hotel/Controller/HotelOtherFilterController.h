//
//  HotelOtherFilterController.h
//  ElongClient
//
//  Created by 赵岩 on 13-7-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountManager.h"

@protocol HotelOtherFilterDelegate;

@interface HotelOtherFilterController : DPNav

@property (nonatomic, assign) BOOL coupon;
@property (nonatomic, assign) BOOL withoutGuaranteed;
@property (nonatomic, assign) BOOL prepay;
@property (nonatomic,assign) BOOL isApartment;

@property (nonatomic, assign) id<HotelOtherFilterDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIButton *couponButton;
@property (nonatomic, retain) IBOutlet UIButton *withoutGuaranteedButton;
@property (nonatomic, retain) IBOutlet UIButton *prepayButton;
@property(nonatomic,retain) IBOutlet UIButton *apartmentButton;

@property (nonatomic, assign) IBOutlet UIButton *vipButton;
@property (nonatomic, assign) IBOutlet UIView *vipContainer;
@property (nonatomic, assign) BOOL vip;
@property (nonatomic, assign) BOOL showVipContainer;

- (IBAction)vipCheckStateChanged:(id)sender;


- (IBAction)couponTapped:(id)sender;

- (IBAction)withoutGuaranteedTapped:(id)sender;

- (IBAction)prepayTapped:(id)sender;

-(IBAction)apartmentTapped:(id)sender;

@end

@protocol HotelOtherFilterDelegate <NSObject>

- (void)hotelOtherFilterController:(HotelOtherFilterController *)filter couponStatusChanged:(BOOL)value;

- (void)hotelOtherFilterController:(HotelOtherFilterController *)filter withoutGuaranteedStatusChanged:(BOOL)value;

- (void)hotelOtherFilterController:(HotelOtherFilterController *)filter prepayStatusChanged:(BOOL)value;

-(void)hotelOtherFilterController:(HotelOtherFilterController *)filter isApartmentChanged:(BOOL)value;

- (void)hotelPriceFilterController:(HotelOtherFilterController *)priceFilter vipCheckStateChanged:(BOOL)value;
@end
