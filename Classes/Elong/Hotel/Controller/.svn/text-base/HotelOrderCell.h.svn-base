//
//  HotelOrderCell.h
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-10.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HotelOrderCell : UITableViewCell{
@private
    UIImageView *arrowView;
    UILabel *titleLbl;
    UILabel *detailLbl;
    UITextField *textField;
    UIImageView *topSplitView;
    UIImageView *bottomSplitView;
    UIImageView *dashView;
}
@property (nonatomic,retain) UITextField *textField;
@property (nonatomic,assign) CellType cellType;

// 设置Arrow的可见性
- (void) setArrowHidden:(BOOL)hidden;
// 设置左侧标题
- (void) setTitle:(NSString *)title;
// 设置右标题
- (void) setDetail:(NSString *)detail;
// 设置常用联系人是否可见
- (void) setCustomerHidden:(BOOL)hidden;
// 显示全部的分割线（横线）
- (void)disWholeSplitLine;
@end
