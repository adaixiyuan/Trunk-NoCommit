//
//  FlightOrderRuleCell.h
//  ElongClient
//
//  Created by 赵 海波 on 13-2-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightOrderRuleCell : UITableViewCell {
    UILabel *changeLabel;
    UILabel *returnLabel;
    UILabel *changeTitleLabel;
}

@property (nonatomic, readonly) NSInteger cellTotalHeight;

- (void)setReturnRule:(NSString *)rRule changeRule:(NSString *)cRule;      // 设置退改签规则和中转信息

@end
