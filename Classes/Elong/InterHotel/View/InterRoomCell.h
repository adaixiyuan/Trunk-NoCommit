//
//  InterRoomCell.h
//  ElongClient
//
//  Created by Ivan.xu on 13-6-18.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundCornerView.h"
#import "RoundCornerView+WebCache.h"

//typedef enum{
//    Middle = 0,
//    Bottom = 1
//}CellType;


@protocol InterRoomDelegate <NSObject>

@optional
-(void)bookingRoom; //预订
-(void)goRoomDetailWithIndex:(int)index;        //查看房间详情

@end


@interface InterRoomCell : UITableViewCell

+(int)currentSelectedRoomIndex;     //选择房间的索引
+(void)setSelectedRoomIndex:(int)index;

@property(nonatomic,assign) id<InterRoomDelegate> delegate;
@property(nonatomic) float cellHeight;

@property(nonatomic,retain) UILabel *roomNameLabel;     //房间名
@property(nonatomic,retain) RoundCornerView *roomIconImg;       //房间图片
@property(nonatomic,retain) UILabel *breakfastLabel;        //早餐提示
@property(nonatomic,retain) UILabel *smokeLabel;       //吸烟提示
@property(nonatomic,retain) UILabel *bedTypeLabel;      //床型提示
@property(nonatomic,retain) UILabel *netTypeLabel;      //网络提示

@property(nonatomic) BOOL isAllowBooking; //是否能够预订
-(void)defaultUISetting;        //默认UI设置
-(void)noneIconUISetting;       //无房型图片设置
-(void)setOriginPrice:(NSString *)originPrice;      //原价,传入时，请带入价格符号
-(void)setActualPrice:(NSString *)actualPrice;      //折价 ，传入时，不用带入价格符号
-(void)setPromotionNote:(NSString *)promotionNote;  //促销信息
-(void)setRemainRoomNum:(int)num;       //显示剩余房间
- (void) setDiscountPrice:(CGFloat)price;
-(void)setGiftCardPrice:(float)price;       //设置预付卡

@end
