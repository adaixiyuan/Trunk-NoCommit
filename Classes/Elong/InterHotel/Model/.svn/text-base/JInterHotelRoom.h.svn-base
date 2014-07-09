//
//  JInterHotelRoom.h
//  ElongClient
//
//  Created by Ivan.xu on 13-6-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InterHotelDefine.h"

@interface JInterHotelRoom : NSObject

- (void)buildPostData:(BOOL)clearRoomPost;      //是否重置数据
-(id)getObjectForKey:(NSString *)key;   //获取对象
-(void)setInterHotelId:(NSString *)hotelId;     //设置酒店ID
-(void)setLiveDate:(NSString *)liveDateStr andLeaveDate:(NSString *)leaveDateStr;       //设置入住离店日期
-(void)setRoomGroup:(NSArray *)rooms;       //设置房间信息,rooms里面是房间的Dict信息
-(void)setPromotionTag:(int)promotionTag;       //设置促销标识******此处注意，必传字段，用来注明该酒店是否参与促销，否则返回房间价格会有错误！

- (NSString *)requestString:(BOOL)iscompress;        //请求Content

@end
