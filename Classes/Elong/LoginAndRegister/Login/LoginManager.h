//
//  LoginManager.h
//  ElongClient
//
//  Created by bin xing on 11-1-14.
//  Copyright 2011 DP. All rights reserved.
//
typedef enum {
	_LoginSucess_ = 0,
	_FillFlightOrder_,
	_FillHotelOrder_,
    _FillInterHotelOrder_,
	_MyElong_,
	_OrderManager_,
	_HotelAddFavorite_,
    _GrouponAddFavorite_,
	_HotelGetFavorite,
    _GrouponGetFavorite,
	GrouponOrder,
    FillHotelOrder_login,       // 从非会员订单填写页面上面的登录过来的按钮
    TrainOrder,                 // 火车票预定
    SynchronizedPackingData,    // 旅行清单同步
    RentTaxiFill,
    HOTEL_UPLOAD_IMAGE,         // 酒店上传图片
    GOODS_FAVORITE_ ,           // 商品特惠 by lc
    _ScenicOrderFill_Login,     // 门票登陆 jian.zhao
    _GeneralLogin,                  // 通用登录，以后慢慢转为这一种登录方式
    _GeneralLoginWithOutNonmember   // 无非会员通用登录
} LoginNextState;

#import <UIKit/UIKit.h>
#import "MessageBoxController.h"
#import "Notification.h"
#import "BaseBottomBar.h"
#import "AdviceAndFeedback.h"
#import "LoginAndRegisterDefine.h"
#import "ElongClientSetting.h"
#import "LoginDelegate.h"
#import "LoginManagerDelegate.h"

@class Login;
@class Register;
@class GetPassword;

@interface LoginManager : DPNav<BaseBottomBarDelegate,LoginDelegate> {
	NSMutableArray *viewControllersArray;
	NSMutableArray *tabItemsArray;
	Login *tabViewController1;
	Register *tabViewController2 ;
	GetPassword *tabViewController3;
	
	Login *loginVC;
    
    
    UIImageView *_badgeBgImgView;
    UILabel *_badgeNumLabel;
    
    AdviceAndFeedback *_adviceAndFeedBack;
    MessageBoxController *_messageBoxCtrl;
    Notification *_notification;
}
@property (nonatomic,assign) id<LoginManagerDelegate> delegate;
-(id)init:(NSString *)name style:(NavBtnStyle)style state:(LoginNextState)state;
+(LoginNextState)nextState;
@end



