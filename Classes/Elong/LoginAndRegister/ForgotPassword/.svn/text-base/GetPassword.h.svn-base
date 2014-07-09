//
//  GetPassword.h
//  ElongClient
//
//  Created by bin xing on 11-1-14.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegisterDefine.h"
#import "RoundCornerView.h"

@class EmbedTextField;
@interface GetPassword : DPNav <UITextFieldDelegate>{
    RoundCornerView *checkCodeImageView;
	EmbedTextField *phoneField;
	EmbedTextField *checkCodeField;
	UIButton	 *freshBtn;
	int m_netState;
    UIActivityIndicatorView *checkCodeIndicatorView;
}

-(void)getCheckCode;
-(void)clickGetPassword;
-(IBAction)againGetCheckCode;

@end
