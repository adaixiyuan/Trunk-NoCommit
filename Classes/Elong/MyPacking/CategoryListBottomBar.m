//
//  CategoryListBottomBar.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-1-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CategoryListBottomBar.h"

/*
 *高度 45 包含两个按钮 
 */

#define IMAGE_OPEN         [UIImage imageNamed:@"packing_on.png"] //40*14
#define IMAGE_CLOSE       [UIImage imageNamed:@"packing_close.png"]

@implementation CategoryListBottomBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        hideComplete = NO;//默认不隐藏
        isEdit = NO;
        
        hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [hideBtn setFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
        [hideBtn setImageEdgeInsets:UIEdgeInsetsMake(15.5, 20, 15.5, self.frame.size.width/2-20-40)];
        [hideBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [hideBtn setTitle:@"隐藏完成项" forState:UIControlStateNormal];
        [hideBtn setImage:(hideComplete)?IMAGE_OPEN:IMAGE_CLOSE forState:UIControlStateNormal];
        [hideBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [hideBtn addTarget:self action:@selector(handleTheHiddenBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hideBtn];
        
        //添加竖线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(hideBtn.frame.size.width, 0,1, self.frame.size.height)];
        line.backgroundColor = RGBACOLOR(96, 96, 96, 1);
        [self addSubview:line];
        [line release];
        
        //Edit
        editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [editBtn setFrame:CGRectMake(hideBtn.frame.size.width+0.5, 0, hideBtn.frame.size.width-0.5, self.frame.size.height)];
        [editBtn setTitle:(isEdit)?@"完成":@"删除" forState:UIControlStateNormal];
        [editBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(handleTheEditBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:editBtn];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)handleTheHiddenBtnEvent:(UIButton *)sender{
    
    hideComplete = !hideComplete;
    [hideBtn setImage:(hideComplete)?IMAGE_OPEN:IMAGE_CLOSE forState:UIControlStateNormal];
    [hideBtn setTitle:(hideComplete)?@"显示完成项":@"隐藏完成项" forState:UIControlStateNormal];
    
    if (_delegate && [_delegate respondsToSelector:@selector(hideTheCompleteItemOrNot:)]) {
        [_delegate hideTheCompleteItemOrNot:hideComplete];
    }
    
}

-(void)handleTheEditBtnEvent:(UIButton *)sender{

    isEdit = !isEdit;
    [editBtn setTitle:(isEdit)?@"完成":@"删除" forState:UIControlStateNormal];
    
    if (_delegate && [_delegate respondsToSelector:@selector(tapTheEditButtonWithStatus:)]) {
        [_delegate tapTheEditButtonWithStatus:isEdit];
    } 
}
@end
