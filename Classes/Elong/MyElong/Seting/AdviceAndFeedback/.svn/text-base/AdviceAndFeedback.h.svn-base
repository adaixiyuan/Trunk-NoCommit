//
//  AdviceAndFeedback.h
//  ElongClient
//
//  Created by jinmiao on 11-2-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"

@class EmbedTextField;
@interface AdviceAndFeedback:DPNav<UITextFieldDelegate ,UITextViewDelegate,UIScrollViewDelegate, UIAlertViewDelegate> {
	
    EmbedTextField *numberField;
    EmbedTextField *emailField;
    UIScrollView *upview;
	CGRect defaultFrame;
    UITextView *textview;

	NSDate *preSubDate;
	
}

@property(nonatomic,retain)UIView *upview;
@property(nonatomic ,retain)UITextView *textview;
@property (nonatomic,retain) IBOutlet UIImageView *textviewBgImageView;
//-(IBAction)textExit:(id)sender;

-(void)clickBack;
-(IBAction)clickConfirm;
@end
