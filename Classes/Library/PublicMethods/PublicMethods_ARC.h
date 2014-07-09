//
//  PublicMethods_ARC.h
//  ElongClient
//
//  Created by 赵 海波 on 14-6-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicMethods_ARC : NSObject

// 创建界面方法抽象
+ (id)creatViewWithType:(NSString *)classType andParent:(UIView *)viewParent andTag:(NSInteger)viewTag;

@end
