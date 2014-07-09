//
//  SelectRoomer.h
//  ElongClient
//
//  Created by dengfang on 11-1-28.
//  Copyright 2011 shoujimobile. All rights reserved.
//
//  增加显示“房间x入住人”的提示文字 by 赵海波 on 14-4-8

#import <UIKit/UIKit.h>
#import "HotelDefine.h"

#define SELECTRENT  250         //租车
#define SELECT_SCENICTICKETS 260 //门票

@protocol RoomerDelegate;
@class SelectRoomerEditCell;
@interface SelectRoomer : DPNav <UITableViewDelegate, UITableViewDataSource> {
	UITableView *roomList;
    BOOL ReceiveMeomoryWraning;
    HttpUtil *getRoomerUtil;
    SmallLoadingView *smallLoading;
    SelectRoomerEditCell *editCell;
    id delegate;
    BOOL isLoaded;
    NSInteger roomCount;
    NSInteger peopleCount;      // 选择的人数
    UILabel *remainLbl;
    UILabel *tips0;
    NSMutableArray *selectedPeopleIndexArray;       // 纪录选中人序号数组
}
@property (nonatomic,assign) id<RoomerDelegate> delegate;
+ (NSMutableArray *)allRoomers;
- (id) initWithRequested:(BOOL)requested roomCount:(NSInteger)count;
- (void)setTingAll:(BOOL)requested roomCount:(NSInteger)count  tip:(NSString  *) tip andType:(int)type;
-(void)clickConfirm;
- (void) didSelectAlert;
@property  (nonatomic,assign) int  selectType;
@end

@protocol RoomerDelegate

- (void) selectRoomer:(SelectRoomer *)selectRoomer didSelectedArray:(NSArray *)array;

@end
