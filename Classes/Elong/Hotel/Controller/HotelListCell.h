//
//  HotelListCell.h
//  ElongClient
//
//  Created by Dawn on 13-12-9.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundCornerView.h"
#import "HotelListConfig.h"
#import "HotelListCellProtocol.h"

@interface HotelListCell : UITableViewCell<UIScrollViewDelegate>{
@private
    UIScrollView *scrollContenView;
    UIView *backView;
    UIButton *navBtn;
    UIButton *shareBtn;
    UIButton *favBtn;
}
@property (nonatomic,retain) RoundCornerView *hotelImageView;
@property (nonatomic,retain) UILabel *hotelNameLbl;
@property (nonatomic,retain) UIImageView *wifiImageView;
@property (nonatomic,retain) UIImageView *parkImageView;
@property (nonatomic,retain) UIImageView *promotionImageView;
@property (nonatomic,retain) UIImageView *vipImageView;
@property (nonatomic,retain) UILabel *starLbl;
@property (nonatomic,retain) UILabel *commentLbl;
@property (nonatomic,retain) UILabel *addressLbl;
@property (nonatomic,retain) UILabel *priceMarkLbl;
@property (nonatomic,retain) UILabel *priceLbl;
@property (nonatomic,retain) UIImageView *backImageView;
@property (nonatomic,retain) UILabel *backPriceLbl;
@property (nonatomic,retain) UILabel *originalPriceLbl;
@property (nonatomic,retain) UILabel *priceEndLbl;
@property (nonatomic,retain) UILabel *fullyBookedLbl;
@property (nonatomic,assign) BOOL action;
@property (nonatomic,retain) NSIndexPath *indexPath;
@property (nonatomic,assign) NSInteger dataIndex;
@property (nonatomic,assign) BOOL isLM;
@property (nonatomic,retain) UILabel *recommendLbl;
@property (nonatomic,assign) BOOL recommend;
@property (nonatomic,readonly) UIImageView *dashView;
@property (nonatomic,retain) UILabel *referencePriceLbl;

@property (nonatomic,assign) id<HotelListCellActionDelegate> actionDelegate;
@property (nonatomic,assign) id<HotelListCellDelegate> delegate;
@property (nonatomic,assign) id<HotelListCellDataSource> dataSource;

// 设置当前抽屉动画的状态，拉出或这关闭
- (void) setAction:(BOOL)action animated:(BOOL)animated;

// haveImage：列表的当前模式，有图或者无图
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier haveImage:(BOOL)image;

// haveAction：是否启用抽屉动画
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier haveImage:(BOOL)image haveAction:(BOOL)haveAction;

// recommend： 是否PSG推荐
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier haveImage:(BOOL)image haveAction:(BOOL)haveAction recommend:(BOOL)recommend;

// 重置价格
- (void) setPrice:(NSInteger)price;

// 重置星级
- (void) setStar:(NSInteger)level;

// 重置公寓星级
- (void) setStarFromHouse:(NSInteger)level;

// 重置frame
- (void) resetPromotionFrame;

// 刷新数据
- (void) reloadCell;
@end
