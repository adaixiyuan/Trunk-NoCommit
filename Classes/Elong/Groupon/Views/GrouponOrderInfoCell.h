//
//  GrouponOrderInfoCell.h
//  ElongClient
//
//  Created by Dawn on 13-7-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GrouponOrderInfoCellDelegate;
@interface GrouponOrderInfoCell : UITableViewCell{
@private
    UILabel *hotelLbl;
    UILabel *priceLbl;
    UILabel *totalPriceLbl;
    UIButton *subButton;
    UIButton *addButton;
    UILabel *numberLabel;
    NSInteger purchaseNum;
    float price;
    id delegate;
    CustomTextField *phoneField;
    
    UIView *upContentView;
}
@property (nonatomic,assign) id<GrouponOrderInfoCellDelegate> delegate;
@property (nonatomic,readonly) CustomTextField *phoneField;
- (void) setPrice:(float)price num:(NSInteger)num;

- (void) setHotelName:(NSString *)hotel;

@end


@protocol GrouponOrderInfoCellDelegate <NSObject>
@optional
- (void) orderInfoCell:(GrouponOrderInfoCell *)cell grouponNumChanged:(NSInteger)num;
- (void) orderInfoCellAddPhone:(GrouponOrderInfoCell *)cell;
@end