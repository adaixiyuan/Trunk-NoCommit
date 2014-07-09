//
//  TaxiFillCtrl.h
//  ElongClient
//
//  Created by nieyun on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//


typedef enum
{
    TAXI_USERTYPE,
    TAXI_EVALUTETYPE,
    TAXI_FILLTYPE,
    TAXI_INVOICETYPE,
    TAXI_AIRTYPE
}
TAXI_CELLTYPE;


typedef enum
{
    PERSONTYPETEL,
    PERSONTYPE
    
}KEY_TYPE;

#import "ElongBaseViewController.h"
#import "TaxiInvoceCell.h"
#import "UseTaxiCell.h"
#import "EvaluteCell.h"
#import "TaxiFillCell.h"
#import "TaxiInvoceCell.h"
#import  "TaxiPersonCell.h"
#define TIP  @"  提示："
#import "TaxiFillManager.h"
#import "TaxiTypeModel.h"
#import "EvaluteModel.h"
#import "SelectInvoiceView.h"
#import "NewPayMethodCtrl.h"
#define MapSurppot 1
#define CANCEL_TIP  @"订单取消规则\n\n"
#define OUTTIME  20*60

@interface TaxiFillCtrl : ElongBaseViewController<UITableViewDataSource,UITableViewDelegate,TaxiInvoceDelegate,UITextFieldDelegate,PersonChooseDelegate,AddressChooseDelegate,CustomABDelegate,UIAlertViewDelegate,SelectInvoiceViewDelegate,HttpUtilDelegate,SPreadDelegate>
{
    UITableView  *_table;
    NSArray  *headAr;
    UITextField  *field;
    KEY_TYPE  keyType;
    BOOL  needInvoce;
    BOOL  needAirPort;
    TaxiFillManager  *manager;
    float _invoiceCellHeight;
    SelectInvoiceView *_invoiceView;
    float  offset;
    UITextField  *personField;
    UITextField  *telField;
    HttpUtil *getPersonUtil;
    BOOL requestOver;  //联系人是否预加载
    float  h;
    float  evaluteHeight;
    UIButton  *commitBt;
    int   reClick;
    BOOL  isSpread;
    
    NewPayMethodCtrl *newPayControl;
    
}
@property  (nonatomic,retain) TaxiTypeModel  *typeModel;
@property  (nonatomic,retain) EvaluteModel  *eModel;
@property  (nonatomic,assign)  BOOL  hasDistination;

@end
