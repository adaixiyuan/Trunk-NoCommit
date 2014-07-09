//
//  KeyboardView.m
//  Keybord
//
//  Created by Wang Shuguang on 12-8-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyboardView.h"
#import "CustomTextField.h"
#import <QuartzCore/QuartzCore.h>

@interface KeyboardView()

- (void)configKeypad;

- (UIImage *)stretchableImageWithPath:(NSString *)path;

- (UIImage *)noCacheImageNamed:(NSString *)name;

- (void)backspaceTimework;

- (void)keytone;

- (void)deleteOneword;

- (void)addOneword:(NSString *)word;

- (void)numBtnSwitch:(id) sender;

@end

#define KEYBOARDFONT [UIFont boldSystemFontOfSize:22.0f];

@implementation KeyboardView
@synthesize targetTextView;
@synthesize abcEnabled;
@synthesize isBackToSystermKey;
@synthesize showWordKeyboard;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.frame = CGRectMake(0.0f, 0.0f, 320.0f, 216.0);
		
        // 防止初始化时阻塞页面
		[self configKeypad];
		
    }
    return self;
}

- (void)configKeypad
{
	if (!abcBtn) {
        //键盘背景
        UIImageView *keyboardBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        keyboardBg.image = [self noCacheImageNamed:@"keyboard_bg.png"];
        [self addSubview:keyboardBg];
        [keyboardBg release];
        
        
        //数字键
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j<3; j++) {
                UIButton *numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                numBtn.frame = CGRectMake(5 + (2 + 102) * i, 4 + (1 + 52) * j, 102, 52);
                
                [numBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_num_one.png"] forState:UIControlStateNormal];
                [numBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_num_two.png"] forState:UIControlStateHighlighted];
                numBtn.titleLabel.font = KEYBOARDFONT;
                [numBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
                [numBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [numBtn setTitle:[NSString stringWithFormat:@"%d",j*3 + i + 1] forState:UIControlStateNormal];
                
                [self addSubview:numBtn];
                [numBtn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [numBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [numBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
                //[numBtn setTitleShadowOffset:CGSizeMake(0,2)];
                [numBtn.titleLabel setShadowOffset:CGSizeMake(0, 1)];
            }
        }
        
        //删除键
        UIButton *backspaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backspaceBtn.frame = CGRectMake(5 + (2 + 102) * 1 + 2 + 60, 163, 53, 52);
        [backspaceBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_delete.png"] forState:UIControlStateNormal];
        [backspaceBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_delete_press.png"] forState:UIControlStateHighlighted];
        [self addSubview:backspaceBtn];
        [backspaceBtn addTarget:self action:@selector(backspaceBtnTouchDown:) forControlEvents:UIControlEventTouchDown];
        [backspaceBtn addTarget:self action:@selector(backspaceBtnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //abc
        abcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        abcBtn.frame = CGRectMake(5, 163 , 102, 52);
        [abcBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_num_one.png"] forState:UIControlStateNormal];
        [abcBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_num_two.png"] forState:UIControlStateHighlighted];
        abcBtn.titleLabel.font = KEYBOARDFONT;
        [abcBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateHighlighted];
        [abcBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [abcBtn setTitle:@"ABC" forState:UIControlStateNormal];
        [abcBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [abcBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [abcBtn.titleLabel setShadowOffset:CGSizeMake(0, 1)];
        abcBtn.enabled = NO;
        
        [self addSubview:abcBtn];
        
        [abcBtn addTarget:self action:@selector(abcBtnSwitch:) forControlEvents:UIControlEventTouchUpInside];
        
        //0
        UIButton *zeroBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        zeroBtn.frame = CGRectMake(5 + (2 + 102) * 1, 163, 60, 52);
        [zeroBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_num_one.png"] forState:UIControlStateNormal];
        [zeroBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_num_two.png"] forState:UIControlStateHighlighted];
        zeroBtn.titleLabel.font = KEYBOARDFONT;
        [zeroBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
        [zeroBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [zeroBtn setTitle:[NSString stringWithFormat:@"%d",0] forState:UIControlStateNormal];
        [zeroBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [zeroBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [zeroBtn.titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [self addSubview:zeroBtn];
        [zeroBtn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //搜索
        UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        returnBtn.frame = CGRectMake(5 + (2 + 102) * 1 + 2 + 60 + 53 + 2, 163 , 88, 52);
        [returnBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_confirm.png"] forState:UIControlStateNormal];
        [returnBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_confirm_press.png"] forState:UIControlStateHighlighted];
        returnBtn.titleLabel.font = KEYBOARDFONT;
        [returnBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateHighlighted];
        [returnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [returnBtn setTitle:@"确定" forState:UIControlStateNormal];
        [returnBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [returnBtn setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        [returnBtn.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [self addSubview:returnBtn];
        [returnBtn addTarget:self action:@selector(returnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //abckeyboard
        abcKeyboard = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, 216)];
        abcKeyboard.backgroundColor = [UIColor whiteColor];
        abcKeyboard.hidden = YES;
        [self addSubview:abcKeyboard];
        [abcKeyboard release];
        
        //背景图
        UIImageView *abcBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        abcBgView.image = [self noCacheImageNamed:@"keyboard_bg.png"];
        [abcKeyboard addSubview:abcBgView];
        [abcBgView release];
        
        //字母键
        NSArray *oneLineKeys = [NSArray arrayWithObjects:@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",nil];
        NSArray *twoLineKeys = [NSArray arrayWithObjects:@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",nil];
        NSArray *threeLineKeys = [NSArray arrayWithObjects:@"Z",@"X",@"C",@"V",@"B",@"N",@"M",nil];
        NSArray *columKeys = [NSArray arrayWithObjects:oneLineKeys,twoLineKeys,threeLineKeys,nil];
        
        NSInteger columsCount = [columKeys count];
        NSInteger linesCount = 0;
        float leftMargin = 0;
        for (int i = 0; i < columsCount; i++) {
            NSArray *line = (NSArray *)[columKeys safeObjectAtIndex:i];
            linesCount = [line count];
            if (i == 0) {
                leftMargin = 1.0f;
            }else if (i == 1) {
                leftMargin = 17.0f;
            }else if (i == 2) {
                leftMargin = 49.0f;
            }
            
            for (int j = 0; j < linesCount; j++) {
                UIButton *abcKeyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                abcKeyBtn.frame = CGRectMake(leftMargin + (2 + 30) * j, 12 + i * (42 + 12), 30, 42);
                
                [abcKeyBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_abckey_one.png"] forState:UIControlStateNormal];
                [abcKeyBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_abckey_two.png"] forState:UIControlStateHighlighted];
                [abcKeyBtn setAdjustsImageWhenHighlighted:NO];
                abcKeyBtn.titleLabel.font = KEYBOARDFONT;
                [abcKeyBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
                [abcKeyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [abcKeyBtn setTitle:[NSString stringWithFormat:@"%@",[line safeObjectAtIndex:j]] forState:UIControlStateNormal];
                
                [abcKeyboard addSubview:abcKeyBtn];
                [abcKeyBtn addTarget:self action:@selector(abcBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [abcKeyBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [abcKeyBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
                [abcKeyBtn.titleLabel setShadowOffset:CGSizeMake(0, 1)];
            }
        }
        
        //大写锁定
        //abc
        upperCaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        upperCaseBtn.frame = CGRectMake(1, 12 + 2 * (42 + 12) , 40, 42);
        [upperCaseBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_uppercase.png"] forState:UIControlStateNormal];
        [upperCaseBtn setAdjustsImageWhenHighlighted:NO];
        [upperCaseBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateHighlighted];
        [upperCaseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [abcKeyboard addSubview:upperCaseBtn];
        [upperCaseBtn addTarget:self action:@selector(upperCaseDown:) forControlEvents:UIControlEventTouchDown];
        [upperCaseBtn addTarget:self action:@selector(upperCaseUp:) forControlEvents:UIControlEventTouchUpInside];
        
        //退格
        UIButton *abcbackspaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        abcbackspaceBtn.frame = CGRectMake(320 - 40 - 1, 12 + 2 * (42 + 12), 40, 42);
        [abcbackspaceBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_delete.png"] forState:UIControlStateNormal];
        [abcbackspaceBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_delete_press.png"] forState:UIControlStateHighlighted];
        [abcKeyboard addSubview:abcbackspaceBtn];
        [abcbackspaceBtn addTarget:self action:@selector(backspaceBtnTouchDown:) forControlEvents:UIControlEventTouchDown];
        [abcbackspaceBtn addTarget:self action:@selector(backspaceBtnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        
        //切换为数字键盘
        //abc
        UIButton *numSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        numSwitchBtn.frame = CGRectMake(1, 12 + 3 * (42 + 12) , 78, 42);
        [numSwitchBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_numswitch.png"] forState:UIControlStateNormal];
        [numSwitchBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_numswitch_press.png"] forState:UIControlStateHighlighted];
        numSwitchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        [numSwitchBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateHighlighted];
        [numSwitchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [numSwitchBtn setTitle:@"123" forState:UIControlStateNormal];
        [numSwitchBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [numSwitchBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [numSwitchBtn.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [abcKeyboard addSubview:numSwitchBtn];
        [numSwitchBtn addTarget:self action:@selector(numBtnSwitch:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //空格
        UIButton *spaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        spaceBtn.frame = CGRectMake(81,12 + 3 * (42 + 12), 158, 42);
        [spaceBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_space.png"] forState:UIControlStateNormal];
        [spaceBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_space_press.png"] forState:UIControlStateHighlighted];
        [abcKeyboard addSubview:spaceBtn];
        [spaceBtn addTarget:self action:@selector(spaceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //确定
        UIButton *abcreturnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        abcreturnBtn.frame = CGRectMake(320 - 78 - 1, 12 + 3 * (42 + 12) , 78, 42);
        [abcreturnBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_abcconfirm.png"] forState:UIControlStateNormal];
        [abcreturnBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_abcconfirm_press.png"] forState:UIControlStateHighlighted];
        abcreturnBtn.titleLabel.font =[UIFont boldSystemFontOfSize:17.0f];
        [abcreturnBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateHighlighted];
        [abcreturnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [abcreturnBtn setTitle:@"确定" forState:UIControlStateNormal];
        [abcreturnBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [abcreturnBtn setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        [abcreturnBtn.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [abcKeyboard addSubview:abcreturnBtn];
        [abcreturnBtn addTarget:self action:@selector(returnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (BOOL)abcEnabled
{
	return abcBtn.enabled;
}

- (void)setAbcEnabled:(BOOL)enabled
{
	abcBtn.enabled = enabled;
}

- (void)setIsBackToSystermKey:(BOOL)animated
{
	abcBtn.enabled = animated;
	isBackToSystermKey = animated;
}

- (void)setShowWordKeyboard:(BOOL)animated
{
	if (animated) {
		abcKeyboard.hidden = NO;
	}else{
        abcKeyboard.hidden = YES;
    }
}

#pragma mark -
#pragma mark 添加删除字符

- (void)addOneword:(NSString *)word
{
	NSRange range;
	range.location = targetTextView.text.length;
	range.length = 0;
	if ([targetTextView.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:) ]) {
		if (![targetTextView.delegate textField:targetTextView shouldChangeCharactersInRange:range replacementString:word]) {
			return;
		}
	}
	
	if (targetTextView.text.length >= targetTextView.numberOfCharacter) {
		return;
	}
	targetTextView.text = [NSString stringWithFormat:@"%@%@",targetTextView.text,word];
	
	[self keytone];
}

- (void)deleteOneword
{
	if (targetTextView.text.length == 0) {
		return;
	}
	
	NSRange range;
	range.location = targetTextView.text.length - 1;
	range.length = 1;
	if ([targetTextView.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:) ]) {
		if (![targetTextView.delegate textField:targetTextView shouldChangeCharactersInRange:range replacementString:@""]) {
			return;
		}
	}
	
	targetTextView.text = [targetTextView.text substringToIndex:targetTextView.text.length - 1];
	
	[self keytone];
}

#pragma mark -
#pragma mark 删除键逻辑

- (void)backspaceBtnTouchDown:(id)sender
{
	//复原计数器和标志位
	backspaceDown = YES;
	backspaceCount = 0;
	
	[self deleteOneword];
		
	//延时0.6s后进行连续删除
	[self performSelector:@selector(backspaceTimework) withObject:nil afterDelay:0.6];
}

- (void)backspaceTimework
{
	//按钮抬起后中断连续删除
	if (!backspaceDown) {
		return;
	}
	
	//如果连续删除超过10个字符则全部删除剩余的文字
	if (targetTextView.text.length > 0 && backspaceCount > 10) {
		targetTextView.text = @"";
		//播放声音
		[self keytone];
		return;
	}
	
	[self deleteOneword];
	
	backspaceCount++;
	[self performSelector:@selector(backspaceTimework) withObject:nil afterDelay:0.1];
}

- (void)backspaceBtnTouchUp:(id)sender
{
	backspaceCount = 0;
	backspaceDown = NO;
	//取消计划执行的函数，防止连续点按触发长按效果
	[KeyboardView cancelPreviousPerformRequestsWithTarget:self selector:@selector(backspaceTimework) object:nil];
}

- (void)keytone
{
   // AudioServicesPlayAlertSound(1104);
}

#pragma mark -
#pragma mark 键盘按键事件

//点按确定键
- (void)returnBtnClick:(id)sender
{
	//[targetTextView resignFirstResponder];
	
	if ([targetTextView.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
		[targetTextView.delegate textFieldShouldReturn:targetTextView];
	}
	
	if ([targetTextView.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
		[targetTextView.delegate textFieldDidEndEditing:targetTextView];
	}
	
	//[targetTextView sendActionsForControlEvents:UIControlEventEditingDidEndOnExit];
}

//点按清除键
- (void)clearBtnClick:(id)sender
{
	[targetTextView setText:@""];
}

//点按隐藏键
- (void)hideBtnClick:(id)sender
{
	[targetTextView resignFirstResponder];
}

//切换为字母键盘
- (void)abcBtnSwitch:(id)sender
{
	if (isBackToSystermKey) {
		targetTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		targetTextView.inputView = nil;
		
		[targetTextView resignFirstResponder];
		[targetTextView becomeFirstResponder];
	}
	else {
		abcKeyboard.hidden = NO;
	}
}

//切换为数字键盘
- (void)numBtnSwitch:(id)sender
{
	abcKeyboard.hidden = YES;
}

//点按数字键
- (void)numBtnClick:(id)sender
{
	UIButton *numBtn = (UIButton *)sender;
	[self addOneword:numBtn.titleLabel.text];
	
}

//大写锁定按下
- (void) upperCaseDown:(id)sender
{
	if (isUpperCase) {
		isUpperCase = NO;
		[upperCaseBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_uppercase.png"] forState:UIControlStateNormal];
	}else{
		isUpperCase = YES;
		isUpperCaseDown = YES;
		[upperCaseBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_uppercase_press.png"] forState:UIControlStateNormal];
	}
}

//大写锁定放开
- (void) upperCaseUp:(id)sender
{
	isUpperCaseDown = NO;
}

//空格键
- (void) spaceBtnClick:(id)sender
{
	[self addOneword:@" "];
}

//点按字母键
- (void) abcBtnClick:(id)sender
{
	UIButton *switchBtn = (UIButton *)sender;
	
	if (isUpperCaseDown) {
		[self addOneword:switchBtn.titleLabel.text];
	}else {
		if (isUpperCase) {
			[self addOneword:switchBtn.titleLabel.text];
			isUpperCase = NO;
			[upperCaseBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_uppercase.png"] forState:UIControlStateNormal];
		}else {
			[self addOneword:[switchBtn.titleLabel.text lowercaseString]];
		}
	}
}

//图片处理函数
- (UIImage *)noCacheImageNamed:(NSString *)name
{
	UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
	return image;
}

- (UIImage *)stretchableImageWithPath:(NSString *)path
{
	UIImage *stretchImg = [self noCacheImageNamed:path];
	return [stretchImg stretchableImageWithLeftCapWidth:stretchImg.size.width / 2
										   topCapHeight:stretchImg.size.height / 2];
}

@end
