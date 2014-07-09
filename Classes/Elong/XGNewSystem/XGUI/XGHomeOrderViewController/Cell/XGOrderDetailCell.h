//
//  XGOrderDetailCell.h
//  ElongClient
//
//  Created by 李程 on 14-5-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallActionBlock)(void);

@interface XGOrderDetailCell : UITableViewCell
@property(nonatomic,strong) IBOutlet UILabel *keyLabel;
@property(nonatomic,strong) IBOutlet UILabel *key1Label;
@property(nonatomic,strong) IBOutlet UILabel *valueLabel;
@property(nonatomic,strong) IBOutlet UILabel *value1Label;

@property(nonatomic,strong) IBOutlet UIButton *telPhoneBtn;  //电话联系方式

@property(nonatomic,strong) UIImageView *topLineImgView; //顶部分割线
@property(nonatomic,strong) UIImageView *bottomLineImgView; //底部分割线

@property(nonatomic,strong) CallActionBlock callTeleBlock;

-(IBAction)telePhoneAction:(id)sender;

@end
