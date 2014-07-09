//
//  TaxiFillCell.h
//  ElongClient
//
//  Created by nieyun on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

@protocol AddressChooseDelegate <NSObject>

- (void)addressChooseAction:(UIButton  *)button;

@end
#import <UIKit/UIKit.h>

@interface TaxiFillCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, retain) UILabel *titleLbl;
@property (nonatomic, retain) UIImageView *dashView;
@property (nonatomic, retain) UIImageView *topLine;
@property (nonatomic, retain) CustomTextField *textField;
@property (nonatomic, readonly) UIButton *addressBoomBtn;
@property (nonatomic,assign) id <AddressChooseDelegate> delegate;

// 设置左侧标题
- (void) setTitle:(NSString *)title;
@end
