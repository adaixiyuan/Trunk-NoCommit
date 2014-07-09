//
//  UIView+Addtions.m
//  ElongClient
//
//  Created by nieyun on 14-5-9.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "UIView+Addtions.h"

@implementation UIView (Addtions)
-(UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    while (next != nil)
    {
        if ([next isKindOfClass:[UIViewController class]])
        {
            
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
    }
    
    return nil;
}

@end
