//
//  FlightTicketGetTypeChooseCell.h
//  ElongClient
//  机票流程行程单获取方式选择
//
//  Created by 赵 海波 on 14-1-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FillFlightOrder.h"

@interface FlightTicketGetTypeChooseCell : UITableViewCell
{
    
    
    
    UIView *coverView;      // 做loading动画使的
}

@property (nonatomic, assign) FillFlightOrder *root;

@property (nonatomic, retain) IBOutlet UIImageView *selfGetIcon;      // 机场自取icon
@property (nonatomic, retain) IBOutlet UIButton *selfGetButton;
@property (nonatomic, retain) IBOutlet UILabel *selfGetLabel;
@property (nonatomic, retain) IBOutlet UIImageView *postIcon;         // 邮寄行程单icon
@property (nonatomic, retain) IBOutlet UILabel *postLabel;
@property (nonatomic, retain) IBOutlet UILabel *invoiceTipLabel;
@property (nonatomic, retain) IBOutlet UITextField *invoiceContent;

+ (id)cellFromNib;

- (IBAction)clickPostBtn;       // 点击邮寄行程单
- (IBAction)clickSelfGetBtn;    // 点击机场自取

- (void)startLoading;
- (void)endLoading;

@end
