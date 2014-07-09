//
//  SelectRoomerEditCell.h
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-12.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectRoomerEditCell : UITableViewCell<UITextFieldDelegate>{
    UIButton *addBtn;
    UITextField *nameTextField;
    UIButton *saveBtn;
    UIImageView *bgImageView;
}
@property (nonatomic,readonly) UIButton *saveBtn;
@property (nonatomic,readonly) UITextField *nameTextField;
- (void) endEdit;
- (void) beginEdit;
- (void) keyboardBack;
- (void) addBtnClick:(id)sender;
@end
