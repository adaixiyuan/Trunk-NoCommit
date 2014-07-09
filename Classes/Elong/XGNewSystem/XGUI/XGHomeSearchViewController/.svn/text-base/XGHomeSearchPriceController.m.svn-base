//
//  XGHomeSearchPriceController.m
//  ElongClient
//
//  Created by licheng on 14-4-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGHomeSearchPriceController.h"

@interface XGHomeSearchPriceController ()<XGPriceSliderDelegate>

@end

@implementation XGHomeSearchPriceController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        curMaxPrice=-1;
        curMaxIndex=-1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    slider=[[XGPriceSlider alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 80)];
    slider.delegate=self;
    slider.backgroundColor=[UIColor clearColor];
    [self.view addSubview:slider];
}

-(void) reset
{
    if (slider)
    {
        //备份状态
        backMaxIndex=curMaxIndex;
        backMaxPrice=curMaxPrice;
        
        [slider initWithIndex:curMaxIndex];
    }
}

- (void) setMinPrice:(NSInteger)minPrice maxPrice:(NSInteger)maxPrice{
    curMaxIndex = [self gxgetMaxPriceLevel:maxPrice];
    curMaxPrice = [self gxgetMaxPriceByLevel:curMaxIndex];
    
    [self reset];
}

-(void) resetToZero
{
    curMaxIndex=4;
    curMaxPrice=GrouponMaxMaxPrice;
    
    [self reset];
}

//重写确定
- (void) confirmInView
{
    if (curMaxPrice!=-1)
    {
        if ([self.xgHomesearchDelegate respondsToSelector:@selector(xghomesearchPricemaxPrice:)])
        {
            [self.xgHomesearchDelegate xghomesearchPricemaxPrice:curMaxPrice];
        }
    }
    
    [super confirmInView];
}

//取消按钮重写
- (void) cancelBtnClick
{
    [super cancelBtnClick];
    
    //取消重置状态
    curMaxIndex=backMaxIndex;
    curMaxPrice=backMaxPrice;
}

//单击取消
-(void) singleTapGestureDoOtherSth
{
    //取消重置状态
    curMaxIndex=backMaxIndex;
    curMaxPrice=backMaxPrice;
}

-(BOOL) isInitTableView
{
    return NO;
}

//设置btn显示，子类实现
-(void) setBtnHidden
{
    leftBtn.hidden=NO;
    rightBtn.hidden=NO;
}

-(float) getAddHeight
{
    return slider.frame.size.height+30;
}
#pragma mark --其他方法

- (NSInteger) gxgetMaxPriceLevel:(NSInteger)price{
    switch (price) {
        case -1:
            return 5;
        case 100:
            return 0;
        case 150:
            return 1;
        case 200:
            return 2;
        case 300:
            return 3;
        case 500:
            return 4;
        default:
            return 5;
    }
}

- (NSInteger) gxgetMaxPriceByLevel:(NSInteger)level{
    switch (level) {
        case 0:
            return 100;
        case 1:
            return 150;
        case 2:
            return 200;
        case 3:
            return 300;
        case 4:
            return 500;
        case 5:
            return -1;
        default:
            return -1;
    }
}


#pragma mark -
#pragma mark 回调delegate

- (void) xgselectedPrice:(XGPriceSlider *) slider maxPrice:(int) maxPrice maxIndex:(int) maxIndex{
    curMaxPrice=maxPrice;
    curMaxIndex=maxIndex;
    
    
    NSLog(@"maxPrice==%d  maxIndex===%d",maxPrice,maxIndex);
    
}



@end
