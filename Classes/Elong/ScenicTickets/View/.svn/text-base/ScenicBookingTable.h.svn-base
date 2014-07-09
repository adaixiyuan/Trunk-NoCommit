//
//  ScenicBookingTable.h
//  ElongClient
//
//  Created by Jian.Zhao on 14-5-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScenicBookingDelegate <NSObject>

-(void)adjustBookingTableHeightWithOpenDic:(NSDictionary *)openDic  andDataSource:(NSDictionary *)dataSource;

@end

@interface ScenicBookingTable : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *isOpen;
    UITableView *_tableView;
    id<ScenicBookingDelegate>_delegate;
}
@property (nonatomic,retain) NSDictionary *dataDictionary;
@property (nonatomic,assign) id<ScenicBookingDelegate>delegate;

- (id)initWithFrame:(CGRect)frame andArray:(NSArray *)tickets;

@end
