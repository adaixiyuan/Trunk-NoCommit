//
//  FlightMoreRule.h
//  ElongClient
//  机票详细页面更多规则的弹出框
//  Created by elong lide on 12-1-11.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPViewTopBar.h"
#import "Utils.h"

@interface FlightMoreRule : UIViewController<DPViewTopBarDelegate> {
	DPViewTopBar *dpViewTopBar;  //顶部的
	
	NSString *returnstr; //退票
	NSString *changestr; //改签
	
	IBOutlet UILabel* returnLabel;
	IBOutlet UILabel* changetitleLabel;
	IBOutlet UILabel* changeLabel;
	IBOutlet UIImageView* lineimage;
	IBOutlet UIImageView* bottomLineImage;
	IBOutlet UIScrollView *mainView;
	UIViewController* mcontroller;   //详细页面指针
}

@property (nonatomic, assign) BOOL isShow;

- (void)dpViewLeftBtnPressed;
- (void)showSelectTable:(UIViewController *)controller; //显示
- (void)setReturnInfo:(NSString *)returnStr changeInfo:(NSString *)changeStr;


@end
