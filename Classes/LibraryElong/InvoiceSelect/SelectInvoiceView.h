//
//  SelectInvoiceView.h
//  ElongClient
//
//  通用发票选择页面
//
//  Created by Dawn on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterView.h"

@protocol SelectInvoiceViewDelegate;
@interface SelectInvoiceView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,FilterDelegate>{
    NSInteger cellNum;
    
}
@property (nonatomic,readonly) NSString *invoiceTitle;
@property (nonatomic,readonly) NSString *invoiceType;
@property (nonatomic,readonly) NSDictionary *invoice;
@property (nonatomic,readonly) BOOL needInvoice;
@property (nonatomic,assign) id<SelectInvoiceViewDelegate> delegate;
- (void) reloadData;
- (id)initWithFrame:(CGRect)frame cellHeight:(CGFloat)cellHeight invoiceTypes:(NSArray *)types;
@end


@protocol SelectInvoiceViewDelegate <NSObject>

@optional
- (void) selectInvoiceView:(SelectInvoiceView *)selectInvoiceView didSelectAtIndex:(NSInteger)index;
- (void) selectInvoiceView:(SelectInvoiceView *)selectInvoiceView didResizedToFrame:(CGRect)frame;
@end