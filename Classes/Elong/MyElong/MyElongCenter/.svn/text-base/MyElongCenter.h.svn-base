//
//  MyElongCenter.h
//  ElongClient
//  我的艺龙首页,包含个人信息，订单管理，我的艺龙等
//  Created by elong lide on 11-12-26.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "BaseBottomBar.h"
#import "MessageBoxController.h"
#import "Notification.h"
#import "ElongClientSetting.h"
#import "AdviceAndFeedback.h"

@interface MyElongCenter : DPNav <UITableViewDataSource, UITableViewDelegate,BaseBottomBarDelegate> {
    IBOutlet UITableView *table;
    IBOutlet UIButton*  go2DragonVIPDetai_btn;  //用户名字
    IBOutlet UIButton*  couponBtn;
    IBOutlet UIButton*  cashBtn;
	IBOutlet UILabel*   scorelabel; // 积分
    IBOutlet UILabel *couponLabel; // 消费券
    IBOutlet UILabel *couponMarkLabel;  //消费券价格符号
    IBOutlet UILabel *cashLabel;  // 现金账户
    IBOutlet UILabel *cashMarkLabel;        //价格符号
    IBOutlet UIView *headerView;
    
    BOOL isLongCui;
    BOOL existCashPayPassword;      // 是否存在支付密码，default = NO
	
	int m_netstate;  //网络请求状态
	IBOutlet UILabel*   DragonVIPLabel;  //用户名字
    
    HttpUtil *scoreUtil;                // 请求积分
    HttpUtil *couponUtil;               // 请求消费券数额
	HttpUtil *cashUtil;                 // 请求现金账户余额
    HttpUtil *tokenRrequestUtil;        // 请求token
    HttpUtil *tokenRefreshUtil;         // 刷新token
    HttpUtil *unbindUserPushUtil;       // 解绑用户推送信息
    
    //New
    IBOutlet UIImageView *_nameArrow;
    IBOutlet UIImageView *_goVIPDetailArrow;
    IBOutlet UILabel *_goVIPDetailLabel;
    
    UIImageView *_badgeBgImgView;
    UILabel *_badgeNumLabel;
    
    MessageBoxController *_messageBoxCtrl;
    Notification *_notification;
    AdviceAndFeedback *_adviceAndFeedBack;
    
    NSMutableArray *_feedBackHotelOrderList;     //可反馈酒店列表
}

@property (nonatomic,assign)BOOL longcui;
@property (nonatomic ,retain)IBOutlet UIButton*  edit_btn;  //编辑个人信息
@property (nonatomic ,retain)IBOutlet UILabel*   userName;  //用户名字

-(IBAction)go2DragonVIPDetail:(UIButton*)sender;
-(IBAction)editinfo_click:(UIButton*)sender; //编辑个人信息
- (IBAction)couponBtnClick:(id)sender;  // 进入消费权页面
- (IBAction)cashBtnClick:(id)sender; // 进入现金账户页面
-(void)setPersonName:(NSString *)name;      //设置名字

+ (NSMutableArray *)allUserInfo;
+ (void)customerIndex:(int)index;
+ (int)getcustomerIndex;
+ (NSMutableArray *)allAddressInfo;
+ (NSMutableArray *)allCardsInfo;
+ (NSMutableArray *)allCouponInfo;
+ (NSMutableArray *)allActiveCouponInfo;
+ (NSMutableArray *)allHotelFInfo;

@end
