//
//  Login.h
//  ElongClient
//
//  Created by bin xing on 11-1-14.
//  Copyright 2011 DP. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HotelDefine.h"
#import "LoginAndRegisterDefine.h"
#import "MyFavorite.h"
#import "HotelSearch.h"
#import "FillFlightOrder.h"
#import "WeixinLogin.h"
#import "WeixinOuthor.h"
#import "Register.h"
#import "LoginDelegate.h"

@class EmbedTextField;
@interface Login : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate,WeixinOuthorDelegate,RegisterDelegate> {
    EmbedTextField *m_phoneNoField;
	EmbedTextField *m_passwordField;
	
	int m_type;
    
    HttpUtil *pushUtil;
    HttpUtil *sevenDaysUtil;
    HttpUtil *tokenUtil;            // 请求token
    HttpUtil *checkUtil;            // 检测黑名单
    HttpUtil *bindUserPushUtil;     // 绑定用户推送信息
    
    
    //New UI Add
    IBOutlet UIButton *registerBtn;
	IBOutlet UIButton *forgetPwdBtn;
    IBOutlet UILabel *privilegeLabel;
    IBOutlet UIView *_nonMemberView;
    IBOutlet UIButton *_nonMemberBtn;
    IBOutlet UIButton *weixinBtn;
    IBOutlet UIButton *sunWebSitBtn;
    IBOutlet UIScrollView *scrollView;
    
    //checkCodeView
    UIView *_checkCodeView;
    EmbedTextField *_checkCodeField;
    RoundCornerView *checkCodeImageView;
    UIActivityIndicatorView *checkCodeIndicatorView;
    UIButton *loginBtn;
    WeixinOuthor *weixinOuthor;
}

@property (nonatomic, retain) NSMutableArray *localOrderArray;
@property (nonatomic,copy) NSString *openid;
@property (nonatomic,retain) NSDictionary *weixinInfo;
@property (nonatomic,assign) id<LoginDelegate> delegate;
- (void)clickLoginBtn;
- (IBAction)clickRegisterBtn;
- (IBAction)clickforgetPwdBtn;
- (void) setNonmemberHidden:(BOOL)hidden;

- (void) showVerifyCheckCode:(BOOL)isShow withUrl:(NSString *)checkCodeUrl;

@end


