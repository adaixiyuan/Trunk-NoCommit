//
//  KeyboardView.h
//  Keybord
//
//  Created by Wang Shuguang on 12-8-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@class CustomTextField;
@interface KeyboardView : UIView {
@private
	CustomTextField *targetTextView;
	BOOL backspaceDown;
	BOOL backspaceCount;

	UIView *abcKeyboard;
	BOOL isUpperCase;
	BOOL isUpperCaseDown;
	UIButton *upperCaseBtn;
	UIButton *abcBtn;
}

@property (nonatomic, assign) CustomTextField *targetTextView;
@property (nonatomic) BOOL abcEnabled;
@property (nonatomic) BOOL isBackToSystermKey;
@property (nonatomic) BOOL showWordKeyboard;	

@end
