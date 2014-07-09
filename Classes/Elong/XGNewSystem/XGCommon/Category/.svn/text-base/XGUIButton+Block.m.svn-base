//
//  UIActionSheet+Block.m
//  ElongClient
//
//  Created by guorendong on 14-5-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGUIButton+Block.h"
#import <objc/runtime.h>
static char indexKey;

@implementation UIButton (Block)

@dynamic selectIndex;
-(void)setSelectIndex:(ButtonClick)selectIndex
{
    objc_setAssociatedObject(self, &indexKey, selectIndex,OBJC_ASSOCIATION_COPY);
}
-(ButtonClick)selectIndex
{
    return (ButtonClick)(objc_getAssociatedObject(self, &indexKey));
}
-(UIButton *)setBlock:(ButtonClick)x
{
    [self setSelectIndex:x];
    [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)click
{
    if ([self selectIndex]) {
        ButtonClick ssindex =[self selectIndex];
        ssindex(self);
    }
}
@end
