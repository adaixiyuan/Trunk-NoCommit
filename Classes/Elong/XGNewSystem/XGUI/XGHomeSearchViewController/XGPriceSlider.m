//
//  XGPriceSlider.m
//  ElongClient
//
//  Created by licheng on 14-4-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGPriceSlider.h"

@implementation XGPriceSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        prictItemArr=[[NSMutableArray alloc] initWithObjects:@"100",@"150",@"200",@"300",@"500",@"不限",nil];
        itemsXPositionAry=[[NSMutableArray alloc] init];
        
        maxIndex=prictItemArr.count-1;
        
        sliderWidthOffSet=15;
        
        [self createContainerView];
        
    }
    return self;
}

-(void) initWithIndex:(int) iMaxIndex
{
    self.initMaxIndex=iMaxIndex;
    
    [self initWithPrice];
}

//初始化状态
-(void) initWithPrice
{
    int moveToToX;
    
    if (self.initMaxIndex==-1)
    {
        maxIndex=prictItemArr.count-1;
        moveToToX=[[itemsXPositionAry objectAtIndex:itemsXPositionAry.count-1] intValue];
    }
    if (self.initMaxIndex>=0)
    {
        maxIndex=self.initMaxIndex;
        moveToToX=[[itemsXPositionAry objectAtIndex:self.initMaxIndex] intValue];
    }
    
    sliderViewTo.frame = CGRectMake(moveToToX-sliderWidthOffSet, sliderViewTo.frame.origin.y, sliderViewTo.frame.size.width, sliderViewTo.frame.size.height);
    
    [self setSelectBg];
}



#pragma mark -
#pragma mark UI Make
//创建slider的区域，圆弧
-(void)createContainerView
{
    //Container view
    containerView = [[UIView alloc]initWithFrame:CGRectMake(14, 24 , SCREEN_WIDTH-28 , 21)];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.borderWidth=1.0f;
    containerView.layer.borderColor=[UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1].CGColor;
    //    containerView.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    //    containerView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    //    containerView.layer.shadowOpacity = 1.0f;
    //    containerView.layer.shadowRadius = 1.0f;
    containerView.layer.cornerRadius = 21/2;
    [self addSubview:containerView];
    
    span=(containerView.frame.size.width)/(prictItemArr.count-1);
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:singleTap];

    
    //增加背景
    UIImageView *bgLeftView=[[UIImageView alloc] initWithFrame:CGRectMake(7, (containerView.frame.size.height-7)/2, 5, 7)];
    bgLeftView.image=[UIImage imageNamed:@"xgslider_left_bg.png"];
    [containerView addSubview:bgLeftView];
    
    UIImageView *bgMiddleView=[[UIImageView alloc] initWithFrame:CGRectMake(12, (containerView.frame.size.height-7)/2, containerView.frame.size.width-24, 7)];
    bgMiddleView.image=[UIImage imageNamed:@"slider_middle_bg.png"];
    [containerView addSubview:bgMiddleView];

    
    bgRightView=[[UIImageView alloc] initWithFrame:CGRectMake(containerView.frame.size.width-12, (containerView.frame.size.height-7)/2, 5, 7)];
    bgRightView.image=[UIImage imageNamed:@"slider_right_bg.png"];
    [containerView addSubview:bgRightView];

    
    [self createSliderView];
    
}

//创建滑块和两个手势
-(void)createSliderView
{
    
    //右边的按钮
    panRecognizerEnd = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRecognizerEnd.minimumNumberOfTouches = 1;
    panRecognizerEnd.delegate = self;
    
    sliderViewTo=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- 12-29-sliderWidthOffSet, containerView.frame.origin.y-28, 29+sliderWidthOffSet*2 , 80)];
    sliderViewTo.userInteractionEnabled=YES;
    sliderViewTo.image=[UIImage imageNamed:@"xg_slider_round.png"];
    [self insertSubview:sliderViewTo aboveSubview:containerView];

    [sliderViewTo addGestureRecognizer:panRecognizerEnd];

    sliderViewTo.contentMode=UIViewContentModeCenter;
    
    //中间蓝色选中背景
    selectBg=[[UIImageView alloc] init];
    [self setSelectBg];
    selectBg.image=[UIImage imageNamed:@"xgslider_middle_select_bg.png"];
    [containerView insertSubview:selectBg aboveSubview:bgRightView];

    
    [self drawRatingView];
}

//绘制刻度
-(void)drawRatingView
{
    for (int i=0;i<prictItemArr.count;i++)
    {
        //下边的文字和dot
        NSString *desp=nil;
        if ([[prictItemArr objectAtIndex:i] isEqualToString:@"不限"]) {
            desp =@"不限";
        }else if ([[prictItemArr objectAtIndex:i] isEqualToString:@"100"]){
            desp = [NSString stringWithFormat:@"¥≤%@",[prictItemArr objectAtIndex:i]];
        }
        else
        {
            desp = [NSString stringWithFormat:@"¥%@",[prictItemArr objectAtIndex:i]];
        }
        
        double despX=i*span;
        if (i==0)
        {
            despX=12+i*span;
        }
        else if(i==prictItemArr.count-1)
        {
            despX=i*span-12;
        }
        
        CGSize size=[desp sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(span, 90)];
        
        UILabel *lblPriceDesp = [[UILabel alloc] initWithFrame:CGRectMake(despX-size.width/2, 25, span, 40)];
        lblPriceDesp.text=desp;
        //        lblPriceDesp.layer.borderWidth=1;
        //        lblPriceDesp.backgroundColor = [UIColor greenColor];
        lblPriceDesp.textAlignment = NSTextAlignmentLeft;
        lblPriceDesp.textColor=[UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1];
        lblPriceDesp.font=[UIFont systemFontOfSize:13.0f];
        lblPriceDesp.backgroundColor = [UIColor clearColor];
        [containerView addSubview:lblPriceDesp];

        
        //刻度存放
        [itemsXPositionAry addObject:[NSString stringWithFormat:@"%f",despX]];
        
        //描述上的dot
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(size.width/2, 7, 3, 3)];
        img.image=[UIImage imageNamed:@"slider_price_dot.png"];
        [lblPriceDesp addSubview:img];

    }
}

//根据按钮的位置设置选中的背景
-(void) setSelectBg
{
    selectBg.frame=CGRectMake(sliderWidthOffSet-5, (containerView.frame.size.height-7)/2, sliderViewTo.frame.origin.x, 7);
}


#pragma mark -
#pragma mark 位置计算
//得位置最靠近的刻度
-(float) getTapPositionX:(float) x
{
    if (x<=[[itemsXPositionAry objectAtIndex:0] floatValue]) {
        return [[itemsXPositionAry objectAtIndex:0] floatValue];
    }
    
    if (x>=[[itemsXPositionAry objectAtIndex:itemsXPositionAry.count-1] floatValue]) {
        return [[itemsXPositionAry objectAtIndex:itemsXPositionAry.count-1] floatValue];
    }
    
    float itemXposition = 0;
    float itempreviousXpostion = 0;
    
    for (int i =0; i<itemsXPositionAry.count; i++)
    {
        if (i !=0)
        {
            itemXposition = [[itemsXPositionAry objectAtIndex:i] floatValue];
            itempreviousXpostion = [[itemsXPositionAry objectAtIndex:i-1] floatValue];
        }
        else
        {
            itemXposition = [[itemsXPositionAry objectAtIndex:i] floatValue];
        }
        if (x < itemXposition)
            break;
    }
    
    float nextValue = itemXposition - x;
    float previousValue = x -itempreviousXpostion;
    
    if (nextValue < previousValue)
    {
        return itemXposition;
    }
    else
    {
        return itempreviousXpostion;
    }
}

//由位置得到刻度
-(int) getIndexByPositionX:(float) x
{
    int xx = (int)x;
    for (int i=0; i<itemsXPositionAry.count; i++)
    {
        if (xx==[[itemsXPositionAry objectAtIndex:i] integerValue])
        {
            return i;
        }
    }
    
    return -1;
}


//拖拽后，计算最后的位置
-(void) calculateXposition:(UIView *)view recognizer:(UIPanGestureRecognizer *)recognizer
{
    float selectorViewX = view.frame.origin.x+sliderWidthOffSet;
    float itemXposition = 0;
    float itempreviousXpostion = 0;
    
    for (int i =0; i<itemsXPositionAry.count; i++)
    {
        if (i !=0)
        {
            itemXposition = [[itemsXPositionAry objectAtIndex:i] floatValue];
            itempreviousXpostion = [[itemsXPositionAry objectAtIndex:i-1] floatValue];
        }
        else
        {
            itemXposition = [[itemsXPositionAry objectAtIndex:i] floatValue];
        }
        if (selectorViewX < itemXposition)
            break;
    }
    
    if (selectorViewX > 0)
    {
        float nextValue = itemXposition - selectorViewX;
        float previousValue = selectorViewX -itempreviousXpostion;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.3];
        
        if (nextValue > previousValue)
        {
            CGRect viewFrame = view.frame;
            viewFrame.origin.x = itempreviousXpostion-sliderWidthOffSet;
            view.frame = viewFrame;
        }
        else
        {
            CGRect viewFrame = view.frame;
            viewFrame.origin.x = itemXposition-sliderWidthOffSet;
            view.frame = viewFrame;
        }
        
        [self setSelectBg];
        
        [UIView commitAnimations];
    }
    
    float selectedViewX =view.frame.origin.x+sliderWidthOffSet;
    
    if(recognizer==panRecognizerEnd)
    {
        int temIndex = [self getIndexByPositionX:selectedViewX];
        if (temIndex!=-1)
        {
            maxIndex=temIndex;
            [self invodeDelegate];
        }
    }
}


#pragma mark -
#pragma mark UIGestureRecognizerDelegate
//点击
- (void)handleTap:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer locationInView:self];
    float horizenValue=translation.x;
    float toXPoint=[self getTapPositionX:horizenValue];   //移动到的位置
    
    //移动
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3f];
    
    
    CGRect sliderFrame = sliderViewTo.frame;
    
//    if ((toXPoint - sliderWidthOffSet)<[[itemsXPositionAry objectAtIndex:1] intValue]-sliderWidthOffSet) {
//        sliderFrame.origin.x =[[itemsXPositionAry objectAtIndex:1] intValue]-sliderWidthOffSet;
//    }else{
        sliderFrame.origin.x =toXPoint - sliderWidthOffSet;
//    }
    
    
    sliderViewTo.frame = sliderFrame;
    
    int temIndex = [self getIndexByPositionX:toXPoint];
    if (temIndex!=-1)
    {
        maxIndex=temIndex;
        [self invodeDelegate];
    }
    
    [self setSelectBg];
    
    [UIView commitAnimations];
}


//拖拽
- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self];
    
    CGFloat newX=recognizer.view.frame.origin.x+ translation.x;// ;
    
    if(recognizer==panRecognizerEnd)
    {
        if(newX>SCREEN_WIDTH- 12-29+1-sliderWidthOffSet)
        {
            newX=SCREEN_WIDTH- 12-29+1-sliderWidthOffSet;
        }
        else if(newX<[[itemsXPositionAry objectAtIndex:0] intValue]-sliderWidthOffSet)
        {
            newX=[[itemsXPositionAry objectAtIndex:0] intValue]-sliderWidthOffSet;
        }
    }
    
    CGRect newFrame = CGRectMake(newX,recognizer.view.frame.origin.y, recognizer.view.frame.size.width, recognizer.view.frame.size.height);
    recognizer.view.frame = newFrame;
    
    [self setSelectBg];
    
    [recognizer setTranslation:CGPointZero inView:self];
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self calculateXposition:recognizer.view recognizer:recognizer];

    }
}

#pragma mark -
#pragma mark 回调delegate
-(void) invodeDelegate
{
    NSLog(@"prictItemArr.count==%d  ==%d",prictItemArr.count,maxIndex);
    
    if ([self.delegate respondsToSelector:@selector(xgselectedPrice:maxPrice:maxIndex:)])
    {
        int maxPrice;
        if (maxIndex==prictItemArr.count-1||maxIndex==-1)
        {
            maxPrice=GrouponMaxMaxPrice;
        }
        else
        {
            maxPrice=[[prictItemArr objectAtIndex:maxIndex] intValue];
        }
        
        NSLog(@"maxPrice:%d",maxPrice);
        
        [self.delegate xgselectedPrice:self maxPrice:maxPrice maxIndex:maxIndex];
        
    }
}

-(void) dealloc
{
  

}


@end
