//
//  GrouponOrderInvoiceCell.h
//  ElongClient
//
//  Created by Dawn on 13-7-22.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBSwitch.h"

@protocol GrouponOrderInvoiceCellDelegate;
@interface GrouponOrderInvoiceCell : UITableViewCell{
@private
    id delegate;
    
    UIControl *faPiaoSwitch;
    UIView *bgSwichViewBg;
}
@property (nonatomic,assign) id<GrouponOrderInvoiceCellDelegate> delegate;
@property (nonatomic,assign) BOOL isNeedVoiceChecked;

//是否艺龙开发票
-(void) setPaPiaoState:(BOOL) isElongFaPiao;
@end

@protocol GrouponOrderInvoiceCellDelegate <NSObject>

@optional
- (void) orderInvoiceCell:(GrouponOrderInvoiceCell *)cell invoiceChoised:(BOOL)choised;

@end