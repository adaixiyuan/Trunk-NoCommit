//
//  WeixinLogin.h
//  ElongClient
//
//  Created by Dawn on 14-1-2.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DPNav.h"
#import "EmbedTextField.h"

typedef enum {
    LoginAndBindingWeixin,
    RegisterAndBindingWeixin
}WeixinBindingType;

@protocol WeixinLoginDelegate;
@interface WeixinLogin : DPNav<UITextFieldDelegate>{
@private
    EmbedTextField *m_phoneNoField;
    EmbedTextField *m_passwordField;
    UIButton *newUserBtn;
    UIButton *oldUserBtn;
    NSInteger net_type;
}
@property (nonatomic,assign) id<WeixinLoginDelegate> delegate;
- (id) initWithUserInfo:(NSDictionary *)userInfo;
@end


@protocol  WeixinLoginDelegate<NSObject>
@optional
- (void) weixinLogin:(WeixinLogin *)login didLoginWithLoginNo:(NSString *)loginNo password:(NSString *)password token:(NSDictionary *)token;

@end