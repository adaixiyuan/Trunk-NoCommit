//
//  JInterHotelDetail.h
//  ElongClient
//
//  Created by Ivan.xu on 13-6-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JInterHotelDetail : NSObject

- (void)buildPostData:(BOOL)clearDetailPost;      //是否重置数据
-(id)getObjectForKey:(NSString *)key;   //获取对象
-(void)setInterHotelId:(NSString *)hotelId;     //设置酒店ID

- (NSString *)requestString:(BOOL)iscompress;        //请求Content

@end
