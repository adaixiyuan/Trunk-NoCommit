//
//  CouponRule.h
//  ElongClient
//
//  Created by bin xing on 11-3-12.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"

@interface CouponRule : DPNav <UIAlertViewDelegate> {
@private
	BOOL showBackHomeTip;			// 按home键时是否出现提示
}

- (id)initFromOrderFlow:(BOOL)isInOrder;

@end
