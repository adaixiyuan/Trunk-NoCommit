//
//  CommonSelectView.h
//  ElongClient
//  弹起选择数字的控件
//
//  Created by 赵 海波 on 13-11-13.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommonSelectViewDelegate;
@interface CommonSelectView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>{
@private
    UIPickerView *viewPickerView;
}

@property (nonatomic, assign) id<CommonSelectViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedRow;         // 当前选择行,default = 0
@property (nonatomic, assign) NSInteger originNumer;         // 起始行数字，default = 0
@property (nonatomic, assign) NSInteger maxRows;             // 最多显示行数,default = 10
@property (nonatomic, assign) BOOL isShowing;                // 是否正在展示,default = NO
@property (nonatomic, copy) NSString *measureWord;           // 数字后跟的量词，如一（张、间..）

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (void)showInView;             // 显示自己
- (void)dismissInView;          // 取消显示

@end


@protocol CommonSelectViewDelegate<NSObject>

- (void)selectView:(CommonSelectView *)roomSelectView didSelectedNumber:(NSInteger)number;

@end
