//
//  StarAndPricePopViewController.h
//  ElongClient
//
//  Created by Dawn on 14-4-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FilterView.h"
#import "PriceSlider.h"
#import "StarSelector.h"

@protocol StarAndPricePopViewControllerDelegate;

@interface StarAndPricePopViewController : FilterView<PriceSliderDelegate,StarSelectorDelegate>{
    PriceSlider *_slider;
    StarSelector *_starSelector;
    int _curMinPrice,_curMaxPrice,_curMinIndex,_curMaxIndex;
    int _backMinPrice,_backMaxPrice,_backMinIndex,_backMaxIndex;
}
@property (nonatomic,assign) id<StarAndPricePopViewControllerDelegate> starAndPricedelegate;
@property (nonatomic,copy) NSString *curStarCodes;
@property (nonatomic,copy) NSString *backStarCodes;
-(void) reset;

//恢复最初始化状态
-(void) resetToZero;

- (void) setMinPrice:(NSInteger)minPrice maxPrice:(NSInteger)maxPrice starCodes:(NSString *)starCodes;
@end


@protocol StarAndPricePopViewControllerDelegate <NSObject>

- (void) starAndPricePopViewController:(StarAndPricePopViewController *)starAndPriceVC didSelectMinPrice:(NSInteger)minPrice MaxPrice:(NSInteger)maxPrice starCodes:(NSString *)starCodes;

@end