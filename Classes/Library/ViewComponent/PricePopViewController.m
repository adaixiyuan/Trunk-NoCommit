//
//  PricePopViewController.m
//  ElongClient
//
//  Created by garin on 13-12-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "PricePopViewController.h"

@implementation PricePopViewController
@synthesize priceChangeDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        curMinPrice=-1;
        curMaxPrice=-1;
        curMinIndex=-1;
        curMaxIndex=-1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    slider=[[PriceSlider alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 80)];
    slider.delegate=self;
    slider.backgroundColor=[UIColor clearColor];
    [self.view addSubview:slider];
    [slider release];
}

-(void) reset
{
    if (slider)
    {
        //备份状态
        backMinIndex=curMinIndex;
        backMaxIndex=curMaxIndex;
        backMinPrice=curMinPrice;
        backMaxPrice=curMaxPrice;
        
        [slider initWithIndex:curMinIndex maxIndex:curMaxIndex];
    }
}

- (void) setMinPrice:(NSInteger)minPrice maxPrice:(NSInteger)maxPrice{
    curMinIndex = [PublicMethods getMinPriceLevel:minPrice];
    curMaxIndex = [PublicMethods getMaxPriceLevel:maxPrice];
    curMinPrice = [PublicMethods getMinPriceByLevel:curMinIndex];
    curMaxPrice = [PublicMethods getMaxPriceByLevel:curMaxIndex];
    
    [self reset];
}

-(void) resetToZero
{
    curMinIndex=0;
    curMaxIndex=4;
    curMinPrice=0;
    curMaxPrice=GrouponMaxMaxPrice;
    
    [self reset];
}

//重写确定
- (void) confirmInView
{
    if (curMinPrice!=-1&&curMaxPrice!=-1)
    {
        if ([self.priceChangeDelegate respondsToSelector:@selector(changePrice:maxPrice:)])
        {
            [self.priceChangeDelegate changePrice:curMinPrice maxPrice:curMaxPrice];
        }
    }
    
    [super confirmInView];
}

//取消按钮重写
- (void) cancelBtnClick
{
    [super cancelBtnClick];
    
    
    //取消重置状态
    curMinIndex=backMinIndex;
    curMaxIndex=backMaxIndex;
    curMinPrice=backMinPrice;
    curMaxPrice=backMaxPrice;
}

//单击取消
-(void) singleTapGestureDoOtherSth
{
    //取消重置状态
    curMinIndex=backMinIndex;
    curMaxIndex=backMaxIndex;
    curMinPrice=backMinPrice;
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

#pragma mark -
#pragma mark 回调delegate
- (void) selectedPrice:(PriceSlider *) slider minPrice:(int) minPrice maxPrice:(int) maxPrice minIndex:(int) minIndex maxIndex:(int) maxIndex
{
    curMinPrice=minPrice;
    curMaxPrice=maxPrice;
    curMinIndex=minIndex;
    curMaxIndex=maxIndex;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
