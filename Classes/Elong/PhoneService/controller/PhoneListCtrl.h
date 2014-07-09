//
//  PhoneListCtrl.h
//  ElongClient
//
//  Created by nieyun on 14-6-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "PhonePubLic.h"

@interface PhoneListCtrl : ElongBaseViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

{
    UITableView  *listTable;
    NSArray  *imageAr;
    NSArray  *nameAr;
    NSArray  *detaileAr;
    PhoneType  callType;
    PhoneChannelType  chanelType;
    NSString  *phoneStr;
}

- (id)initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style phoneType:(PhoneType)type ;

-(id)initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style phoneType:(PhoneType)type  chanelType:(PhoneChannelType) ctype;
@end
