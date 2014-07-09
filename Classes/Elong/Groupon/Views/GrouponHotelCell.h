//
//  GrouponHotelCell.h
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-22.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrouponHotelCell : UITableViewCell{
@private
    UIImageView *bgImageView;
    UILabel *titleLbl;
    UILabel *detailLbl;
    UIView *splitLine;
    UIButton *phoneBtn;
    UIButton *mapBtn;
}
@property (nonatomic,readonly) UIButton *phoneBtn;
@property (nonatomic,readonly) UIButton *mapBtn;

// 设置左侧标题
- (void) setTitle:(NSString *)title;

// 设置右标题
- (void) setDetail:(NSString *)detail;

// 是否隐藏地图
- (void) setMapHidden:(BOOL)hidden;
@end
