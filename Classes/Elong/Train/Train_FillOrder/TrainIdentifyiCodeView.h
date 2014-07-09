//
//  TrainIdentifyiCodeView.h
//  ElongClient
//
//  Created by garin on 14-3-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundCornerView.h"

@interface TrainIdentifyiCodeView : UIView

@property (nonatomic, readonly) UILabel *titleLbl;
@property (nonatomic, readonly) UIImageView *dashView;
@property (nonatomic, readonly) UIImageView *topLine;
@property (nonatomic, readonly) UIImageView *buttomLine;
@property (nonatomic, readonly) UITextField *textField;
@property (nonatomic, readonly) UIButton *getIdentifyCodeBtn;
@property (nonatomic, readonly) RoundCornerView *checkCodeImageView;
@property (nonatomic, readonly) UIActivityIndicatorView *checkCodeIndicatorView;

// 设置左侧标题
- (void) setTitle:(NSString *)title;
@end
