//
//  UIActionSheet+Block.m
//  ElongClient
//
//  Created by guorendong on 14-5-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGUIActionSheet+Block.h"
#import <objc/runtime.h>
static char indexKey;

@implementation UIActionSheet (Block)

@dynamic selectIndex;
-(void)setSelectIndex:(SelectedIndex)selectIndex
{
    objc_setAssociatedObject(self, &indexKey, selectIndex,OBJC_ASSOCIATION_COPY);
}
-(SelectedIndex)selectIndex
{
    return (SelectedIndex)(objc_getAssociatedObject(self, &indexKey));
}
-(void)setBlockAndShowInView:(UIView *)view block:(SelectedIndex)x
{
    self.delegate=self;
    [self setSelectIndex:x];
    [self showInView:view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([self selectIndex]) {
        SelectedIndex ssindex =[self selectIndex];
        ssindex(self,buttonIndex);
    }
}
@end
