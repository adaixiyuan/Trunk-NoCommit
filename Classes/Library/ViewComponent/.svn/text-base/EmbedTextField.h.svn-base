//
//  EmbedTextField.h
//  ElongClient
//  内嵌图案文字做标题的textfield
//
//  Created by 赵 海波 on 12-12-14.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmbedTextField : UIView {
@private
    UITextField *contentField;
    int offX;
    
}

@property (nonatomic, copy) NSString *placeholder;      // 同UITextField的placeholder
@property (nonatomic, copy) NSString *text;             // 同UITextField的text
@property (nonatomic, retain) UIFont *textFont;         // 同UITextField的font
@property (nonatomic, assign) BOOL abcEnabled;
@property (nonatomic, assign) BOOL abcToSystemKeyboard;
@property (nonatomic, assign) BOOL secureTextEntry;
@property (nonatomic, assign) NSInteger numberOfCharacter;
@property (nonatomic, assign) UIReturnKeyType returnKeyType;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, readonly) UITextField *textField;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL editing;             // 同UITextField的text

// 用系统的输入框初始化
- (id)initWithFrame:(CGRect)frame IconPath:(NSString *)path;
- (id)initWithFrame:(CGRect)frame Title:(NSString *)title TitleFont:(UIFont*)font;
- (id)initWithFrame:(CGRect)frame IconPath:(NSString *)path Title:(NSString *)title TitleFont:(UIFont*)font;
- (id)initWithFrame:(CGRect)frame IconPath:(NSString *)path Title:(NSString *)title TitleFont:(UIFont*)font offsetX:(NSInteger)x;

// 用自定义的输入框初始化
- (id)initCustomFieldWithFrame:(CGRect)frame IconPath:(NSString *)path;
- (id)initCustomFieldWithFrame:(CGRect)frame Title:(NSString *)title TitleFont:(UIFont*)font;
- (id)initCustomFieldWithFrame:(CGRect)frame IconPath:(NSString *)path Title:(NSString *)title TitleFont:(UIFont*)font;
- (id)initCustomFieldWithFrame:(CGRect)frame IconPath:(NSString *)path Title:(NSString *)title TitleFont:(UIFont*)font offsetX:(NSInteger)x;

- (void)addTopLineFromPositionX:(CGFloat)x length:(CGFloat)lineLength;   // 添加顶部线条，参数为坐标横向偏移量和长度
- (void)addBottomLineFromPositionX:(CGFloat)x length:(CGFloat)lineLength;   // 添加底部线条，参数为坐标横向偏移量和长度
- (void)addTarget:(id)target action:(SEL)method forControlEvents:(UIControlEvents)event;
- (void)changeKeyboardStateToSysterm:(BOOL)animated;	// 转换为系统键盘
- (void)showWordKeyboard;								// 展示字母键盘
- (void)showNumKeyboard;
- (void) setBgHidden:(BOOL)hidden;

@end
