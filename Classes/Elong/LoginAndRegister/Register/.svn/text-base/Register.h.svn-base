//
//  Register.h
//  ElongClient
//
//  Created by bin xing on 11-1-14.
//  Copyright 2011 DP. All rights reserved.
//
#define LOGINSTATE 0
#define REGISTERSTATE 1
#define FILLHOTELSTATE 2
#define FAVORSTATE 3
#define ADDFAVORSTATE 4
#define ADDGROUPONFAVOSTATE 5
#define FAVORGROUPONSTATE 6

#import <UIKit/UIKit.h>

@class EmbedTextField;
@protocol  RegisterDelegate;
@interface Register : DPNav<UITextFieldDelegate>  {
	EmbedTextField *m_phoneNoField;
	EmbedTextField *m_passwordField;
    UIButton *showPwdBtn;
    unsigned int keyboardHeight;
	BOOL keyboardIsShowing;
	int m_type;
}
@property (nonatomic,assign) id<RegisterDelegate> delegate;
-(void)clickRegisterBtn;
-(void)showPasswordNumber;
@end


@protocol  RegisterDelegate<NSObject>
@optional
- (void) reg:(Register *)reg didRegistedAndLogin:(NSDictionary *)dict;

@end