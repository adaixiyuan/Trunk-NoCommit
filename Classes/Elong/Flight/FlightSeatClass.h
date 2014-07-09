//
//  FlightSeatClass.h
//  ElongClient
//  单个舱位的页面
//  Created by elong lide on 12-1-9.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightDetail.h"

@interface FlightSeatClass : UIViewController {
	BOOL isSelected;
	IBOutlet UILabel* seattypeNameLabel;
	IBOutlet UIImageView *bgImgView;
	IBOutlet UIImageView *selectImgView;
	IBOutlet UILabel *eachpriceLabel;
    IBOutlet UILabel*  seatPriceLabel;
    IBOutlet UILabel*  airTaxLabel;
    IBOutlet UILabel*  oilTaxLabel;
	FlightDetail* detail;    //所在的detail指针
    IBOutlet UILabel*  returnTitleLabel;
	IBOutlet UILabel*  returnDetailLabel;
	IBOutlet UILabel*  changeDetailLabel;
	IBOutlet UILabel*  changeTitleLabel;
	IBOutlet UIImageView* rightarrow;
	IBOutlet UIButton*  moredetailbtn;
    UIButton *orderButton;
}

@property (nonatomic) BOOL isSelected;
@property (nonatomic, retain) UIImageView *iconImgView;
@property (nonatomic, retain) UIImageView *selectImgView;
@property (nonatomic, retain) UILabel *eachpriceLabel;
@property (nonatomic, retain) UILabel*  seatPriceLabel;
@property (nonatomic, retain) IBOutlet UILabel *dicountLabel;
@property (nonatomic, retain) UILabel*  airTaxLabel;
@property (nonatomic, retain) UILabel*  oilTaxLabel;
@property (nonatomic, retain) FlightDetail* detail;
@property (nonatomic, retain) UILabel*  returnDetailLabel;
@property (nonatomic, retain) UILabel*  changeDetailLabel;
@property (nonatomic, retain) UILabel*  changeTitleLabel;
@property (nonatomic, retain) UIImageView* rightarrow;
@property (nonatomic, retain) UILabel*  seattypeNameLabel;
@property (nonatomic, retain) UIButton*  moredetailbtn;
@property (nonatomic, assign) IBOutlet UIImageView *couponIcon;
@property (nonatomic, retain) IBOutlet UILabel *couponLabel;
@property (nonatomic, retain) IBOutlet UILabel *upperHalfLabel;
@property (nonatomic, retain) IBOutlet UILabel *lowerHalfLabel;
@property (nonatomic, retain) IBOutlet UILabel *tReturnDetailLabel;
@property (nonatomic, retain) IBOutlet UILabel *tChangeDetailLabel;
@property (nonatomic, retain) IBOutlet UILabel *tChangeTitleLabel;
@property (nonatomic, assign) IBOutlet UILabel *originPriceLabel;       // 显示原价
@property (nonatomic, retain) IBOutlet UIImageView *tRightarrow;
@property (nonatomic, assign) IBOutlet UIImageView *discountIcon;       // 立减标签
@property (nonatomic, assign) IBOutlet UIImageView *priceLine;          // 划价线
@property (nonatomic, retain) IBOutlet UIButton *tMoredetailbtn;
@property (nonatomic, retain) IBOutlet UIView *transView;

- (void)setTransitModel:(BOOL)animated;     // 切换中转与非中转航班的布局
- (void)setDiscountModel:(BOOL)isDiscount WithOriginPrice:(NSString *)originPrice;   // 设置为立减模式布局

@end
