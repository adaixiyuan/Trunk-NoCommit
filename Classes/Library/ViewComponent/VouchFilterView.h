//
//  VouchFilterView.h
//  ElongClient
//  担保时间段的选择页面
//
//  Created by 赵 海波 on 12-12-5.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterView.h"

@interface VouchFilterView : FilterView {
    
}

@property (nonatomic, copy) NSString *moneyValue;

- (id)initWithTitle:(NSString *)title Datas:(NSArray *)datas;		// 用标题和显示数据初始化

@end
