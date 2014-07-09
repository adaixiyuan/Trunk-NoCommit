//
//  HotelOrderLinkmanCell.h
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-11.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelOrderLinkmanCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLbl;
@property (nonatomic, retain) UIImageView *dashView;
@property (nonatomic, retain) UIImageView *topLine;
@property (nonatomic, readonly) CustomTextField *textField;
@property (nonatomic, readonly) UIButton *addressBoomBtn;

// 设置左侧标题
- (void) setTitle:(NSString *)title;
@end
