//
//  CheckBoxButton.h
//  ElongClient
//  通用样式的单选框、复选框
//
//  Created by Zhao Haibo on 13-11-10.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBoxButton : UIView
{
    @private
    id actionTarget;            // 执行类
    SEL normalAction;           // 勾选时执行的动作
    SEL cancelAction;           // 取消勾选时执行的动作
    BOOL isSingle;              // 是否是单选框，如果是单选框会在点击时，会取消其它的选择（同级界面有效）
    
    UIImageView *icon;
    UILabel *titleLabel;
}

@property (nonatomic, assign) BOOL isSelected;				// 是否已被选中,default NO
@property (nonatomic, assign) BOOL canCancelSelected;		// 是否允许在点击自身时取消自身的选中状态，default YES
@property (nonatomic, assign) NSInteger buttonIndex;		// 类似tag的作用

- (id)initSingleCheckBoxWithTitle:(NSString *)title Frame:(CGRect)frame;   // 单选框初始化
- (id)initMutipleCheckBoxWithTitle:(NSString *)title Frame:(CGRect)frame;  // 多选框初始化

- (void)addTarget:(id)target action:(SEL)action cancelAction:(SEL)otherAction;   // 添加目标和勾选、不勾选时的动作

@end
