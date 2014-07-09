//
//  HotelErrorCCViewController.h
//  ElongClient
//  酒店纠错页面
//  Created by garin on 14-1-9.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DPNav.h"
#import "HotelOrderCell.h"
#import "HotelDetailController.h"
#import "HttpUtil.h"
#import "HotelDetailController.h"
#import "DefineHotelResp.h"

@interface HotelErrorCCViewController : DPNav<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *contentView;
    HttpUtil *httpUtil;
    UITextField *curtextField;
}

@property (nonatomic,copy) NSString *hotelName;
@property (nonatomic,copy) NSString *hotelAddress;
@property (nonatomic,copy) NSString *hotelPhone;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userPhone;

@property (nonatomic,copy) NSString *cInitHotelName;
@property (nonatomic,copy) NSString *cInitHotelAddress;
@property (nonatomic,copy) NSString *cInitHotelPhone;
@property (nonatomic,copy) NSString *lastPostParms;

@property (nonatomic,retain) NSDictionary *hotelDic;

-(void) setUI;
@end
