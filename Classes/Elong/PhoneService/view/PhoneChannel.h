//
//  PhoneChannel.h
//  ElongClient
//
//  Created by nieyun on 14-5-30.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhonePubLic.h"
@interface PhoneChannel : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView  *table;
    NSArray  *titileAr;
    UIView  *bgView;
    UIView  *widownView;
    NSArray  *imageAr;
    NSArray   *nameAr;
    PhoneType  callType;
}
- (void) addInView:(UIView *)inView callType:(PhoneType)type ;
- (void)disMiss;
@end
