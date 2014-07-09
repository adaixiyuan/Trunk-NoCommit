//
//  TaxiInvoceCell.h
//  ElongClient
//
//  Created by nieyun on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineCell.h"


@protocol TaxiInvoceDelegate <NSObject>

- (void) chooseInvoceAction:(UITableViewCell  *)cell;

@end

@interface TaxiInvoceCell : LineCell
{
    
}
@property (nonatomic,assign) BOOL  needInvoice;
@property (nonatomic,assign) id<TaxiInvoceDelegate>  delegate;
@end
