//
//  UIActionSheet+Block.m
//  ElongClient
//
//  Created by guorendong on 14-5-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGUIAlterView+Block.h"
#import <objc/runtime.h>
static char indexKey;

@implementation UIAlertView (Block)

@dynamic selectIndex;
-(void)setSelectIndex:(UIAlterSelectedIndex)selectIndex
{
    objc_setAssociatedObject(self, &indexKey, selectIndex,OBJC_ASSOCIATION_COPY);
}
-(UIAlterSelectedIndex)selectIndex
{
    return (UIAlterSelectedIndex)(objc_getAssociatedObject(self, &indexKey));
}
-(void)setBlockAndShow:(UIAlterSelectedIndex)x
{
    self.delegate=self;
    [self setSelectIndex:x];
    [self show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([self selectIndex]) {
        UIAlterSelectedIndex ssindex =[self selectIndex];
        ssindex(self,buttonIndex);
    }
    
}

+(UIAlertView *)show:(NSString *)message butionTitle:(NSString *)title
{
    UIAlertView *alter =[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:title otherButtonTitles:nil];
    [alter show];
    return alter;
}


+(UIAlertView *)show:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    [NSString stringWithFormat:@""];
    UIAlertView *a =[[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
    [a show];
    return a;
}



+(UIAlertView *)show:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle selectIndex:(UIAlterSelectedIndex)alter otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    
    UIAlertView *a =[[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
    [a setBlockAndShow:alter];
    return a;

}
+(UIAlertView *)show:(NSString *)message title:(NSString *)title delaySecond:(NSInteger)second
{
    UIAlertView *alter =[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alter show];
    [alter performSelector:@selector(hideAlter) withObject:nil afterDelay:second];
    return alter;
}

+(UIAlertView *)show:(NSString *)message delaySecond:(NSInteger)second
{
    [UIAlertView show:message title:nil delaySecond:second];
}
-(void)hideAlter
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}


@end
