//
//  AccountInform.h
//  ElongClient
//  编辑个人信息
//  Created by jinmiao on 11-2-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "PostHeader.h"
#import "AccountManager.h"
#import "Utils.h"
#import "MyElongCenter.h"

@class EmbedTextField;
@interface AccountInform : DPNav<UIActionSheetDelegate>  {
	IBOutlet UIScrollView  *textview;
	IBOutlet UILabel *phone;
    EmbedTextField *email;
    EmbedTextField *name;
	IBOutlet UIButton *maleButton;
	IBOutlet UIButton *femaleButton;
	IBOutlet UIImageView* malebmp;
	IBOutlet UIImageView* femalebmp;
	
	IBOutlet UIView *topview;
	IBOutlet UIView *botview;
    IBOutlet UIView *modifyPwdView;
    
	int chooseSex;    //选择的性别
	
	MyElongCenter *myElongCenter;
}

@property (nonatomic ,retain) UIScrollView  *textview;
@property (nonatomic,retain)  EmbedTextField *email,*name;
@property (nonatomic ,retain) UILabel *phone;
@property (nonatomic ,retain)UIButton *maleButton,*femaleButton;
@property (nonatomic ,retain)UIImageView* malebmp,*femalebmp;
@property (nonatomic,retain) MyElongCenter *myElongCenter;

//-(IBAction)uptextview:(id)sender;
//-(IBAction)textdown:(id)sender;
-(IBAction)maleButtonDown:(id)sender; //男的按钮
-(IBAction)femaleButtonDown:(id)sender; //女的按钮
-(IBAction)callPhone;
-(IBAction)goModifyPwdPage:(id)sender;

@end
