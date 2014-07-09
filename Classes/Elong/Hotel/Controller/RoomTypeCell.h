//
//  RoomTypeCell.h
//  ElongClient
//
//  Created by bin xing on 11-1-11.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelDefine.h"
#define ROOMTYPELOGIN @"ROOMTYPELOGIN"
#define ROOMTYPERSGISTER @"ROOMTYPERSGISTER"
@class IconAndTextView;
@interface RoomTypeCell : UITableViewCell {
	UILabel *roomTypeNameLabel;
	UILabel *roomPriceLabel;			// 原价
	UIButton *couponbtn;
	UILabel *description;
	
	IconAndTextView *breakfarstView;
	IconAndTextView *bedView;
	IconAndTextView *netView;
	IconAndTextView *areaView;
	IconAndTextView *floorView;
    UILabel *giftLbl;
    UIButton *giftMoreBtnOther;
	
	IBOutlet UIImageView *bottomShadow;		// 底部阴影，位置可变
    HttpUtil *sevenDaysUtil;
    BOOL fromloginsuccess;
    int m_netstate;
    
    UIButton *breakfastBtn;
    UIImageView *popView;
    UIView *popMarkView;
}

@property (nonatomic,retain) UIImageView *timelimitImg;                     // 限时抢
@property (nonatomic,retain) IBOutlet UIImageView *discountImg;				// 特价图片
@property (nonatomic,retain) IBOutlet UIImageView *DragonVIPImg;			// 特价图片
@property (nonatomic,retain) IBOutlet UIImageView *roomImg;					// 房型图片
@property (nonatomic,retain) IBOutlet UIImageView *separatorLine;
@property (nonatomic,retain) IBOutlet UIImageView *prepayIcon;
@property (nonatomic,retain) IBOutlet UILabel *roomTypeNameLabel;
@property (nonatomic,retain) IBOutlet UILabel *roomPriceLabel;
@property (nonatomic,retain) IBOutlet UILabel *remainroomstockLabel;
@property (nonatomic,retain) UIButton *bookbtn;
@property (nonatomic,retain) IBOutlet UIButton *couponbtn;                  // 返现图标
@property (nonatomic,retain) IBOutlet UIButton *giftBtn;                    // 礼品图标
@property (nonatomic,retain) IBOutlet UIButton *giftMoreBtn;                // 礼品更多
@property (nonatomic,retain) IBOutlet UILabel *description;
@property (nonatomic,retain) IBOutlet UILabel *roomMarkLabel;				// 原价币种符号
@property (nonatomic,retain) IBOutlet UILabel *discountPriceLabel;			// 特价价格
@property (nonatomic,retain) IBOutlet UILabel *discountMarkLabel;			// 特价币种符号
@property (nonatomic,retain) IBOutlet UIView  *lineView;					// 原价上的黑线
@property (nonatomic,retain) IBOutlet UIView  *backView;					// 灰色部分背景
@property (nonatomic,assign) int roomindex;			// 灰色部分背景
@property (nonatomic, copy) NSString *countNO;
@property (nonatomic,retain) IBOutlet UIImageView *bottomShadow;

-(IBAction)booking;
- (void)adjustBackView:(BOOL)hasImage giftDes:(NSString *)gift;				// 根据是否有图片调整
- (void)makeRoomIconsByData:(NSArray *)datas HaveImage:(BOOL)haveImage;	// 根据数据生成房间描述icon
- (void) setRoomTypeName:(NSString *)name breakfastNum:(NSInteger)num;
@end
