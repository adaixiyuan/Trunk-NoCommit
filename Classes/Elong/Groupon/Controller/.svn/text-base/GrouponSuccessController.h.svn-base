//
//  GrouponSuccessController.h
//  ElongClient
//	团购成功提示页面
//
//  Created by haibo on 11-11-28.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "FXLabel.h"
#import "GrouponConfig.h"
#import "GrouponItemViewController.h"
#import "GrouponAppointViewController.h"

@interface GrouponSuccessController : DPNav <UITableViewDataSource, UITableViewDelegate, PKAddPassesViewControllerDelegate> {
@private
	NSInteger textHeight;			// 订单信息高度
	NSInteger introHeight;			// 团购券说明高度
    BOOL saveToPassbook;
    BOOL isCouldPay;
	
	NSArray *titleArray;			// 左边的标题
	NSMutableArray *valueArray;     // 右边的值
	NSMutableArray  *labelArray;	// 存储显示的控件
	UITableView *infoTable;
	
	UIButton *confirmButton;
	UIButton *goMyOrderBtn;
    UIButton *callBtn;
	UIButton *shareBtn;
    PKPass *pass;
	int orderNo;	//分享用
	UIImage *imagefromparent;
    HttpUtil *passUtil;

	//支付宝
	UILabel *successTipLabel;
	UIButton *payBtn;
	UILabel *payNoteLabel;
	NSString *payType;
    
    //底部栏
    UIView *buttonmView;
    BOOL jumpToSafari;
}
@property (nonatomic,retain) UIImage *imagefromparent;
@property (nonatomic,assign) GrouponOrderPayType grouponPayType;

// 用订单号进行初始化
- (id)initWithOrderID:(NSInteger)orderID;
// 使用订单号喝支付方式初始化
- (id)initWithOrderID:(NSInteger)orderID payType:(GrouponOrderPayType)type;

-(void) shareInfo; 
- (NSString *) weiboContent;
- (NSString *) mailContent;
- (NSString *) smsContent;
- (UIImage *) screenshotOnCurrentView;

-(void)setCouldPay:(BOOL)couldPay;
-(void)payByalipay;
-(void) paySuccess;
+(GrouponSuccessController *) currentInstance;
+(void)setInstance:(GrouponSuccessController *)inst;

@end
