//
//  GrouponOrderPaymentFlowCell.h
//  ElongClient
//
//  Created by Ivan.xu on 14-4-30.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrouponOrderPaymentFlowCell : UITableViewCell

-(void)setFlowInfo:(NSArray *)flowArray ofRow:(int)row;
-(void)grayStyle;       //灰色风格
-(void)blueStye;        //蓝色风格

@end
