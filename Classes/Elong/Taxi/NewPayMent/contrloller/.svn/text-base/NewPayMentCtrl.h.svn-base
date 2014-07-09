//
//  NewPayMentCtrl.h
//  ElongClient
//
//  Created by nieyun on 14-4-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "NewPayMentTable.h"
#import "CredtCardPayCtrl.h"
typedef enum
{
    CashSection,
    PaytypeSection
}NewPaySection;

@interface NewPayMentCtrl : ElongBaseViewController <UITableViewDataSource,UITableViewDelegate,SelectPayMethdDelegate>
{
    int payType;
    UITableView  *mainTable;
    NewUniformPaymentType  *payMethod;
    CredtCardPayCtrl  *credtCardCtrl;
}
@property  (nonatomic,retain) NSArray  *modelAr;
@property  (nonatomic,retain) NSString  *showMessage;
@property  (nonatomic,retain) NSDictionary  *topDic;
//+ (void) setPayType:(int ) type;
@end
