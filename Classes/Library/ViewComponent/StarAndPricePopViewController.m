//
//  StarAndPricePopViewController.m
//  ElongClient
//
//  Created by Dawn on 14-4-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "StarAndPricePopViewController.h"

@implementation StarAndPricePopViewController

- (void) dealloc{
    self.curStarCodes = nil;
    self.backStarCodes = nil;
    self.starAndPricedelegate = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _curMinPrice = -1;
    _curMaxPrice = -1;
    _curMinIndex = -1;
    _curMaxIndex = -1;
    self.curStarCodes = STAR_LIMITED_NONE;
    
    UILabel *starLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, NAVIGATION_BAR_HEIGHT + 10, 100, 20)];
    starLbl.font = [UIFont systemFontOfSize:14.0f];
    starLbl.textColor = RGBACOLOR(52, 52, 52, 1);
    starLbl.text = @"星级";
    [self.view addSubview:starLbl];
    starLbl.backgroundColor = [UIColor clearColor];
    [starLbl release];
    
    _starSelector = [[StarSelector alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + 20, SCREEN_WIDTH, 80)];
    _starSelector.backgroundColor = [UIColor clearColor];
    _starSelector.delegate = self;
    [self.view addSubview:_starSelector];
    [_starSelector release];
    
    UIImageView *splitView = [UIImageView separatorWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT + 20 + 80 +10 , SCREEN_WIDTH - 20, SCREEN_SCALE)];
    [self.view addSubview:splitView];
    
    UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, NAVIGATION_BAR_HEIGHT + 80 + 20 + 20, 100, 20)];
    priceLbl.font = [UIFont systemFontOfSize:14.0f];
    priceLbl.textColor = RGBACOLOR(52, 52, 52, 1);
    priceLbl.text = @"价格";
    [self.view addSubview:priceLbl];
    priceLbl.backgroundColor = [UIColor clearColor];
    [priceLbl release];
    
    
    _slider = [[PriceSlider alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + 80 + 40 + 10, SCREEN_WIDTH, 80)];
    _slider.delegate = self;
    _slider.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_slider];
    [_slider release];
    
    
}

-(void) reset{
    if (_slider){
        //备份状态
        _backMinIndex = _curMinIndex;
        _backMaxIndex = _curMaxIndex;
        _backMinPrice = _curMinPrice;
        _backMaxPrice = _curMaxPrice;
        
        [_slider initWithIndex:_curMinIndex maxIndex:_curMaxIndex];
    }
    if (_starSelector) {
        self.backStarCodes = self.curStarCodes;
        _starSelector.starCodes = self.curStarCodes;
    }
}

- (void) setMinPrice:(NSInteger)minPrice maxPrice:(NSInteger)maxPrice starCodes:(NSString *)starCodes{
    _curMinIndex = [PublicMethods getMinPriceLevel:minPrice];
    _curMaxIndex = [PublicMethods getMaxPriceLevel:maxPrice];
    _curMinPrice = [PublicMethods getMinPriceByLevel:_curMinIndex];
    _curMaxPrice = [PublicMethods getMaxPriceByLevel:_curMaxIndex];
    self.curStarCodes = starCodes;
    
    [self reset];
}

-(void) resetToZero{
    _curMinIndex = 0;
    _curMaxIndex = 4;
    _curMinPrice = 0;
    _curMaxPrice = GrouponMaxMaxPrice;
    
    self.curStarCodes = STAR_LIMITED_NONE;
    
    [self reset];
}

//重写确定
- (void) confirmInView{
    if ([self.starAndPricedelegate respondsToSelector:@selector(starAndPricePopViewController:didSelectMinPrice:MaxPrice:starCodes:)]) {
        [self.starAndPricedelegate starAndPricePopViewController:self didSelectMinPrice:_curMinPrice MaxPrice:_curMaxPrice starCodes:self.curStarCodes];
    }
    
    [super confirmInView];
}

//取消按钮重写
- (void) cancelBtnClick{
    [super cancelBtnClick];
    
    [self rollback];
    
}

- (void) rollback{
    //取消重置状态
    _curMinIndex = _backMinIndex;
    _curMaxIndex = _backMaxIndex;
    _curMinPrice = _backMinPrice;
    _curMaxPrice = _backMaxPrice;
    
    self.curStarCodes = self.backStarCodes;
}

//单击取消
-(void) singleTapGestureDoOtherSth{
    [self rollback];
}

-(BOOL) isInitTableView{
    return NO;
}

//设置btn显示，子类实现
-(void) setBtnHidden{
    leftBtn.hidden=NO;
    rightBtn.hidden=NO;
}

-(float) getAddHeight{
    return _slider.frame.size.height + 30 + _starSelector.frame.size.height + 40;
}

#pragma mark -
#pragma mark PriceSliderDelegate
- (void) selectedPrice:(PriceSlider *) slider minPrice:(int) minPrice maxPrice:(int) maxPrice minIndex:(int) minIndex maxIndex:(int) maxIndex{
    _curMinPrice = minPrice;
    _curMaxPrice = maxPrice;
    _curMinIndex = minIndex;
    _curMaxIndex = maxIndex;
}

#pragma mark -
#pragma mark StarSelectorDelegate
- (void) starSelector:(StarSelector *)starSelector didSelectStarCodes:(NSString *)starCodes{
    self.curStarCodes = starCodes;
}

@end
