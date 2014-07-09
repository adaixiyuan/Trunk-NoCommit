//
//  BaseBottomBar.h
//  ElongClient
//  公用下导航栏
//
//  Created by 赵 海波 on 13-12-9.
//  Copyright (c) 2013年 赵 海波. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BACKGROUND_COLOR    [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1]
#define BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED [UIColor colorWithRed:210/255.0 green:70/255.0 blue:36/255.0 alpha:1]
#define BASEBOTTOMBAR_TITLE_COLOR_NORMAL  [UIColor whiteColor]

@protocol BaseBottomBarDelegate;
@class BaseBottomBarItem;

@interface BaseBottomBar : UIView

@property (nonatomic, assign) id<BaseBottomBarDelegate> delegate;
@property (nonatomic) BOOL mutipleSelected;                      // 是否支持多选，决定每个item的状态是否会对其它item造成影响，default:NO
@property (nonatomic, strong) NSArray *baseBottomBarItems;       // 包含所有BaseBottomBarItem对象
@property (nonatomic, strong) BaseBottomBarItem *selectedItem;   // 当前选中的BaseBottomBarItem
@property (nonatomic) NSInteger selectedIndex;                   // 选中的index

- (id)initWithFrame:(CGRect)frame;

- (void)setItemEnable:(BOOL)enable AtIndexes:(NSArray *)indexes;     // 设置某些item是否可被点击，数组里用NSNumber构造序号

@end


@protocol BaseBottomBarDelegate <NSObject>

@required
- (void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index;

@end


@interface BaseBottomBarItem : UIImageView

@property (nonatomic, strong) UILabel *titleLabel;            // 标题
@property (nonatomic, strong) UIColor *customerTitleColor;    // 标题颜色，一旦指定该属性，文字颜色将不再会自动更改，设置为nil时，显示默认状态颜色
@property (nonatomic, strong) UIImageView *iconImageView;     // 显示icon的view
@property (nonatomic, strong) UIImage *normalIcon;            // 普通状态的图片
@property (nonatomic, strong) UIImage *highlightedIcon;       // 高亮状态图片
@property (nonatomic, strong) UIImage *customerIcon;          // 一旦指定该属性，iconview的图片不会再随点击状态改变，当设置为nil状态时，恢复显示刚开始的图片

@property (nonatomic) BOOL allowRepeat;                       // 是否允许重复点击,default:NO
@property (nonatomic) BOOL autoReverse;                       // 点击后自动弹起，default:NO

// 只有标题的初始化方法（如团购订单页）
- (id)initWithTitle:(NSString *)title
          titleFont:(UIFont *)font;

// 使用标题和一张图片进行初始化（如酒店列表中筛选里的价格，这里只给一个初始状态，后面的改变需要在代理回调中自定义）
- (id)initWithTitle:(NSString *)title
          titleFont:(UIFont *)font
        originImage:(NSString *)iconPath;

// 使用标题和图片初始化 （适用于一般有图有文字的情况）
- (id)initWithTitle:(NSString *)title
          titleFont:(UIFont *)font
              image:(NSString *)iconPath
    highligtedImage:(NSString *)hIconPath;

// 使用标题、初始图片和一组切换图片初始化（一般只用于价格、时间之类的有3种状态的排序）
- (id)initWithTitle:(NSString *)title
          titleFont:(UIFont *)font
        originImage:(NSString *)oIconPath
              image:(NSString *)iconPath
    highligtedImage:(NSString *)hIconPath;

// 改变Item的状态
- (void)changeStateToPressed:(BOOL)isPressed;

@end