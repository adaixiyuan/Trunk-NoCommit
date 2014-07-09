//
//  XGTabView.m
//  ElongClient
//
//  Created by guorendong on 14-4-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGTabView.h"
@interface XGTabView()

@property(nonatomic,strong)UILabel *lable;

@end
@implementation XGTabView




-(void)clickImageView
{
    if (self.touchTabView) {
        self.touchTabView(self);
    }
}
#pragma mark - 属性实现
@synthesize lable=_lable;
-(UILabel *)lable
{
    if (_lable ==nil) {
        _lable =[[UILabel alloc] init];
        _lable.text=@"默认排序";
        _lable.textColor=[UIColor whiteColor];
        _lable.backgroundColor=[UIColor clearColor];
        _lable.textAlignment=NSTextAlignmentCenter;
        _lable.font =[UIFont systemFontOfSize:12];
    }
    return _lable;
}
@synthesize sortArrowImageView=_sortArrowImageView;
-(UIImageView *)sortArrowImageView
{
    if (_sortArrowImageView ==nil) {
        _sortArrowImageView =[[UIImageView alloc] init];
    }
    return _sortArrowImageView;
}

#pragma mark - 自定义方法

-(void)setTabInfoForText:(NSString *)text
{
    self.lable.text=text;
    [self layoutSubviews];
}
-(void)setTabInfoForText:(NSString *)text touchTabView:(XGTouchTabView)touchTabView
{
    self.touchTabView=touchTabView;
    [self setTabInfoForText:text];
}

-(void)setTabInfoForText:(NSString *)text textColor:(UIColor *)textColor
{
    [self setTabInfoForText:text];
    [self setTabInfoForTextColor:textColor];
}
-(void)setTabInfoForText:(NSString *)text textColor:(UIColor *)textColor touchTabView:(XGTouchTabView)touchTabView
{
    self.touchTabView=touchTabView;
    [self setTabInfoForText:text textColor:textColor];
}

-(void)setTabInfoForTextColor:(UIColor *)textColor
{
    self.lable.textColor=textColor;
}
-(void)setTabInfoForTextColor:(UIColor *)textColor touchTabView:(XGTouchTabView)touchTabView
{
    self.touchTabView=touchTabView;
    [self setTabInfoForTextColor:textColor];
}

-(void)tabInit
{
    self.isSelected=NO;
    [self addSubview:self.lable];
    [self addSubview:self.sortArrowImageView];
    self.backgroundColor=[UIColor blackColor];
    [self addTarget:self action:@selector(clickImageView) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 基类方法
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.lable sizeToFit];
    [self.sortArrowImageView sizeToFit];
    if (self.sortArrowImageView.image ==nil) {
        
        self.lable.frame=CGRectMake(self.width/2-self.lable.width/2, self.height/2-self.lable.height/2, self.lable.width, self.lable.height);
    }
    else
    {
        self.lable.frame=CGRectMake(self.width/2-self.lable.width/2, self.height/2-self.lable.height/2, self.lable.width, self.lable.height);
        self.sortArrowImageView.frame=CGRectMake(self.lable.right+5, self.height/2-self.sortArrowImageView.height/2, self.sortArrowImageView.width, self.sortArrowImageView.height);
        
    }
}
-(id)init
{
    self =[super init];
    if (self) {
        [self tabInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self  =[super initWithFrame:frame];
    if (self) {
        [self tabInit];
    }
    return self;
}



@end
