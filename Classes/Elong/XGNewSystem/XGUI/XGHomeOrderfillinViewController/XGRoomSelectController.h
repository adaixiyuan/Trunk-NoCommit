//
//  XGRoomSelectController.h
//  ElongClient
//
//  Created by 李程 on 14-6-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGBaseViewController.h"
@class XGRoomSelectController;

@protocol XGRoomSelectControllerDelegate <NSObject>

-(void)roomSelectedResult:(XGRoomSelectController *)sender myindex:(int)myindex;

@end


@interface XGRoomSelectController : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong)UIPickerView *viewPickerView;
@property(nonatomic,assign)id<XGRoomSelectControllerDelegate> delegate;


- (void) cancelBtnClick;
- (void)confirmBtnClick;

- (void)dismissInView;
- (void)showInView;

- (id)initWithFrame:(CGRect)frame mytitle:(NSString *)title_;

@end
