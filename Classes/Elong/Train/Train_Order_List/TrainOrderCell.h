//
//  TrainOrderCell.h
//  ElongClient
//
//  Created by bruce on 13-12-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainOrderCell : UITableViewCell
{
@private
    UIImageView *arrowView;
    UILabel *titleLbl;
    UILabel *unitPriceLabel;
    UILabel *detailLbl;
    UIImageView *topSplitView;
    UIImageView *bottomSplitView;
    UIImageView *dashView;
}

// 设置左侧标题
- (void) setTitle:(NSString *)title;
// 设置右标题
- (void) setDetail:(NSString *)detail;
// 设置单价
- (void)setUnitPrice:(NSString *)unitPrice;

@end
