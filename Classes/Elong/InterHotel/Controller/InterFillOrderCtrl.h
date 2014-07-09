//
//  InterFillOrderCtrl.h
//  ElongClient
//
//  Created by Ivan.xu on 13-6-21.
//  Copyright (c) 2013年 elong. All rights reserved.
//
//  修改客史没有信用卡时，先请求银行列表，再进入选择信用卡页面 by 赵海波 on 14-3-19

#import <Foundation/Foundation.h>
#import "InterOrderRoomerCell.h"
#import "SepecialNeedOptionView.h"
#import "FilterView.h"
#import "InterHotelOrderFillMessageView.h"

@interface InterFillOrderCtrl : DPNav<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,InterOrderRoomerDelegate,SepecialNeedOptionDelegate,FilterDelegate>{
    int netType;            // 网络请求类型
    FilterView *bedTypeFilterView;
    SepecialNeedOptionView *sepecialNeedView;
    InterHotelOrderFillMessageView *msg;
}

@property(nonatomic,assign) BOOL isSkipLogin;

+(NSMutableArray *)travellers;       //入住人集合
+(NSString *)sepecialNeeds_cn;      //特殊需求中文信息
+(void)setSepecialNeeds_cn:(NSString *)tmpSepecialNeeds;    
@end
