//
//  PriceSlider.h
//  ElongClient
//  价格滑块
//  Created by garin on 13-12-18.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PriceSlider;

@protocol PriceSliderDelegate <NSObject>
- (void) selectedPrice:(PriceSlider *) slider minPrice:(int) minPrice maxPrice:(int) maxPrice minIndex:(int) minIndex maxIndex:(int) maxIndex;
@end

@interface PriceSlider : UIView<UIGestureRecognizerDelegate>
{
    UIView *containerView;          //滑块的圆弧区域
    UIImageView *sliderViewStart;   //左边滑块
    UIImageView *sliderViewTo;      //右边的滑块
    UIImageView *selectBg;      
    UIImageView *bgRightView;   //右边的背景，灰黑
    
    UIPanGestureRecognizer *panRecognizerStart;  //左边的滑块手势
    UIPanGestureRecognizer *panRecognizerEnd;    //右边的滑块手势
    UITapGestureRecognizer *singleTap;           //单击手势
    
    NSMutableArray *itemsXPositionAry;  //刻度数组
    NSMutableArray *prictItemArr;       //刻度对应的描述
    
    int minIndex;                       //最低价选中
    int maxIndex;                       //最高价选中
    
    int sliderWidthOffSet;              //slider左右偏移度，用于控制slider横向可触摸区域的大小
    
    float span;                         //刻度间隔
}

@property (nonatomic,assign) id<PriceSliderDelegate> delegate;
@property (nonatomic) int initMinIndex;
@property (nonatomic) int initMaxIndex;

//初始化状态
-(void) initWithIndex:(int) iMinIndex maxIndex:(int) iMaxIndex;

@end
