//
//  FlightOrderBottomBar.h
//  ElongClient
//
//  Created by Jian.zhao on 13-12-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {

    Order_Fill, //填写订单页面
    Order_Confim //订单确认页面
    
}FlightOrdertype;

@interface FlightOrderBottomBar : UIView{

    UILabel *totalPrice;
    UILabel *cashBack;
    
    id object;
    SEL o_selector;
}
@property(nonatomic,retain)    UILabel *totalPrice;
@property(nonatomic,retain)    UILabel *cashBack;

-(id)initWithType:(FlightOrdertype)type andRightBtnTitle:(NSString *)title pressedSEL:(SEL)selector DetailSEL:(SEL)selector2 delegate:(id)_delegate;
-(void)fillDataWithType:(FlightOrdertype)type;
@end
