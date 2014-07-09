//
//  CTField.m
//  TableTest
//
//  Created by Janven Zhao on 14-1-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CTField.h"

@implementation CTField

- (id)initWithFrame:(CGRect)frame andType:(CT_Type)aType
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _type = aType;
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

/*
//控制清楚按钮的位置
-(CGRect)clearButtonRectForBounds:(CGRect)bounds{

     return CGRectMake(bounds.origin.x + bounds.size.width - 20, bounds.origin.y + bounds.size.height -20, 16, 16);
    
}
*/

//控制placeHolder的位置
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset;
    if (self.type == CT_Setting_edit) {
        inset =     CGRectMake(bounds.origin.x+30, bounds.origin.y+13, bounds.size.width -30, bounds.size.height-20);
    }else if (self.type == CT_PackingLib_edit){
        inset =   CGRectMake(bounds.origin.x+60, bounds.origin.y+13, bounds.size.width -60, bounds.size.height-20);
    }else if (self.type == CT_Exchange_Tap){
        inset = CGRectMake(0, bounds.origin.y+26, bounds.size.width, bounds.size.height-26);
    }
    if (IOSVersion_7) {
        inset.origin.y = inset.origin.y - 3.0f;
    }
    return inset;
}
//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset;
    if (self.type == CT_Setting_edit) {
        inset = CGRectMake(bounds.origin.x+30, bounds.origin.y+17, bounds.size.width-30, bounds.size.height-17);
    }else if(self.type == CT_PackingLib_edit){
        inset = CGRectMake(bounds.origin.x+50, bounds.origin.y+17, bounds.size.width -50, bounds.size.height-17);
    }else if (self.type == CT_Exchange_Tap){
        inset = CGRectMake(0, bounds.origin.y+26, bounds.size.width, bounds.size.height-26);
    }
    if (IOSVersion_7) {
        inset.origin.y = inset.origin.y - 3.0f;
    }
    return inset;
    
}
//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset;
    if (self.type == CT_Setting_edit) {
        inset = CGRectMake(bounds.origin.x +30, bounds.origin.y+15, bounds.size.width -30, bounds.size.height-15);
    }else if (self.type == CT_PackingLib_edit){
        inset = CGRectMake(bounds.origin.x +45, bounds.origin.y+15, bounds.size.width -45, bounds.size.height-15);
    }else if (self.type == CT_Exchange_Tap){
        inset = CGRectMake(0, bounds.origin.y+26, bounds.size.width, bounds.size.height-40);
    }
    
    if (IOSVersion_7) {
        inset.origin.y = inset.origin.y - 3.0f;
    }
    
    return inset;
}

//控制左视图位置
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect inset;
    if (self.type == CT_Setting_edit) {
        inset = CGRectMake(bounds.origin.x +10, bounds.origin.y+15.5, 13,13);
    }else if (self.type == CT_PackingLib_edit){
        inset = CGRectMake(bounds.origin.x +23, bounds.origin.y+15.5, 13,13);
    }else if (self.type == CT_Exchange_Tap){
        inset = CGRectMake(0,16, 200,14);
    }
    return inset;
}

//控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect
{
        [RGBACOLOR(35, 119, 232, 1) setFill];
        [[self placeholder] drawInRect:rect withFont: [UIFont systemFontOfSize:15]];
}


@end
