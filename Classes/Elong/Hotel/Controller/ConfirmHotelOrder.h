//
//  ConfirmHotelOrder.h
//  ElongClient
//
//  Created by bin xing on 11-1-5.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelDefine.h"
#import "HotelConfig.h"
#import <MessageUI/MessageUI.h>

@class JHotelOrder;
@interface ConfirmHotelOrder : DPNav<UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate> {
@private NSString *currencyStr;				// 币种
}

@property (nonatomic, assign) BOOL isZhifubaoPay;
@property (nonatomic, assign) VouchSetType payType;         // 指定支付类型
@property (nonatomic,assign) BOOL isC2CSuccess;  //是否是c2c 成功页
-(UIImage *)captureView;

-(void)nextState;

@end
