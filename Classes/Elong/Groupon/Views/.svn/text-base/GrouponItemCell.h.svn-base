//
//  GrouponItemCell.h
//  ElongClient
//
//  Created by Dawn on 13-6-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicMethods.h"

@class StarsView;
@interface GrouponItemCell : UITableViewCell{
@private
    UIImageView *hotelImageView;
    UILabel *hotelNameLbl;
    UILabel *salePriceLbl;
    UILabel *grouponNumLbl;
    UILabel *grouponAddtionInfoLbl;  //团购结构话数据
    UILabel *orgPriceLabel;
    UILabel *poiLbl;
    UIImageView *orgPriceLine; //划价
    UIImageView *discountImgTmp;   //手机专项
    UILabel *orgPriceHintLabelTmp;
    UILabel *starLbl;   //星级
}
@property (nonatomic,copy) NSString *hotelId;
@property (nonatomic,readonly) UIImageView *hotelImageView;

- (void) setHotelImage:(UIImage *)image;
- (void) setHotelName:(NSString *)hotelName;
- (void) setSalePrice:(NSString *)price;
- (void) setGrouponNum:(NSString *)grouponNum;
- (void) setOrgPrice:(NSString *)price;
- (void) setPoi:(NSString *)poi;
-(void) setDiscountImgTmp:(BOOL) isDis;    //是否手机专项
-(void) setStarLbl:(int) starCode;
//设置附加信息
-(void) setGrouponAddtionInfoLbl:(NSString *) desp;
@end
