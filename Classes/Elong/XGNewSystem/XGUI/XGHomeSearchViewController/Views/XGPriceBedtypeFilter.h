//
//  XGPriceBedtypeFilter.h
//  ElongClient
//
//  Created by 李程 on 14-5-28.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FilterView.h"
#import "PriceSlider.h"

@protocol XGPriceChangeDelegate <NSObject>
- (void) changePrice:(int) minPrice maxPrice:(int) maxPrice bedTypeIndex:(int)bedTypeIndex;
@end

@interface XGPriceBedtypeFilter : FilterView<PriceSliderDelegate>
{
    PriceSlider *slider;
    int curMinPrice,curMaxPrice,curMinIndex,curMaxIndex;
    
    int backMinPrice,backMaxPrice,backMinIndex,backMaxIndex;
}

@property (nonatomic,assign) id<XGPriceChangeDelegate> priceChangeDelegate;

-(void) reset;

//恢复最初始化状态
-(void) resetToZero;

- (void) setMinPrice:(NSInteger)minPrice maxPrice:(NSInteger)maxPrice;
@end
