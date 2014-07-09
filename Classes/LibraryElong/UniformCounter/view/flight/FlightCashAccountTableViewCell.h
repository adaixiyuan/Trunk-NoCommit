//
//  FlightCashAccountTableViewCell.h
//  ElongClient
//
//  Created by 赵 海波 on 14-3-27.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightCashAccountTableViewCell : UITableViewCell

@property (nonatomic) BOOL isShowingDetail;     // 标记是否在展示详情,default = NO
@property (nonatomic, strong) IBOutlet UIImageView *arrowImgView;   // 小箭头
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;     // 显示价格

+ (id)cellFromNib;
- (IBAction)clickDetailBtn;   // 点击详情按钮

@end
