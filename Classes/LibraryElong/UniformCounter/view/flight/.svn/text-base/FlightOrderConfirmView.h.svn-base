//
//  FlightOrderConfirmView.h
//  ElongClient
//  原机票确认页的展示内容
//
//  Created by 赵 海波 on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightOrderConfirmView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    BOOL isSingleTrip;          // 标记是否为单程航班，default:YES
    
    NSArray *passengerArray;    // 记录乘客信息
    NSInteger passengerCellHeight;      // 乘客信息栏高度
}

@property (nonatomic, assign) NSInteger height;         // 本页的高度

- (void)showPassengers;          // 展示乘客列表
- (void)hiddenPassengers;        // 隐藏乘客列表

@end
