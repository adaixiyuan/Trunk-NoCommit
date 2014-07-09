//
//  FlightOrderSuccess.h
//  ElongClient
//  预订成功页面
//  Created by dengfang on 11-1-26.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "ElongURL.h"
#import "FXLabel.h"
#import "FlightConfig.h"
#import "PositioningManager.h"
#import "HomeAdNavi.h"

@interface FlightOrderSuccess : DPNav <UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, PositioningManagerDelegate,UIAlertViewDelegate> {
	IBOutlet UILabel *idLabel;
    IBOutlet UILabel *idTitleLabel;
    IBOutlet UILabel *moneyTitleLabel;
	IBOutlet UIButton *okButton;
	IBOutlet UIView *bgView;
    
    double totalPrice;
    NSInteger couponCount;            // 消费券使用额
    NSString *payType;
    
	IBOutlet UILabel *payNoteLable;
    BOOL isCouldPay;
	NSDate *orderDate;
	NSString *netType;
	
	UIButton *shareBtn;
	
	//
	FXLabel *successTipLabel;
    UILabel *priceLabel;
	IBOutlet UILabel *noteLabel;
	
	UIButton *payBtn;
	UIButton *confirmButton;
	UIImageView *upLine;
	UIImageView *bottomLine;
	UIButton *goMyOrderBtn;
    UIImageView *envelopImg;
    UIButton *captureBtn;
    UIImage *imagefromparentview;
    UIImageView *m_imgview;
    BOOL saveordertoalbum;
    UIView *selectedView;       //checkbox
	NSString *payFee;
    BOOL jumpToSafari;
}
@property (nonatomic, retain) UIImage *imagefromparentview;
- (IBAction)okButtonPressed;

-(void)payByalipay;
-(void) setCouldPay:(BOOL) couldPay;
-(void) paySuccess;
+(FlightOrderSuccess *) currentInstance;
+(void)setInstance:(FlightOrderSuccess *)inst;
@property (nonatomic,retain) IBOutlet UILabel *payNoteLable;
@property (nonatomic,retain) NSDate *orderDate;
@property (nonatomic,retain) IBOutlet UILabel *noteLabel;
@property (nonatomic,assign) BOOL havePNR;
@property (nonatomic, assign) BOOL isAttentioned;                             // 是否已添加关注
@property (nonatomic, retain) UITableView *flightOrderSucTableView;
@property (nonatomic, retain) IBOutlet UILabel *payStatelabel;

// 跳转链接
@property (nonatomic, retain) HomeAdNavi *homeAdNavi;
@property (nonatomic, assign) BOOL isPushHotel;

-(void) shareInfo;
- (void)moveview;
- (id)initWithPayType:(FlightOrderPayType)type;

- (UIImage *) screenshotOnCurrentView;
- (NSString *) smsContent;
- (NSString *) mailContent;
- (NSString *) weiboContent;
@end
