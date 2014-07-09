//
//  selectCityCell.h
//  ElongClient
//  城市列表选择cell
//  Created by elong lide on 11-12-30.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface selectCityCell : UITableViewCell {
@private
    UIImageView *splitView;
}

@property(nonatomic ,retain) UILabel* city_label;
@property(nonatomic ,retain) UIImageView* gpsView;
@property (nonatomic, assign) BOOL isInterHotelType;  // 是否显示国际酒店样式
@property (nonatomic, readonly) UIImageView *splitView;
@end
