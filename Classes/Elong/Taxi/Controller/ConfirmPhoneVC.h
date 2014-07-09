//
//  ConfirmPhoneVC.h
//  ElongClient
//  叫车手机验证
//  Created by Jian.Zhao on 14-2-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"

@class TaxiOrder;

@interface ConfirmPhoneVC : ElongBaseViewController<UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
    NSString *_phone;
    NSTimer *timer;
    
    UIButton *btn;
    
    CustomTextField *text;
    
    HttpUtil *httpUtil;//发送短信
    
    NSInteger netType;      // 网络请求类型
    
    TaxiOrder *_order;
    
    int max;
}
@property (nonatomic,assign) id callVcDelegate;
@property (nonatomic,retain) TaxiOrder *order;

-(void)setPhone:(NSString *)aPhone;
-(NSString *)phone;

@end
