//
//  CustomTextField.h
//  Keybord
//
//  Created by Wang Shuguang on 12-8-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    CustomTextFieldKeyboardTypeDefault,    // 默认字符键盘
    CustomTextFieldKeyboardTypeNumber      // 数字键盘
}CustomTextFieldKeyboardType;   // 键盘类型

@class KeyboardView;
@interface CustomTextField : UITextField {
@private
	NSInteger numberOfCharacter;
}

@property (nonatomic) BOOL abcEnabled;
@property (nonatomic) BOOL abcToSystemKeyboard;			// 按abc切回系统键盘
@property (nonatomic) NSInteger numberOfCharacter;
@property (nonatomic) CustomTextFieldKeyboardType fieldKeyboardType;     // 键盘类型

- (void)changeKeyboardStateToSysterm:(BOOL)animated;	// 转换为系统键盘
- (void)showWordKeyboard;								// 展示字母键盘
- (void) resetTargetKeyboard;
- (void)showNumKeyboard;
@end

