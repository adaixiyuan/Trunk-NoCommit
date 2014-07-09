//
//  SelectedAddressView.h
//  ElongClient
//	选择邮寄地址页面
//
//  Created by haibo on 11-11-25.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectedAddressView : UIView <UITableViewDataSource, UITableViewDelegate> {
@private
	int addressViewHeight;			// 地址栏高度
	int currentRow;					// 选中栏
	int lastRow;					// 上一次选中的栏
	
	UILabel *titleLabel;
	
	UITableView *addressTable;
	
	UIImageView *separator;
	UIImageView *separator2;
	UIImageView *backView;
	
	UIButton *addButton;
	
	UIButton *commitButton;
    
    UITextField *textField;
}

@property (nonatomic, retain) NSMutableArray *addressArray;		// 地址数组

- (id)initWithFrame:(CGRect)frame AddressArray:(NSArray *)addresses;	// 用地址数组进行初始化

- (void)setNextButtonTarget:(id)target action:(SEL)selector;		// 设置“下一步”按钮的动作
- (NSString *)getSelectedAddress;									// 获取当前选中地址
- (void) setTextField:(UITextField *)textField;
@end
