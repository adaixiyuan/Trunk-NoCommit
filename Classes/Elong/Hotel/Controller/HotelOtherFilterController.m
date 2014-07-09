//
//  HotelOtherFilterController.m
//  ElongClient
//
//  Created by 赵岩 on 13-7-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HotelOtherFilterController.h"

@interface HotelOtherFilterController ()

@end

@implementation HotelOtherFilterController

- (void) dealloc{
    self.couponButton = nil;
    self.withoutGuaranteedButton = nil;
    self.prepayButton = nil;
    self.apartmentButton = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _showVipContainer = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.vipButton.selected = _vip;
    
    BOOL isLogin = [[AccountManager instanse] isLogin];
    int userLevel = [[[AccountManager instanse] DragonVIP] intValue];
    if (isLogin && (userLevel == 2) && _showVipContainer) {
        self.vipContainer.hidden = NO;
    }
    else {
        self.vipContainer.hidden = YES;
    }
   
    [self updateSelected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCoupon:(BOOL)flag
{
    _coupon = flag;
    [self updateSelected];
}

- (void)setWithoutGuaranteed:(BOOL)flag
{
    _withoutGuaranteed = flag;
    
    [self updateSelected];
}

- (void)setPrepay:(BOOL)prepay
{
    _prepay = prepay;
    [self updateSelected];
}

-(void)setIsApartment:(BOOL)isApartment{
    _isApartment = isApartment;
    
    [self updateSelected];
}

- (void)updateSelected
{
    self.couponButton.selected = self.coupon;
    self.withoutGuaranteedButton.selected = self.withoutGuaranteed;
    self.prepayButton.selected = self.prepay;
    self.apartmentButton.selected = self.isApartment;
    
    self.couponButton.adjustsImageWhenHighlighted=NO;
    self.withoutGuaranteedButton.adjustsImageWhenHighlighted=NO;
    self.prepayButton.adjustsImageWhenHighlighted=NO;
    self.apartmentButton.adjustsImageWhenHighlighted=NO;
}

- (IBAction)couponTapped:(id)sender
{
    self.couponButton.selected = !self.couponButton.selected;
    _coupon = self.couponButton.selected;
    
    [self.delegate hotelOtherFilterController:self couponStatusChanged:self.coupon];
}

- (IBAction)withoutGuaranteedTapped:(id)sender
{
    self.withoutGuaranteedButton.selected = !self.withoutGuaranteedButton.selected;
    self.withoutGuaranteed = self.withoutGuaranteedButton.selected;
    
    [self.delegate hotelOtherFilterController:self withoutGuaranteedStatusChanged:self.withoutGuaranteed];
}

- (IBAction)prepayTapped:(id)sender
{
    self.prepayButton.selected = !self.prepayButton.selected;
    self.prepay = self.prepayButton.selected;
    
    [self.delegate hotelOtherFilterController:self prepayStatusChanged:self.prepay];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.vipButton = nil;
}

- (void)setVip:(BOOL)vip
{
    _vip = vip;
    self.vipButton.selected = _vip;
}

- (IBAction)vipCheckStateChanged:(id)sender
{
    self.vipButton.selected = !self.vipButton.selected;
    _vip = self.vipButton.selected;
    [_delegate hotelPriceFilterController:self vipCheckStateChanged:self.vipButton.selected];
}

-(void)apartmentTapped:(id)sender{
    self.apartmentButton.selected = !self.apartmentButton.selected;
    self.isApartment = self.apartmentButton.selected;
    
    [self.delegate hotelOtherFilterController:self isApartmentChanged:self.isApartment];
}

@end
