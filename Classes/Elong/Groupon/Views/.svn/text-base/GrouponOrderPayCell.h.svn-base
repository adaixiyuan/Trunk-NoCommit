//
//  GrouponOrderPayCell.h
//  ElongClient
//
//  Created by Dawn on 13-7-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    GrouponAlipay,
    GrouponCreditCard
}GrouponPayType;

@protocol GrouponOrderPayCellDelegate;
@interface GrouponOrderPayCell : UITableViewCell{
@private
    UIImageView *bgImageView;               // 背景色
    UIButton *alipayRadio;                  // 支付宝单选框
    UIButton *creditCardRadio;              // 信用卡单选框
    UISwitch *cashAccountSwitch;            // 现金账户开关
    UIView *alipayView;                     // 支付宝View
    UIView *creditCardView;                 // 信用卡View
    UIView *cashAccountView;                // 现金账户View
    id delegate;
}
@property (nonatomic,assign) BOOL alipayHidden;         // 支付宝是否显示
@property (nonatomic,assign) BOOL alipayChecked;        // 支付宝是否选中
@property (nonatomic,assign) BOOL creditCardChecked;    // 信用卡是否选中
@property (nonatomic,assign) BOOL cashaccountHidden;    // 现金账户是否显示
@property (nonatomic,assign) BOOL cashaccountChecked;   // 现金账户是否选中
@property (nonatomic,assign) id<GrouponOrderPayCellDelegate> delegate;
@end

@protocol GrouponOrderPayCellDelegate <NSObject>

@optional
- (void) orderPayCell:(GrouponOrderPayCell *)cell selectPayType:(GrouponPayType)payType;
- (void) orderPayCell:(GrouponOrderPayCell *)cell cashAccount:(BOOL)cash;

@end