//
//  XGHomeSearchPriceController.h
//  ElongClient
//
//  Created by licheng on 14-4-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FilterView.h"
#import "XGPriceSlider.h"

@protocol XGHomeSearchPriceDelegate <NSObject>
- (void) xghomesearchPricemaxPrice:(int) maxPrice;
@end

@interface XGHomeSearchPriceController : FilterView
{
    XGPriceSlider *slider;
    
    int curMaxPrice,curMaxIndex;
    
    int backMaxPrice,backMaxIndex;
}
@property (nonatomic,assign) id<XGHomeSearchPriceDelegate> xgHomesearchDelegate;

-(void) reset;

//恢复最初始化状态
-(void) resetToZero;

- (void) setMinPrice:(NSInteger)minPrice maxPrice:(NSInteger)maxPrice;

@end
