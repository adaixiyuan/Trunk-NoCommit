//
//  Coupon.m
//  ElongClient
//
//  Created by bin xing on 11-1-18.
//  Copyright 2011 DP. All rights reserved.
//

#import "Coupon.h"
#import "CouponRule.h"

static NSMutableArray *activedcoupons = nil;

@implementation Coupon


- (id)init {
    if (self = [super initWithTopImagePath:@"" andTitle:_string(@"s_select_coupon") style:_NavNormalBtnStyle_]) {
        
    }
    
    return  self;
}

- (void)backhome {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:ORDER_FILL_ALERT
												   delegate:self 
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:@"确认", nil];
	[alert show];
	[alert release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (0 != buttonIndex) {
		[super backhome];
	}
}

+ (NSMutableArray *)activedcoupons  {
	@synchronized(self) {
		if(!activedcoupons) {
			activedcoupons = [[NSMutableArray alloc] init];
		}
	}
	return activedcoupons;
}
-(IBAction)changeSlider:(id)sender{
	UISlider *slider=sender;
	NSString *currentString=[NSString stringWithFormat:@"%.0f",slider.value];
	
	int currentValue=[currentString intValue];
	int totalValue = [[[Coupon activedcoupons] safeObjectAtIndex:0] intValue];
	usedCouponTipLabel.text=[NSString stringWithFormat:_string(@"s_coupon_tip2"),currentValue,totalValue - currentValue];


}
-(void)updateCouponState{
	NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
	
	int roomcount=[[HotelPostManager hotelorder] getRoomCount];
	NSDate *ad=[TimeUtils parseJsonDate:[[HotelPostManager hotelorder] getArriveDate]];
	NSDate *ld=[TimeUtils parseJsonDate:[[HotelPostManager hotelorder] getLeaveDate]];
	int days=([ld timeIntervalSince1970]-[ad timeIntervalSince1970])/(24*60*60);
	int totalValue = [[[Coupon activedcoupons] safeObjectAtIndex:0] intValue];
	
	int max=[[[room safeObjectForKey:@"HotelCoupon"] safeObjectForKey:@"TrueUpperlimit"] intValue]*roomcount*days;

	if (max > totalValue) {
		max = totalValue;
	}
	
    [ruleButton setBackgroundImage:COMMON_BUTTON_PRESSED_IMG forState:UIControlStateHighlighted];
	couponTipLabel.text=[NSString stringWithFormat:_string(@"s_coupon_tip3"),totalValue,max];
	couponSlider.maximumValue=max;
	couponSlider.minimumValue=0;
	couponSlider.value=max;
    [couponSlider setThumbImage:[UIImage imageNamed:@"sliderControl.png"] forState:UIControlStateNormal];
	[couponSlider setThumbImage:[UIImage imageNamed:@"sliderControl.png"] forState:UIControlStateHighlighted];
	[couponSlider setMinimumTrackImage:[UIImage stretchableImageWithPath:@"track_blue.png"] forState:UIControlStateNormal];
	[couponSlider setMaximumTrackImage:[UIImage stretchableImageWithPath:@"track.png"] forState:UIControlStateNormal];
    
	maxValueTipLabel.text=[NSString stringWithFormat:_string(@"s_coupon_cash"),max];
	if (totalValue == 0) {
		couponSlider.value=0;
		couponSlider.enabled=NO;
		usedCouponTipLabel.text=_string(@"s_coupon_tip1");
	}else {
		couponSlider.enabled=YES;
		usedCouponTipLabel.text=[NSString stringWithFormat:_string(@"s_coupon_tip2"),max,totalValue-max];
	}

}
-(void)couponRule{
	
	CouponRule *couponRule = [[CouponRule alloc] initFromOrderFlow:YES];
	[self.navigationController pushViewController:couponRule animated:YES];
	[couponRule release];


}

-(void)viewDidLoad{
	[super viewDidLoad];
	[self updateCouponState];
	
    nextBtn = [UIButton uniformButtonWithTitle:@"下一步" 
                                               ImagePath:@"next_sign.png" 
                                                  Target:self 
                                                  Action:@selector(next) 
                                                   Frame:CGRectMake(15, 220, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT)];
	[self.view addSubview:nextBtn];
    
    [self adjustScreen];
}

#pragma mark -
#pragma mark Screen Fit
- (void) adjustScreen{
    float offset = COEFFICIENT_Y - 1;
    topview.frame = CGRectOffset(topview.frame, 0, topview.frame.origin.y * offset);
    botview.frame = CGRectOffset(botview.frame, 0, botview.frame.origin.y * offset);
    //ruleButton.frame = CGRectOffset(ruleButton.frame, 0, ruleButton.frame.origin.y * offset);
    tipView.frame = CGRectOffset(tipView.frame, 0, tipView.frame.origin.y * offset);
    nextBtn.frame = CGRectOffset(nextBtn.frame, 0, nextBtn.frame.origin.y * offset);
}

-(void)useCounpos{
	NSString *currentString=[NSString stringWithFormat:@"%.0f",couponSlider.value];
	int num=[currentString intValue];
	NSMutableArray *useccoupon=[[NSMutableArray alloc] init];
	
	// 手动构造一个coupon
	NSDictionary *coupon = [NSDictionary dictionaryWithObjectsAndKeys:
							NUMBER(0), @"CouponId",
							NUMBER(0), @"CouponTypeId",
							@"0", @"CouponCode",
							NUMBER(1), @"Status",
							[TimeUtils makeJsonDateWithUTCDate:[NSDate date]], @"EffectiveDateFrom",
							[TimeUtils makeJsonDateWithUTCDate:[NSDate date]], @"EffectiveDateTo",
							NUMBER(0), @"CardNo",
							NUMBER(num), @"CouponValue",nil];
	[useccoupon addObject:coupon];

	[[HotelPostManager hotelorder] setCoupons:useccoupon];
	[useccoupon release];
	
}


-(IBAction)next{
	if (couponSlider.value==0) {
		[[HotelPostManager hotelorder] setClearCoupons];
	}else {
		[self useCounpos];
	}

	ConfirmHotelOrder *hotelconfirmorder = [[ConfirmHotelOrder alloc] init];
	[self.navigationController pushViewController:hotelconfirmorder animated:YES];
	[hotelconfirmorder release];


}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
	SFRelease(couponTipLabel);
	SFRelease(maxValueTipLabel);
	SFRelease(usedCouponTipLabel);
	SFRelease(couponSlider);
	SFRelease(topview);
	SFRelease(botview);
	SFRelease(ruleButton);
    SFRelease(tipView);
}


- (void)dealloc {
	[couponTipLabel release];
	[maxValueTipLabel release];
	[usedCouponTipLabel release];
	[couponSlider release];
	[topview release];
	[botview release];
    [ruleButton release];
    [tipView release];
	
    [super dealloc];
}


@end
