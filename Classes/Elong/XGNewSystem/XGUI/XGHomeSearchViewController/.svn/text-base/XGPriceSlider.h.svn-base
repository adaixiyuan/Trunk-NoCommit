//
//  XGPriceSlider.h
//  ElongClient
//
//  Created by licheng on 14-4-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XGPriceSlider;
@protocol XGPriceSliderDelegate <NSObject>

- (void) xgselectedPrice:(XGPriceSlider *) slider maxPrice:(int) maxPrice maxIndex:(int) maxIndex;

@end

@interface XGPriceSlider : UIView<UIGestureRecognizerDelegate>{
    
    UIView *containerView;          //滑块的圆弧区域
    UIImageView *sliderViewTo;      //右边的滑块
    UIImageView *selectBg;
    UIImageView *bgRightView;   //右边的背景，灰黑
    UIPanGestureRecognizer *panRecognizerEnd;    //右边的滑块手势
    UITapGestureRecognizer *singleTap;           //单击手势
    NSMutableArray *itemsXPositionAry;  //刻度数组
    NSMutableArray *prictItemArr;       //刻度对应的描述
    
    int maxIndex;                       //最高价选中
    
    int sliderWidthOffSet;              //slider左右偏移度，用于控制slider横向可触摸区域的大小
    float span;                         //刻度间隔
}
@property (nonatomic) int initMaxIndex;

-(void) initWithIndex:(int) iMaxIndex;

@property (nonatomic,assign) id<XGPriceSliderDelegate> delegate;

@end
