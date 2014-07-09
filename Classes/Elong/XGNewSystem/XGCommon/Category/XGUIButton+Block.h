//
//  XGUIButton+Block.h
//  ElongClient
//
//  Created by guorendong on 14-5-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonClick)(UIButton *button);
@interface UIButton (Block)
-(UIButton *)setBlock:(ButtonClick)x;
@property(nonatomic,copy)ButtonClick selectIndex;

@end
