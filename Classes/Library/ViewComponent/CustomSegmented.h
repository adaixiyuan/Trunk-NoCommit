//
//  CustomSegmented.h
//  ElongClient
//  自定义的segmented
//
//  Created by haibo on 11-10-27.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSegItem.h"
#import "CustomSegmentedDelegate.h"


@interface CustomSegmented : UIView <SegItemDelegate> {
@private
	NSInteger lastSelectedIndex;
	BOOL adjustTitleHeight;
}

@property (nonatomic, assign) NSInteger selectedIndex;		// 被选中的segment序号
@property (nonatomic, assign) id<CustomSegmentedDelegate> delegate;

// 用图片进行初始化
- (id)initWithNormalImages:(NSArray *)nImages highlightedImages:(NSArray *)hImages Frame:(CGRect)rect;

// 用文字、字体大小、文字颜色初始化
- (id)initWithTitles:(NSArray *)titles
          NormalFont:(UIFont *)normalFont
    HightLightedFont:(UIFont *)highLightedFont
    NormalTitleColor:(UIColor *)normalColor
HightLightTitleColor:(UIColor *)hightLightColor
               Frame:(CGRect)rect;

// 不同图片、文字、按键间距初始化
- (id)initWithNormalImages:(NSArray *)nImages
		 highlightedImages:(NSArray *)hImages
					titles:(NSArray *)titleArray
				 titleFont:(UIFont *)font
		  titleNormalColor:(UIColor *)normalColor
	 titleHighlightedColor:(UIColor *)highlightedColor
				  interval:(NSInteger)pixel;

// 相同图片、文字、按键间距、frame初始化
- (id)initWithFrame:(CGRect)rect
		NormalImage:(UIImage *)nImage
   highlightedImage:(UIImage *)hImage
			 titles:(NSArray *)titleArray
		  titleFont:(UIFont *)font
   titleNormalColor:(UIColor *)normalColor
titleHighlightedColor:(UIColor *)highlightedColor
		   interval:(NSInteger)pixel;

// v3.0通用的灰底蓝框选择器,默认位置在顶部
- (id)initCommanSegmentedWithTitles:(NSArray *)titles normalIcons:(NSArray *)nIcons highlightIcons:(NSArray *)hIcons;

// 自定义位置的灰底蓝框选择器
- (id)initSegmentedWithFrame:(CGRect)rect titles:(NSArray *)titles normalIcons:(NSArray *)nIcons highlightIcons:(NSArray *)hIcons;

// 团购详情样式的书签样式
- (id)initBookMarkWithFrame:(CGRect)rect Titles:(NSArray *)titleArray;

@end
