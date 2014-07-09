//
//  InterHotelOrderHistoryDetail.h
//  ElongClient
//
//  Created by 赵岩 on 13-7-3.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "InterHotelOrderDetailCell.h"
#import "InterHotelOrderConfirmationLetterController.h"
#import "BaseBottomBar.h"

@protocol InterHotelOrderHistoryDetailDelegate;
@interface InterHotelOrderHistoryDetail : DPNav<UITableViewDataSource,UITableViewDelegate,PKAddPassesViewControllerDelegate,BaseBottomBarDelegate>{
@private
    UITableView *orderDetailList;
    HttpUtil *confirmHttpUtil;
    HttpUtil *cancelHttpUtil;
    HttpUtil *passUtil;
    id delegate;
}

@property (nonatomic,assign) id<InterHotelOrderHistoryDetailDelegate> delegate;
@property (nonatomic,retain) NSDictionary *orderDetail;
- (id) initWithCancel:(BOOL) cancel;

@end

@protocol InterHotelOrderHistoryDetailDelegate <NSObject>

- (void) interHotelOrderDetailCanceled:(NSString *)orderNum;

@end