//
//  PromotionView.h
//  ElongClient
//
//  Created by Dawn on 14-4-29.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SpecialRoomLM,          // 今日特价
    SpecialRoomPhone,       // 手机专享
    SpecialRoomApartment,   // 公寓
    SpecialRoomVIP,         // 龙萃
    SpecialRoomGift,        // 送礼
    SpecialRoomLimit        // 限时抢
}SpecialRoomType;

@interface SpecialRoomTypeItem : UIImageView{
    
}
@property (nonatomic,assign) NSInteger sortIndex;
- (id) initWithType:(SpecialRoomType)roomType;
@end

@interface SpecialRoomTypeView : UIView{
    UIScrollView *_contentView;
}
@property (nonatomic,assign) BOOL scrollEnabled;
@property (nonatomic,retain) NSArray *items;
- (void) reset;
- (void) addSpecialRoomTypeItem:(SpecialRoomTypeItem *)item;
@end
