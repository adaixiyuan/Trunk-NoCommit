//
//  CustomTextField.m
//  Keybord
//
//  Created by Wang Shuguang on 12-8-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTextField.h"
#import "KeyboardView.h"

static KeyboardView *keyboard;

@interface CustomTextField()

- (UIImage *)stretchableImageWithPath:(NSString *)path;
- (UIImage *)noCacheImageNamed:(NSString *)name;

@end

@implementation CustomTextField
@synthesize abcEnabled;
@synthesize abcToSystemKeyboard;
@synthesize numberOfCharacter;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	if (IOSVersion_3_2) {
		self.inputView = nil;
	}
    
    [super dealloc];
}


- (void)initate {
	if (IOSVersion_3_2) {
        if (!keyboard) {
            keyboard = [[KeyboardView alloc] initWithFrame:CGRectZero];
        }
		
		keyboard.targetTextView = self;
		
		self.inputView = keyboard;
	}else {
		self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	}
	
	self.clipsToBounds = NO;
	numberOfCharacter = -1;
	self.borderStyle = UITextBorderStyleRoundedRect;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
}

- (void)textFieldBeginEditing:(NSNotification *)noti
{
    if (self == [noti object])
    {
        // 只有当被点击的textField是自身时才执行属性恢复
        keyboard.isBackToSystermKey = abcToSystemKeyboard;
        keyboard.abcEnabled = abcEnabled;
        
        switch (_fieldKeyboardType) {
            case CustomTextFieldKeyboardTypeDefault:
                keyboard.showWordKeyboard = YES;
                break;
            case CustomTextFieldKeyboardTypeNumber:
                keyboard.showWordKeyboard = NO;
            default:
                break;
        }
    }
}


- (void) resetTargetKeyboard{
    keyboard.targetTextView = self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		[self initate];
    }
	
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self initate];
	}
	
	return self;
}

- (void)showWordKeyboard {
    _fieldKeyboardType = CustomTextFieldKeyboardTypeDefault;
	keyboard.showWordKeyboard = YES;
}

- (void)showNumKeyboard{
    _fieldKeyboardType = CustomTextFieldKeyboardTypeNumber;
    keyboard.showWordKeyboard = NO;
}

- (BOOL) abcEnabled{
	return keyboard.abcEnabled;
}

- (void)changeKeyboardStateToSysterm:(BOOL)animated {
	if (IOSVersion_3_2) {
		if (animated) {
			self.inputView = nil;
			self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		}
		else {
			self.inputView = keyboard;
		}
	}
}


- (void)setKeyboardType:(CustomTextFieldKeyboardType)keyboardType
{
    _fieldKeyboardType = keyboardType;
}

- (void) setAbcEnabled:(BOOL) enabled{
    abcEnabled = enabled;
	keyboard.abcEnabled = enabled;
}

- (void)setAbcToSystemKeyboard:(BOOL)animated {
    abcToSystemKeyboard = animated;
	keyboard.isBackToSystermKey = YES;
}

- (UIImage *)noCacheImageNamed:(NSString *)name {
	UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
	
	return image;
}

- (UIImage *)stretchableImageWithPath:(NSString *)path {
	UIImage *stretchImg = [self noCacheImageNamed:path];
	return [stretchImg stretchableImageWithLeftCapWidth:stretchImg.size.width / 2
										   topCapHeight:stretchImg.size.height / 2];
}

@end
