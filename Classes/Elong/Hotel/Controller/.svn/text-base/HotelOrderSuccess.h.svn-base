//
//  HotelOrderSuccess.h
//  ElongClient
//
//  Created by bin xing on 11-1-5.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelDefine.h"
#import "HotelConfig.h"
#import <MessageUI/MessageUI.h>
#import "AlipayViewController.h"

@interface HotelOrderSuccess : DPNav <UIActionSheetDelegate, PKAddPassesViewControllerDelegate,UITableViewDataSource,UITableViewDelegate> {

    UIImage *imagefromparentview;
	
	UIScrollView *scrollview;
	UIButton *shareBtn;
	UIButton *captureBtn;
	UIButton *goMyOrderBtn;
	UIButton *goHotelBtn;
	UIImageView *line_1;
	UIImageView *line_2;
	UIImageView *line_3;
    UIImageView *envelopImg;
    UIImageView *m_imgview;
	
	UIImageView *line_4;
	UIImageView *line_5;
	UIView *selectedView;
    UIView *coverView;                  // 显示正在提交状态的覆盖层
    PKPass *pass;
    HttpUtil *passUtil;
    BOOL jumpToSafari;
    HttpUtil *cashDespUtil;
    UITableView *infoList;
    HttpUtil *promotionInfoUtil;
}

@property (nonatomic, assign) NSUInteger prepayType;

@property (nonatomic, retain) UIImage *imagefromparentview;

@property (nonatomic, retain) NSMutableArray *localOrderArray;

- (id) initWithPayType:(VouchSetType)type order:(NSString *)order;
- (void)confirm;
-(void) shareInfo;
-(UIImage *)captureCurrentView;
- (void)moveview;
-(UIImage *) screenshotOnCurrentView;
- (NSString *) weiboContent;
-(NSString *) mailContent;
-(NSString *) smsContent;
- (void)alipayApp;
- (void)alipay;
- (void)weixinpay;

@end
