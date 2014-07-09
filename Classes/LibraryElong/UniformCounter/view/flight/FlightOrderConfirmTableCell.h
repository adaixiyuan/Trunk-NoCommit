//
//  FlightOrderConfirmTableCell.h
//  ElongClient
//  机票收银台页上部航班显示
//
//  Created by 赵 海波 on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightOrderConfirmTableCell : UITableViewCell

@property (nonatomic) BOOL isReturnFlight;      // 标记是否是返程航班，default＝NO
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;        // 显示航空公司icon或去返程标识
@property (nonatomic, strong) IBOutlet UILabel *airlineNameLabel;     // 显示航空公司名字
@property (nonatomic, strong) IBOutlet UILabel *spaceNameLabel;       // 显示舱位名字
@property (nonatomic, strong) IBOutlet UILabel *departTimeLabel;     // 显示起飞时间
@property (nonatomic, strong) IBOutlet UILabel *departAirPortLabel;     // 显示起飞机场
@property (nonatomic, strong) IBOutlet UILabel *arriveTimeLabel;     // 显示到达时间
@property (nonatomic, strong) IBOutlet UILabel *arriveAirPortLabel;     // 显示到达机场

+ (id)cellFromNib;                  // 从nib上返回一个cell
- (IBAction)clickRuleButton;        // 点击退改签按钮

@end
