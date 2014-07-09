//
//  GrouponListCell.h
//  ElongClient
//  团购订单列表cell
//
//  Created by haibo on 11-11-29.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GrouponListCell;

@protocol GrouponListCellDelegate <NSObject>

@optional
-(void)payOrderByalipay:(GrouponListCell *)cell;

@end


@interface GrouponListCell : UITableViewCell {
								
	IBOutlet UIImageView	*LookImage;		// "查看团购券"	
	UIButton *payBtn;
	
	id<GrouponListCellDelegate> delegate;
}

@property(nonatomic, retain) IBOutlet UILabel *hotelnameLabel;		// 团购产品名
@property(nonatomic, retain) IBOutlet UILabel *orderIDLabel;		// 团购券ID
@property(nonatomic, retain) IBOutlet UILabel *orderpriceLabel;		// 产品单价
@property(nonatomic, retain) IBOutlet UILabel *bookNumLabel;		// 购买数量
@property(nonatomic, retain) IBOutlet UILabel *orderTotalLabel;		// 产品总价
@property(nonatomic, retain) IBOutlet UILabel *statesLabel;			// 订单状态描述
@property(nonatomic, retain) IBOutlet UILabel *orderID;	
@property(nonatomic, retain) IBOutlet UILabel *orderprice;	
@property(nonatomic, retain) IBOutlet UILabel *bookNum;	
@property(nonatomic, retain) IBOutlet UILabel *orderTotal;	
@property (nonatomic,retain) UIButton *payBtn;
@property (nonatomic, retain) IBOutlet UIImageView *rightArrow;
@property(nonatomic,assign) id<GrouponListCellDelegate> delegate;
@property (nonatomic,assign) NSInteger grouponIndex;

-(void)payByalipay;

@end
