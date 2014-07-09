//
//  PricePopViewController.h
//  ElongClient
//  价格弹出
//  Created by garin on 13-12-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FilterView.h"
#import "PriceSlider.h"

@protocol PriceChangeDelegate <NSObject>
- (void) changePrice:(int) minPrice maxPrice:(int) maxPrice;
@end

@interface PricePopViewController : FilterView<PriceSliderDelegate>
{
    PriceSlider *slider;
    int curMinPrice,curMaxPrice,curMinIndex,curMaxIndex;
    
    int backMinPrice,backMaxPrice,backMinIndex,backMaxIndex;
}

@property (nonatomic,assign) id<PriceChangeDelegate> priceChangeDelegate;

-(void) reset;

//恢复最初始化状态
-(void) resetToZero;

- (void) setMinPrice:(NSInteger)minPrice maxPrice:(NSInteger)maxPrice;
@end
