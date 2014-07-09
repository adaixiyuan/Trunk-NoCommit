//
//  HotelListCellProtocol.h
//  ElongClient
//
//  Created by Dawn on 14-2-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum{
    HotelListActionFav,
    HotelListActionNav,
    HotelListActionShare
}HotelListActionType;

@class HotelListCell;
@protocol HotelListCellActionDelegate <NSObject>
@optional
- (void) hotelListCell:(HotelListCell *)cell didAction:(HotelListActionType) actionType;
@end

@protocol HotelListCellDataSource <NSObject>
- (void) hotelListCellFillData:(HotelListCell *)cell;
@end

@protocol HotelListCellDelegate <NSObject>
@optional
- (void) hotelListCellDidSelected:(HotelListCell *)cell;
- (void) hotelListCellDidDeselected:(HotelListCell *)cell;
- (void) hotelListCellDidAction:(HotelListCell *)cell;
@end