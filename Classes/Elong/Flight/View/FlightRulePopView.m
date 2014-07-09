//
//  FlightRulePopView.m
//  ElongClient
//
//  Created by 赵 海波 on 14-3-31.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightRulePopView.h"

@implementation FlightRulePopView

- (id)initWithReturnRegulation:(NSString *)returnReg
              changeRegulation:(NSString *)changeReg
                      signRule:(NSString *)signRule
{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)])
    {
        backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.1;
        [self addSubview:backgroundView];
        
        // 单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailMarkSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [backgroundView addGestureRecognizer:singleTap];
        
        [self makeUpRegulationViewWithReturnRegulation:returnReg ChangeRegulation:changeReg signRule:signRule];
        
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
// 生成中间退改签内容页
- (void)makeUpRegulationViewWithReturnRegulation:(NSString *)returnReg ChangeRegulation:(NSString *)changeReg signRule:(NSString *)signRule
{
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 100, 92, 17)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"退改签规则：";
    titleLabel.font = FONT_B13;
    [self addSubview:titleLabel];
    [titleLabel release];
    
    // 内容
    int height = SCREEN_4_INCH ? 408 : 338;
    UITextView *regulationView = [[UITextView alloc] initWithFrame:CGRectMake(8, titleLabel.frame.origin.y + 30, 304, height)];
    regulationView.backgroundColor = [UIColor clearColor];
    regulationView.textColor = [UIColor whiteColor];
    regulationView.font = FONT_B13;
    regulationView.editable = YES;
    regulationView.delegate = self;
    regulationView.textAlignment = UITextAlignmentLeft;
    [self addSubview:regulationView];
    [regulationView release];
    
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
    regulationView.text = regulationStr;
}


#pragma mark -

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

