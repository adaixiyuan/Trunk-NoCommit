//
//  FlightListCell.h
//  ElongClient
//  机票列表cell
//  Created by dengfang on 11-1-13.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FlightListCell : UITableViewCell {
	IBOutlet UILabel *priceLabel;
	IBOutlet UILabel *discountLabel;
	IBOutlet UILabel *airCorpLabel;
	IBOutlet UILabel *flightNumLabel;
	IBOutlet UILabel *departAirPortLabel;
	IBOutlet UILabel *arrivalAirPortLabel;
	IBOutlet UILabel *departTimeLabel;
	IBOutlet UILabel *arrivalTimeLabel;
	IBOutlet UILabel *airFlightType;// 机型
    IBOutlet UIImageView* FlightIcon; //icon
	IBOutlet UILabel* ticketlessLabel;  //剩余多少张，个位数
	IBOutlet UILabel* ticketmoreLabel;  //A 充足
	IBOutlet UILabel* ticketpieceLabel;
    
    UIButton *selectBtn;
}

@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) UILabel *discountLabel;
@property (nonatomic, retain) UILabel *airCorpLabel;
@property (nonatomic, retain) UILabel *flightNumLabel;
@property (nonatomic, retain) UILabel *departAirPortLabel;
@property (nonatomic, retain) UILabel *arrivalAirPortLabel;
@property (nonatomic, retain) UILabel *departTimeLabel;
@property (nonatomic, retain) UILabel *arrivalTimeLabel;
@property (nonatomic, retain) UILabel *airFlightType;
@property (nonatomic, retain) UIImageView* FlightIcon;
@property (nonatomic, retain) UILabel *ticketlessLabel;
@property (nonatomic, retain) UILabel *ticketmoreLabel;
@property (nonatomic, retain) UILabel *ticketpieceLabel;
@property (nonatomic, retain) IBOutlet UILabel *originPriceLabel;    // 显示原价
@property (nonatomic, retain) IBOutlet UILabel *priceSign;
@property (nonatomic, retain) IBOutlet UILabel *stateLabel;          // 机票特殊状态显示（中转、经停）
@property (nonatomic, retain) IBOutlet UIImageView *dash;
@property (nonatomic, retain) IBOutlet UIImageView *rightArrow;
@property (nonatomic, retain) IBOutlet UIImageView *tFlightIcon;     // 中转航班部分下半部的控件，下同
@property (nonatomic, assign) IBOutlet UIImageView *couponIcon;      // 返现icon
@property (nonatomic, retain) IBOutlet UILabel *tAirCorpLabel;
@property (nonatomic, retain) IBOutlet UILabel *tDepartAirPortLabel;
@property (nonatomic, retain) IBOutlet UILabel *tArrivalAirPortLabel;
@property (nonatomic, retain) IBOutlet UILabel *tFlightNumLabel;
@property (nonatomic, retain) IBOutlet UILabel *tAirFlightType;
@property (nonatomic, retain) IBOutlet UILabel *tDepartTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *tArrivalTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *tickNumTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *couponLabel;         // 显示返现金额
@property (nonatomic, retain) IBOutlet UIView *infoView;             // 显示信息的view（不包含中转）
@property (nonatomic, retain) IBOutlet UIView *originView;           // 显示原始价格和划线的view
@property (nonatomic, retain) IBOutlet UIImageView *discountIcon;    // 艺龙优惠的标签
@property (nonatomic, retain) IBOutlet UIImageView *priceLine;   // 划价线
@property (nonatomic, retain) IBOutlet UILabel *rmbLabel;
@property (nonatomic, retain) IBOutlet UILabel *qiLabel;

- (void)setTransitModel:(BOOL)animated;          // 设置为中转样式
- (void)setDiscountModel:(BOOL)animated WithOriginPrice:(NSString *)originPrice;   // 设置为特价模式

@end
