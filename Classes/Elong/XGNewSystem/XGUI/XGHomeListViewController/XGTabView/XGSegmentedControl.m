//
//  XGSegmentedControl.m
//  ElongClient
//
//  Created by guorendong on 14-4-29.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGSegmentedControl.h"

@implementation XGSegmentedControl



#pragma mark - 属性实现
@synthesize tabView1=_tabView1;
-(XGTabView *)tabView1
{
    if (_tabView1 ==nil) {
        _tabView1 =[[XGTabView alloc] init];
        [_tabView1 setTabInfoForText:@"推荐" textColor:[UIColor whiteColor]];
        _tabView1.layer.borderColor=[XGTabBackColor CGColor];
        _tabView1.layer.borderWidth=1;
    }
    return _tabView1;
}
@synthesize tabView2=_tabView2;
-(XGTabView *)tabView2
{
    if (_tabView2 ==nil) {
        _tabView2 =[[XGTabView alloc] init];
        _tabView2.layer.borderColor=[XGTabBackColor CGColor];
        [_tabView2 setTabInfoForText:@"价格" textColor:[UIColor blackColor]];
        _tabView2.layer.borderWidth=1;
        _tabView2.imageView.image=[UIImage imageNamed:@"XGRank_normal"];
    }
    return _tabView2;
}
@synthesize tabView3=_tabView3;
-(XGTabView *)tabView3
{
    if (_tabView3 ==nil) {
        _tabView3 =[[XGTabView alloc] init];
        _tabView3.layer.borderColor=[XGTabBackColor CGColor];
        [_tabView3 setTabInfoForText:@"距离" textColor:[UIColor blackColor]];
        _tabView3.layer.borderWidth=1;
    }
    return _tabView3;
}
@synthesize tabView4=_tabView4;
-(XGTabView *)tabView4
{
    if (_tabView4 ==nil) {
        _tabView4 =[[XGTabView alloc] init];
        _tabView4.layer.borderColor=[XGTabBackColor CGColor];
        [_tabView4 setTabInfoForText:@"星级" textColor:[UIColor blackColor]];
        _tabView4.layer.borderWidth=1;
        _tabView4.imageView.image=[UIImage imageNamed:@"XGRank_normal"];
    }
    return _tabView4;
}
#pragma mark - 基类方法
-(id)init
{
    self =[super init];
    if (self) {
        [self setPro];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        [self setPro];
    }
    return self;
}

-(void)setPro
{
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=3;
    self.layer.borderWidth=1;
    self.layer.borderColor=[XGTabBackColor CGColor];
    [self addSubview:self.tabView1];
    [self addSubview:self.tabView2];
    [self addSubview:self.tabView3];
    [self addSubview:self.tabView4];
}

#define tabHeight 30

-(void)layoutSubviews
{
    [super layoutSubviews];
    float tabViewWidth =self.width/4.0;
    self.tabView1.frame=CGRectMake(0, self.height/2-tabHeight/2, tabViewWidth+1, tabHeight);
    self.tabView2.frame=CGRectMake(tabViewWidth, self.height/2-tabHeight/2, tabViewWidth+1, tabHeight);
    self.tabView3.frame=CGRectMake(tabViewWidth*2, self.height/2-tabHeight/2, tabViewWidth+1, tabHeight);
    self.tabView4.frame=CGRectMake(tabViewWidth*3, self.height/2-tabHeight/2, tabViewWidth, tabHeight);
}

@end
