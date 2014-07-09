//
//  PublicMethods_ARC.m
//  ElongClient
//  公共方法（全为arc）
//
//  Created by 赵 海波 on 14-6-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "PublicMethods_ARC.h"
#import "AttributedLabel.h"

@implementation PublicMethods_ARC

+ (id)creatViewWithType:(NSString *)classType andParent:(UIView *)viewParent andTag:(NSInteger)viewTag;
{
    id targetItem = [viewParent viewWithTag:viewTag];
    if (targetItem == nil)
    {
        if ([classType isEqualToString:@"UILabel"])
        {
            targetItem = [[UILabel alloc] initWithFrame:CGRectZero];
        }
        else if ([classType isEqualToString:@"UIView"])
        {
            targetItem = [[UIView alloc] initWithFrame:CGRectZero];
        }
        else if ([classType isEqualToString:@"UIButton"])
        {
            targetItem = [[UIButton alloc] initWithFrame:CGRectZero];
        }
        else if ([classType isEqualToString:@"UIImageView"])
        {
            targetItem = [[UIImageView alloc] initWithFrame:CGRectZero];
        }
        else if ([classType isEqualToString:@"AttributedLabel"])
        {
            targetItem = [[AttributedLabel alloc] initWithFrame:CGRectZero];
        }
        
        [targetItem setTag:viewTag];
        
        // 保存
        [viewParent addSubview:targetItem];
    }
    
    return targetItem;
}

@end
