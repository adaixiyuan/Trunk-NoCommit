//
//  HotelOrderDetailCell.h
//  ElongClient
//
//  Created by Ivan.xu on 14-3-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotelOrderDetailCellDelegate;
@interface HotelOrderDetailCell : UITableViewCell

@property(nonatomic,assign) id<HotelOrderDetailCellDelegate> delegate;

@property(nonatomic,retain) IBOutlet UILabel *keyLabel;
@property(nonatomic,retain) IBOutlet UILabel *valueLabel;
@property(nonatomic,retain) IBOutlet UILabel *key1Label;
@property(nonatomic,retain) IBOutlet UILabel *value1Label;
@property(nonatomic,retain) IBOutlet UIButton *telPhoneBtn; //酒店电话
@property(nonatomic,retain) IBOutlet UIButton *lookInvoiceFlowBtn;      //查看发票处理流程
@property(nonatomic,retain) IBOutlet UIButton *goHotelBtn;

@property(nonatomic,retain) UIImageView *topLineImgView; //顶部分割线
@property(nonatomic,retain) UIImageView *bottomLineImgView; //底部分割线

-(IBAction)clickTelPhoneBtn:(id)sender;     //点击电话按钮
-(IBAction)clickLookInvoiceFlowBtn:(id)sender;      //点击查看发票流程按钮
-(IBAction)clickGoHotelBtn:(id)sender;      //点击带我去酒店
@end


@protocol HotelOrderDetailCellDelegate <NSObject>

@optional
-(void)clickOrderDetailCell_TelPhoneBtn:(id)sender;
-(void)clickOrderDetailCell_LookInvoiceFlowBtn:(id)sender;
-(void)clickOrderDetailCell_GoHotelBtn:(id)sender;  

@end