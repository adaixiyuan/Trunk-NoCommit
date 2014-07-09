//
//  HomeItem.h
//  Home
//
//  Created by Dawn on 13-12-4.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeItem : NSObject<NSCopying>
@property (nonatomic,assign) NSInteger  tag;                // tag
@property (nonatomic,assign) BOOL       fixed;              // 是否固定不动
@property (nonatomic,assign) BOOL       deletable;          // 是否可以删除
@property (nonatomic,assign) BOOL       scrollable;         // 是否可以滚动
@property (nonatomic,assign) BOOL       action;             // 是否是可触发事件的子item
@property (nonatomic,copy) NSString     *title;             // 标题 暂不用做显示
@property (nonatomic,copy) NSString     *subtitle;          // 副标题
@property (nonatomic,assign) float      x;                  // 位置坐标x
@property (nonatomic,assign) float      y;                  // 位置坐标y
@property (nonatomic,assign) float      width;              // 宽度
@property (nonatomic,assign) float      height;             // 高度
@property (nonatomic,assign) float      contentWidth;       // 容量width
@property (nonatomic,assign) float      contentHeight;      // 容量height
@property (nonatomic,copy) NSString     *background;        // 背景图
@property (nonatomic,retain) NSMutableArray   *subitems;
@property (nonatomic,retain) NSMutableArray   *actions;
@property (nonatomic,assign) HomeItem   *superItem;
@property (nonatomic,assign) BOOL       selected;
@property (nonatomic,assign) float      timeInterval;
@property (nonatomic,assign) float      animationInterval;
@end
