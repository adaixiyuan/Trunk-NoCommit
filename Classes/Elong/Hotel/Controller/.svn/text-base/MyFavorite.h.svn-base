//
//  MyFavorite.h
//  ElongClient
//
//  Created by bin xing on 11-2-19.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelDefine.h"


@interface MyFavorite : DPNav<UITableViewDelegate,UITableViewDataSource> {
	UITableView *defaultTableView;
	UILabel *favoriteLabel;
}
+ (NSMutableArray *)hotels;
+ (int)currentIndex;
//-(id)init:(NSString *)name style:(NavBtnStyle)style controller:(SearchMyHotel *)controller;
-(id)init:(NSString *)name style:(NavBtnStyle)style label:(UILabel *)label;
@end
