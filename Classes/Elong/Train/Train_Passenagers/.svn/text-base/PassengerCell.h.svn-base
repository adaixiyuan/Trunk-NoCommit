//
//  PassengerCell.h
//  ElongClient
//  乘客显示（火车票、机票）
//
//  Created by Zhao Haibo on 13-11-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniformCell.h"

@protocol PassengerCellDelegate;

@interface PassengerCell : UITableViewCell
{
@private
    UILabel *nameLabel;       
    UILabel *certLabel;
    
}

@property (nonatomic, assign) UIImageView *selectImgView;       // 底栏分割线
@property (nonatomic, assign) UIImageView *topSplitView;       // 底栏分割线
@property (nonatomic, retain) UIButton *cellEditButton;         // 编辑按钮
@property (nonatomic, assign) id<PassengerCellDelegate> delegate;

- (void)setPassengerName:(NSString *)name;         // 乘客姓名 
- (void)setPassengerCert:(NSString *)certInfo;     // 证件类型／证件号
- (void)setChecked:(BOOL)checked;                  // 设置／取消选中本行

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier cellHeight:(NSInteger)height;

@end

@protocol PassengerCellDelegate <NSObject>

- (void)editPassenger:(PassengerCell *)cell;

@end
