//
//  RateCell.h
//  ElongClient
//
//  Created by Jian.zhao on 13-12-25.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateModel.h"

@protocol CellInputDelegate <NSObject>

@optional

-(void)getUserPrintNumsWithString:(NSString *)string andModel:(RateModel *)aModel;
-(void)shouldBeginTheInputInModel:(RateModel *)model;
-(void)adjustTheTableFrame;

@end

@class RateModel;
@class CustomTextField;
@class CTField;
@interface RateCell : UITableViewCell<UITextFieldDelegate>{

    BOOL main;
    UIView *bottomView;
    id<CellInputDelegate>_delegate;
}
@property (nonatomic,retain) RateModel*cellModel;
@property (nonatomic,assign)    id<CellInputDelegate>delegate;

//首页
@property (nonatomic,retain) CTField *result; 
@property (nonatomic,retain) UIImageView *icon_Big;
@property (nonatomic,retain) UILabel *SimpleTroduce;//简称＋货币名称

//列表
@property(nonatomic,retain) UIImageView *icon_Small;
@property (nonatomic,retain) UILabel *description;//描述 简称＋全称

-(void)bindingTheModel:(RateModel *)model;
-(void)displayTheAddTip;
@end
