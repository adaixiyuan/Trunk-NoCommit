//
//  Coupon.h
//  ElongClient
//
//  Created by bin xing on 11-1-18.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelDefine.h"

@interface Coupon : DPNav <UIAlertViewDelegate> {
	IBOutlet UILabel *couponTipLabel;
	IBOutlet UILabel *maxValueTipLabel;
	IBOutlet UILabel *usedCouponTipLabel;
	IBOutlet UISlider *couponSlider;
	IBOutlet UIView *topview;
	IBOutlet UIView *botview;
    IBOutlet UIButton *ruleButton;
    IBOutlet UIView *tipView;
    UIButton *nextBtn;
}

+ (NSMutableArray *)activedcoupons;
-(IBAction)next;
-(IBAction)changeSlider:(id)sender;
-(IBAction)couponRule;

@end
