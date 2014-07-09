//
//  AddAddress.h
//  ElongClient
//  新增邮寄地址页面
//  Created by dengfang on 11-1-25.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmbedTextField;
@interface AddAddress : DPNav <UITextFieldDelegate> {
	EmbedTextField *addressTextField;
	EmbedTextField *nameTextField;
	
}

- (IBAction)textFieldDoneEditing:(id)sender;
@end
