//
//  TaxiListContrl.h
//  ElongClient
//
//  Created by nieyun on 14-1-26.
//  Copyright (c) 2014年 elong. All rights reserved.
//
#define CellHeight  96
#define BottomHeight  44
#import "DPNav.h"
#import "TaxiDetaileModel.h"
#import "TaxiListModel.h"

@interface TaxiListContrl : DPNav<UITableViewDataSource,UITableViewDelegate,HttpUtilDelegate>

{
    UITableView  *taxiTable;
    UIView  *bottomView;
    NSMutableArray *buttonAr;
    NSMutableArray  *storeAllModelAr;
    TaxiListModel  *listModel;
    UILabel  *noListLabel;

    BOOL _fromSuccess;
}

- (id)  initWithTopImagePath:(NSString *)imgPath andTitle:(NSString *)titleStr style:(NavBtnStyle)style  andArray :(NSArray *)  ar;

@property  (nonatomic,assign)  int  redTag;
@property   (nonatomic,retain) NSArray  *listAr;
@property  (nonatomic,assign)     BOOL fromSuccess;

@end
