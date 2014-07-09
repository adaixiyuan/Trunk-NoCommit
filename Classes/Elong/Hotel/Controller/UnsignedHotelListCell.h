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

@interface UnsignedHotelListCell : UITableViewCell<UIScrollViewDelegate,HttpUtilDelegate>{
@private
    UIScrollView *scrollContenView;
    UIView *backView;
    UIButton *navBtn;
    UIButton *shareBtn;
    UIButton *favBtn;
    HttpUtil *favUtil;
}
@property (nonatomic,retain) RoundCornerView *hotelImageView;
@property (nonatomic,retain) UILabel *hotelNameLbl;
@property (nonatomic,retain) UILabel *starLbl;
@property (nonatomic,retain) UILabel *priceMarkLbl;
@property (nonatomic,retain) UILabel *priceLbl;
@property (nonatomic,retain) UILabel *priceEndLbl;
@property (nonatomic,retain) UILabel *fullyBookedLbl;
@property (nonatomic,copy) NSString *hotelId;
@property (nonatomic,assign) BOOL action;
@property (nonatomic,assign) UITableView *parent;
@property (nonatomic,assign) UINavigationController *parentNav;
@property (nonatomic,assign) NSDictionary *hotelDict;
@property (nonatomic,retain) NSIndexPath *indexPath;

@property (nonatomic,retain) UILabel *referencePriceLbl;

- (void) setAction:(BOOL)action animated:(BOOL)animated;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier haveImage:(BOOL)image;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier haveImage:(BOOL)image haveAction:(BOOL)haveAction;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier haveImage:(BOOL)image haveAction:(BOOL)haveAction recommend:(BOOL)recommend;

- (void) setPrice:(NSInteger)price;

- (void) setStar:(NSInteger)level;
@end
