//
//  AddAndEditAddress.h
//  ElongClient
//
//  Created by WangHaibin on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"

@class EmbedTextField;
@interface AddAndEditAddress : DPNav <UITextFieldDelegate> {
	BOOL isAddorEdit;
    EmbedTextField *inputName;
    EmbedTextField *inputAddress;
}
@property (nonatomic ,retain) EmbedTextField *inputName;
@property (nonatomic ,retain) EmbedTextField *inputAddress;

//-(IBAction)backgroudPressed;
-(IBAction)backgroudPressed1;
-(IBAction)textFieldDoneEditing:(id)sender;

-(void)isAddorEdit:(BOOL)boool;

@end
