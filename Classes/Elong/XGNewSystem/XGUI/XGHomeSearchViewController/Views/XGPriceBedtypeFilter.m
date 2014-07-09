//
//  XGPriceBedtypeFilter.m
//  ElongClient
//
//  Created by 李程 on 14-5-28.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGPriceBedtypeFilter.h"
#import "XGSelectBedTypeView.h"
#import "UMengEventC2C.h"
@interface XGPriceBedtypeFilter ()
@property(nonatomic,strong)XGSelectBedTypeView *selectBedType;

@property(nonatomic,assign)int currentBedIndex;

@end

@implementation XGPriceBedtypeFilter

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        curMinPrice=0;
        curMaxPrice=GrouponMaxMaxPrice;
        curMinIndex=-1;
        curMaxIndex=-1;
        
        self.currentBedIndex = 0;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    (0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 80)  + 80 + 40 + 10
    
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    XGSelectBedTypeView *select = [[XGSelectBedTypeView alloc]initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT+15 , 320, 40)withDefault:self.currentBedIndex];
    
    select.bedindexBlock = ^(int bedIndex){
        
        NSLog(@"当前选择==%d",bedIndex);
        weakSelf.currentBedIndex = bedIndex;
        
        UMENG_EVENT(UEvent_C2C_Home_BedType)
        
    };
    [self.view addSubview:select];
    

    
    UIImageView *splitView = [UIImageView separatorWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT +70 , SCREEN_WIDTH, SCREEN_SCALE)];
    [self.view addSubview:splitView];
    
    slider=[[PriceSlider alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+50+20 , SCREEN_WIDTH, 80)];
    slider.delegate=self;
    slider.backgroundColor=[UIColor clearColor];
    [self.view addSubview:slider];
    // Do any additional setup after loading the view.
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
        if ([self.priceChangeDelegate respondsToSelector:@selector(changePrice:maxPrice:bedTypeIndex:)])
        {
            [self.priceChangeDelegate changePrice:curMinPrice maxPrice:curMaxPrice bedTypeIndex:self.currentBedIndex];
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
    return slider.frame.size.height+30+50;
}

#pragma mark -
#pragma mark 回调delegate
- (void) selectedPrice:(PriceSlider *) slider minPrice:(int) minPrice maxPrice:(int) maxPrice minIndex:(int) minIndex maxIndex:(int) maxIndex
{
    curMinPrice=minPrice;
    curMaxPrice=maxPrice;
    curMinIndex=minIndex;
    curMaxIndex=maxIndex;
    
    UMENG_EVENT(UEvent_C2C_Home_Price)
}





@end
