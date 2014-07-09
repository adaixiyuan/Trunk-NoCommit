//
//  FlightDetailPopView.m
//  ElongClient
//
//  Created by 赵 海波 on 14-1-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightDetailPopView.h"
#import "AttributedLabel.h"

@implementation FlightDetailPopView

- (id)initWithHighLightTitle:(NSString *)hTitle
                  spaceTitle:(NSString *)sTitle
          isLegislationPirce:(BOOL)isLegis
                 ticketPrice:(NSString *)priceStr
                      airTax:(NSString *)airTax
                      oilTax:(NSString *)oilTax
            returnRegulation:(NSString *)returnReg
            changeRegulation:(NSString *)changeReg
                    signRule:(NSString *)signRule
                 orderEnable:(BOOL)orderEnable
                    is51Book:(BOOL)is51Book
{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)])
    {
        backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.1;
        [self addSubview:backgroundView];
        
        offY = SCREEN_4_INCH ? 60 : 40;
        
        // 是否可订
        _orderEnable = orderEnable;
        
        //
        [self setIs51Book:is51Book];
        
        // 单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailMarkSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [backgroundView addGestureRecognizer:singleTap];
        
        [self makeUpTitleViewWithHighLightTitle:hTitle spaceTitle:sTitle isLegislationPirce:isLegis ticketPrice:priceStr airTax:airTax oilTax:oilTax];
        
        [self makeUpRegulationViewWithReturnRegulation:returnReg ChangeRegulation:changeReg signRule:signRule];
        
        [self makeUpOrderButton];
        
        // 取消按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setImage:[UIImage noCacheImageNamed:@"photo_close.png"] forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(SCREEN_WIDTH - 54, 4, 60, 60);
        [cancelBtn addTarget:self action:@selector(closeRoomDetail) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        // 动画开始
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 0.8;
        }];
    }
    
    return self;
}


#pragma mark - UI Methods

// 生成顶部标题栏
- (void)makeUpTitleViewWithHighLightTitle:(NSString *)hTitle
                               spaceTitle:(NSString *)sTitle
                       isLegislationPirce:(BOOL)isLegis
                              ticketPrice:(NSString *)priceStr
                                   airTax:(NSString *)airTax
                                   oilTax:(NSString *)oilTax
{
    int offX = 0;
    
    CGRect rect = CGRectZero;
    
    // 高亮标题
    if (STRINGHASVALUE(hTitle))
    {
        highlightLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 40 + offY, 43, 17)];
        highlightLabel.textColor = [UIColor whiteColor];
        highlightLabel.backgroundColor = RGBCOLOR(46, 164, 237, 1);
        highlightLabel.font = FONT_12;
        highlightLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:highlightLabel];
        
        CGSize size = [hTitle sizeWithFont:FONT_12 constrainedToSize:CGSizeMake(150, 20)];
        highlightLabel.text = hTitle;
        rect = highlightLabel.frame;
        rect.size.width = size.width + 12;
        highlightLabel.frame = rect;
        
        offX = 5;
    }
    else
    {
        offX = 0;
    }
    
    // 普通标题
    if (STRINGHASVALUE(sTitle))
    {
        typeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 39 + offY, 92, 19)];
        typeNameLabel.textColor = [UIColor whiteColor];
        typeNameLabel.backgroundColor = [UIColor clearColor];
        typeNameLabel.font = FONT_B18;
        [self addSubview:typeNameLabel];
        
        CGSize size = [sTitle sizeWithFont:FONT_B18 constrainedToSize:CGSizeMake(160, 20)];
        
        typeNameLabel.text = sTitle;
        rect = typeNameLabel.frame;
        if (highlightLabel)
        {
            rect.origin.x = highlightLabel.frame.origin.x + highlightLabel.frame.size.width + offX;
        }
        
        rect.size.width = size.width + 2;
        typeNameLabel.frame = rect;
        
        offX = 5;
    }
    else
    {
        offX = 0;
    }
    
    // 特惠icon
    if (isLegis)
    {
        legislationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(typeNameLabel.frame.origin.x + typeNameLabel.frame.size.width + offX, 43 + offY, 40, 12)];
        legislationIcon.image = [UIImage imageNamed:@"flight_elong_discount.png"];
        [self addSubview:legislationIcon];
    }
    
    // 票价和各种费用
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(181, 35 + offY, 127, 28)];
    priceLabel.textAlignment = UITextAlignmentRight;
    priceLabel.textColor = [UIColor orangeColor];
    priceLabel.text = priceStr;
    priceLabel.font = [UIFont systemFontOfSize:28];
    priceLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:priceLabel];
    
    AttributedLabel *taxLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(12, 66 + offY, 192, 19)];
    taxLabel.text = [NSString stringWithFormat:@"机建%@／燃油%@", airTax, oilTax];
    taxLabel.backgroundColor = [UIColor clearColor];
    [taxLabel setColor:[UIColor whiteColor] fromIndex:0 length:taxLabel.text.length];
    [taxLabel setColor:[UIColor orangeColor] fromIndex:2 length:airTax.length];
    [taxLabel setColor:[UIColor orangeColor] fromIndex:airTax.length + 5 length:oilTax.length];
    [taxLabel setFont:FONT_B13 fromIndex:0 length:taxLabel.text.length];
    [self addSubview:taxLabel];
}


// 生成中间退改签内容页
- (void)makeUpRegulationViewWithReturnRegulation:(NSString *)returnReg ChangeRegulation:(NSString *)changeReg signRule:(NSString *)signRule
{
    NSInteger subsHeight = 0;
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, offY + 94, 92, 17)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"退改签规则：";
    titleLabel.font = FONT_B13;
    [self addSubview:titleLabel];
    
    // 间隔
    offY += 5;
    
    // 内容
    int height = SCREEN_4_INCH ? 300 : 230;
    
    UIScrollView *viewContent = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [viewContent setFrame:CGRectMake(6, offY + 119, 308, height)];
    [viewContent setBackgroundColor:[UIColor clearColor]];
    [viewContent setShowsVerticalScrollIndicator:NO];
    [viewContent setShowsHorizontalScrollIndicator:NO];
    
    [self addSubview:viewContent];
    
    // 记录y方向位移
    offY += 119 + height;
    
    // 退改签规则
    if (!STRINGHASVALUE(returnReg))
    {
        returnReg = @"无信息";
    }
    if (!STRINGHASVALUE(changeReg))
    {
        changeReg = @"无信息";
    }
    if (!STRINGHASVALUE(signRule))
    {
        signRule = @"无信息";
    }
    
    NSString *regulationStr = [NSString stringWithFormat:@"退票条件：\n%@\n\n改期条件：\n%@\n\n签转条件：\n%@\n\n", returnReg, changeReg, signRule];
    
    CGSize ruleSize = [regulationStr sizeWithFont:FONT_B13
                                    constrainedToSize:CGSizeMake(304, CGFLOAT_MAX)
                                        lineBreakMode:UILineBreakModeCharacterWrap];
    // 创建Label
    UILabel *labelRule = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, 304, ruleSize.height)];
    labelRule.backgroundColor = [UIColor clearColor];
    labelRule.textColor = [UIColor whiteColor];
    labelRule.numberOfLines = 0;
    labelRule.lineBreakMode = UILineBreakModeCharacterWrap;
    labelRule.text = regulationStr;
    labelRule.font = FONT_B13;
    [viewContent addSubview:labelRule];
    
    // 子窗体大小
    subsHeight += ruleSize.height;
    
    // 间隔
    subsHeight += 5;
    
    if (_is51Book)
    {
        // 网络专享代理
        UIImageView *netPromotion = [[UIImageView alloc] initWithFrame:CGRectMake(5, subsHeight, 23, 12)];
        [netPromotion setImage:[UIImage imageNamed:@"ico_netpromotion.png"]];
        
        [viewContent addSubview:netPromotion];
        
        subsHeight += netPromotion.frame.size.height;
        
        // 间隔
        subsHeight += 5;
        
        // 代理内容
        UILabel *labelPromotion = [[UILabel alloc] initWithFrame:CGRectMake(5, subsHeight, 304, 17)];
        labelPromotion.backgroundColor = [UIColor clearColor];
        labelPromotion.textColor = [UIColor whiteColor];
        labelPromotion.text = @"此产品不提供行程单；仅提供普通发票，限邮寄。";
        labelPromotion.font = FONT_B13;
        [viewContent addSubview:labelPromotion];
        
        subsHeight += labelPromotion.frame.size.height;
    }

    
    // 设置内容尺寸
    [viewContent setContentSize:CGSizeMake(viewContent.frame.size.width, subsHeight)];
    
    
}


// 生成底部预订按钮
- (void)makeUpOrderButton
{
    UIButton *orderBtn = [UIButton uniformButtonWithTitle:@"立即预订" ImagePath:@"" Target:self Action:@selector(clickOrderButton) Frame:CGRectMake(12, offY + 12, 294, 46)];
    [orderBtn setHidden:!_orderEnable];
    [self addSubview:orderBtn];
}


#pragma mark -

// 点击预订按钮
- (void)clickOrderButton
{
    [self closeRoomDetail];
    
    if ([_root respondsToSelector:@selector(clickOrderButtonAtIndex:)])
    {
        UMENG_EVENT(UEvent_Flight_Detail_RuleBooking)
        [_root clickOrderButtonAtIndex:_rowNum];
    }
}


- (void)detailMarkSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self closeRoomDetail];
}


- (void)closeRoomDetail
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}


#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

@end
