//
//  CheapCalendarView.h
//  ElongClient
//
//  Created by bruce on 14-3-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

// =============================================================================
// 回调协议
// =============================================================================
@protocol CheapCalendarViewDelgt <NSObject>

// 点击回调
- (void)selectPriceDate:(NSInteger)selectIndex;

@end



@interface CheapCalendarView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *arrayRow1;       // 第一行数据
@property (nonatomic, strong) NSArray *arrayRow2;       // 第二行数据

@property (nonatomic, strong) id <CheapCalendarViewDelgt> delegate;

- (void)setArrayRow1:(NSArray *)arrayRow1;

- (void)setArrayRow2:(NSArray *)arrayRow2;

- (void)setItemCount:(NSInteger)count;

- (void)setItemHighlight:(NSInteger)itemIndex;

// 加载状态
- (void)calendarStartLoading;

// 停止加载
- (void)calendarEndLoading;

@end
