//
//  GrouponHistoryDetailCell.h
//  ElongClient
//
//  Created by Ivan.xu on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelQuanBlock) (int index);
typedef void(^SendMessageBlck) (int index);

@interface GrouponHistoryDetailCell : UITableViewCell

@property (retain, nonatomic) UIImageView *dashedlineImgView;
-(void)setQuanInfo:(NSDictionary *)quanDic canCancelCoupon:(BOOL)canCancelCoupon;
-(void)setCancelQuanBlock:(CancelQuanBlock)cancelBlock;
-(void)setSendMessageBlck:(SendMessageBlck)sendMsgBlock;

@end
