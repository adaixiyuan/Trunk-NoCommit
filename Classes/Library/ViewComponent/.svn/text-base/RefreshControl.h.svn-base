//
//  RefreshControl.h
//  ElongClient
//
//  Created by bruce on 13-12-28.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshControl : UIControl

@property (nonatomic, strong) NSString *startText;       // 未达到触发刷新时的文案
@property (nonatomic, strong) NSString *hintText;       // 达到触发刷新时的文案
@property (nonatomic, strong) NSString *loadingText;    // 刷新中...文案

- (id)initInScrollView:(UIScrollView *)scrollView;

- (void)setRefreshTime:(NSDate *)time;

- (void)beginRefreshing:(NSDate *)time;

- (void)endRefreshing;

- (void)endRefreshingWithText:(NSString *)errorText;

- (void)endRefreshingWithTime:(NSDate *)time;

@end
