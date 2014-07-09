//
//  RoomType.h
//  ElongClient
//
//  Created by bin xing on 11-1-6.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelDefine.h"
#import "ImageDownLoader.h"

@class HotelDetailController;
@interface RoomType : UITableView <UITableViewDelegate, UITableViewDataSource, ImageDownDelegate> {
	BOOL isCurrentExtend;
	
	NSMutableDictionary *tableImgeDict;
	
	NSMutableArray *progressManager;       // 存储请求图片进程
	
	NSOperationQueue *queue;
    
    HttpUtil *hotRequest;
}

@property (nonatomic, assign) HotelDetailController *detail;

+ (int)currentRoomIndex;
+ (void)setCurrentRoomIndex:(int)index;
+ (BOOL)isPrepay;
+ (void)setIsPrepay:(BOOL)animation;
- (void) refresh:(BOOL)animated;
@end
