//
//  CheapCalendarView.m
//  ElongClient
//
//  Created by bruce on 14-3-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CheapCalendarView.h"

// ==================================================================
#pragma mark - 布局参数
// ==================================================================
// 控件尺寸
#define kCalendarContainerHeight                    44
#define kCalendarViewItemWidth                      90
#define kCalendarViewItemHeight                     44
#define kCalendarIndicatorViewWidth                 25
#define kCalendarIndicatorViewHeight                25

// 边框局
#define kCalendarViewItemTopMargin                  5
#define kCalendarViewItemMiddleMargin               6

// 字体
#define kCalendarItemRow1LabelFont                  [UIFont systemFontOfSize:13.0f]
#define kCalendarItemRow2LabelFont                  [UIFont systemFontOfSize:14.0f]

// 控件Tag
enum CheapCalendarViewTag {
    kCalendarViewCalendarContainerTag = 100,
    kCalendarViewItemViewTag = 200,
    kCalendarViewItemRow1LabelTag = 300,
    kCalendarViewItemRow2LabelTag = 400,
};


#define kCalendarItemCount                          7


@interface CheapCalendarView ()

@property (nonatomic, strong) UIScrollView *calendarContainer;		// 容器view
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;	// 提示旋转
@property (nonatomic, strong) UIView *viewMask;		// 遮罩View

@end

@implementation CheapCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _calendarContainer = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_calendarContainer setBackgroundColor:RGBACOLOR(44, 98, 244, 1.0)];
        [_calendarContainer setShowsVerticalScrollIndicator:NO];
        [_calendarContainer setShowsHorizontalScrollIndicator:NO];
        [_calendarContainer setDelegate:self];
        
        // 创建子界面
        [self initCalendarContainer:_calendarContainer];
        
        // 保存
        [self addSubview:_calendarContainer];
        
        // 遮罩View
        _viewMask = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewMask setBackgroundColor:[UIColor blackColor]];
        [_viewMask setAlpha:0.3];
        [_viewMask setHidden:YES];
        
        // 保存
        [self addSubview:_viewMask];
        
        // 提示旋转
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorView setHidden:YES];
		[self addSubview:_indicatorView];
        
        
        [self reLayout];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	[self reLayout];
}

//
- (void)initCalendarContainer:(UIScrollView *)viewContainer
{
    NSInteger itemCount = kCalendarItemCount;
    
    for (NSInteger i=0; i<itemCount; i++)
    {
        UIButton *buttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [buttonItem setBackgroundImage:[UIImage imageNamed:@"btn_lowPriceItem_nomal.png"] forState:UIControlStateNormal];
        [buttonItem addTarget:self action:@selector(itemPressed:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        [buttonItem addTarget:self action:@selector(itemDown:) forControlEvents:UIControlEventTouchDown];
        [buttonItem addTarget:self action:@selector(itemDragExit:) forControlEvents:UIControlEventTouchDragExit];
        
        [buttonItem setTag:(kCalendarViewItemViewTag+i)];
        
        // 子界面
        [self initCalendarItemSubs:buttonItem withIndex:i];
        // 保存
        [viewContainer addSubview:buttonItem];
        
    }
}

// 初始化item
- (void)initCalendarItemSubs:(UIButton *)viewParent withIndex:(NSInteger)index
{
    // row1
    UILabel *labelRow1 = [[UILabel alloc] init];
    [labelRow1 setBackgroundColor:[UIColor clearColor]];
	[labelRow1 setFont:kCalendarItemRow1LabelFont];
    [labelRow1 setTextColor:[UIColor whiteColor]];
    [labelRow1 setTag:(kCalendarViewItemRow1LabelTag+index)];
    [labelRow1 setTextAlignment:NSTextAlignmentCenter];
	[viewParent addSubview:labelRow1];
    
    
    // row2
    UILabel *labelRow2 = [[UILabel alloc] init];
    [labelRow2 setBackgroundColor:[UIColor clearColor]];
	[labelRow2 setFont:kCalendarItemRow2LabelFont];
    [labelRow2 setTextColor:[UIColor whiteColor]];
    [labelRow2 setTag:(kCalendarViewItemRow2LabelTag+index)];
    [labelRow2 setTextAlignment:NSTextAlignmentCenter];
	[viewParent addSubview:labelRow2];
}


- (void)reLayout
{
    NSInteger spaceXStart = 0;
	NSInteger spaceXEnd = self.frame.size.width;
	NSInteger spaceYStart = 0;
	NSInteger spaceYEnd = self.frame.size.height;
    
    
    // 设置container的frame
    [_calendarContainer setFrame:CGRectMake(0, 0, spaceXEnd-spaceXStart, spaceYEnd-spaceYStart)];
    
    // 设置内容尺寸
    [_calendarContainer setContentSize:CGSizeMake(kCalendarItemCount * kCalendarViewItemWidth, spaceYEnd-spaceYStart)];
    
    // 创建内容Item
    [self setupCalendarContainer:_calendarContainer];
    
    
    // 遮罩View
    [_viewMask setFrame:CGRectMake(0, 0, spaceXEnd-spaceXStart, spaceYEnd-spaceYStart)];
    
    // 提示旋转
    [_indicatorView setFrame:CGRectMake((self.frame.size.width-kCalendarIndicatorViewWidth)/2,
                                        (self.frame.size.height-kCalendarIndicatorViewHeight)/2,
                                        kCalendarIndicatorViewWidth,
                                        kCalendarIndicatorViewHeight)];
}

// 创建Container中Item
- (void)setupCalendarContainer:(UIScrollView *)viewContainer
{
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    
    NSInteger itemCount = kCalendarItemCount;
    
    for (NSInteger i=0; i<itemCount; i++)
    {
        UIButton *buttonItem = (UIButton *)[viewContainer viewWithTag:kCalendarViewItemViewTag+i];
        [buttonItem setFrame:CGRectMake(spaceXStart, (kCalendarContainerHeight-kCalendarViewItemHeight)/2, kCalendarViewItemWidth, kCalendarViewItemHeight)];
        
        // 创建子视图
        [self setupCalendarItemSubs:buttonItem withIndex:i];
        
        spaceXStart += kCalendarViewItemWidth;
    }
    
}

// 创建item
- (void)setupCalendarItemSubs:(UIButton *)viewParent withIndex:(NSInteger)index
{
    // 内容尺寸大小
    if ([_arrayRow1 count] > index)
    {
        NSString *row1String = [_arrayRow1 objectAtIndex:index];
        if (STRINGHASVALUE(row1String))
        {
            CGSize row1Size = [row1String sizeWithFont:kCalendarItemRow1LabelFont];
            
            UILabel *labelRow1 = (UILabel *)[viewParent viewWithTag:kCalendarViewItemRow1LabelTag+index];
            [labelRow1 setFrame:CGRectMake((kCalendarViewItemWidth-row1Size.width)/2, kCalendarViewItemTopMargin, row1Size.width, row1Size.height)];
            [labelRow1 setText:row1String];
        }
        
    }
    
    if ([_arrayRow2 count] > index)
    {
        NSString *row2String = [_arrayRow2 objectAtIndex:index];
        
        if (STRINGHASVALUE(row2String))
        {
            CGSize row2Size = [row2String sizeWithFont:kCalendarItemRow2LabelFont];
            
            UILabel *labelRow2 = (UILabel *)[viewParent viewWithTag:kCalendarViewItemRow2LabelTag+index];
            [labelRow2 setFrame:CGRectMake((kCalendarViewItemWidth-row2Size.width)/2, (kCalendarViewItemHeight-kCalendarViewItemTopMargin-row2Size.height), row2Size.width, row2Size.height)];
            [labelRow2 setText:row2String];
        }
    }
}

// =======================================================================
#pragma mark - 辅助函数
// =======================================================================
- (void)setArrayRow1:(NSArray *)arrayRow1
{
    _arrayRow1 = arrayRow1;
    
    [self reLayout];
}

- (void)setArrayRow2:(NSArray *)arrayRow2
{
    _arrayRow2 = arrayRow2;
    
    [self reLayout];
}

// 设置item是否有效
- (void)setItemCount:(NSInteger)count
{
    for (NSInteger i=0; i<kCalendarItemCount; i++)
    {
        UIButton *buttonItem = (UIButton *)[_calendarContainer viewWithTag:kCalendarViewItemViewTag+i];
        if ([buttonItem tag] == (kCalendarViewItemViewTag+i))
        {
            if (i<count)
            {
                [buttonItem setEnabled:YES];
            }
            else
            {
                [buttonItem setEnabled:NO];
            }
        }
    }
}

// 设置高亮状态的item
- (void)setItemHighlight:(NSInteger)itemIndex
{
    for (NSInteger i=0; i<kCalendarItemCount; i++)
    {
        UIButton *buttonItem = (UIButton *)[_calendarContainer viewWithTag:kCalendarViewItemViewTag+i];
        if ([buttonItem tag] == (kCalendarViewItemViewTag+itemIndex))
        {
            [buttonItem setBackgroundImage:[UIImage imageNamed:@"btn_lowPriceItem_press.png"] forState:UIControlStateNormal];
            
            // 移动item位置
            CGPoint itemCenter = CGPointMake(itemIndex*kCalendarViewItemWidth+kCalendarViewItemWidth/2, kCalendarViewItemHeight/2);
            [_calendarContainer scrollRectToVisible:CGRectMake(itemCenter.x - roundf(_calendarContainer.frame.size.width/2.),
                                                               itemCenter.y - roundf(_calendarContainer.frame.size.height/2.),
                                                               _calendarContainer.frame.size.width,
                                                               _calendarContainer.frame.size.height)
                                           animated:YES];
        }
        else
        {
            [buttonItem setBackgroundImage:[UIImage imageNamed:@"btn_lowPriceItem_nomal.png"] forState:UIControlStateNormal];
        }
    }
}

// 加载状态
- (void)calendarStartLoading
{
    [_viewMask setHidden:NO];
    [_indicatorView setHidden:NO];
    [_indicatorView startAnimating];
}

// 停止加载
- (void)calendarEndLoading
{
    [_viewMask setHidden:YES];
    [_indicatorView stopAnimating];
    [_indicatorView setHidden:YES];
    
}

// =======================================================================
#pragma mark - 事件处理函数
// =======================================================================
- (void)itemDown:(id)sender
{
    // 按下时将周围按钮置为不可用
    UIButton *itemButton = (UIButton *)sender;
    NSInteger selectIndex = [itemButton tag] - kCalendarViewItemViewTag;
    
    for (NSInteger i=0; i<kCalendarItemCount; i++)
    {
        UIButton *buttonItem = (UIButton *)[_calendarContainer viewWithTag:kCalendarViewItemViewTag+i];
        if ([buttonItem tag] == (kCalendarViewItemViewTag+selectIndex))
        {
            [buttonItem setEnabled:YES];
        }
        else
        {
            [buttonItem setEnabled:NO];
        }
    }
    
}

// 拖动移开时将按钮置为可用
- (void)itemDragExit:(id)sender
{
    // 将按钮切换为可用
    for (NSInteger i=0; i<kCalendarItemCount; i++)
    {
        UIButton *buttonItem = (UIButton *)[_calendarContainer viewWithTag:kCalendarViewItemViewTag+i];
        [buttonItem setEnabled:YES];
    }
}


- (void)itemPressed:(id)sender forEvent:(UIEvent*)event
{
    UIButton *itemButton = (UIButton *)sender;
    
    NSInteger selectIndex = [itemButton tag] - kCalendarViewItemViewTag;
    
    // 将按钮切换为可用
    for (NSInteger i=0; i<kCalendarItemCount; i++)
    {
        UIButton *buttonItem = (UIButton *)[_calendarContainer viewWithTag:kCalendarViewItemViewTag+i];
        [buttonItem setEnabled:YES];
    }
    
    // 代理返回进行处理
    if((_delegate != nil) && ([_delegate respondsToSelector:@selector(selectPriceDate:)] == YES))
    {
        [_delegate selectPriceDate:selectIndex];
    }

}


//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _calendarContainer)
    {
        // 将按钮切换为可用
        for (NSInteger i=0; i<kCalendarItemCount; i++)
        {
            UIButton *buttonItem = (UIButton *)[_calendarContainer viewWithTag:kCalendarViewItemViewTag+i];
            [buttonItem setEnabled:YES];
        }
    }
}


@end
