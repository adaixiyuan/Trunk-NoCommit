//
//  JInterHotelRoom.m
//  ElongClient
//
//  Created by Ivan.xu on 13-6-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "JInterHotelRoom.h"
#import "Utils.h"
#import "PostHeader.h"
#import "DefineCommon.h"

@interface JInterHotelRoom ()

@property(nonatomic,retain) NSMutableDictionary *contents;

@end

@implementation JInterHotelRoom
@synthesize contents;

- (void)dealloc
{
    [contents release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        if(!contents){
            contents = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
        [self.contents removeAllObjects];
        [self buildPostData:YES];
    }
    return self;
}
//是否重置数据
- (void)buildPostData:(BOOL)clearRoomPost{
    if(clearRoomPost){
        [self.contents safeSetObject:[PostHeader header] forKey:Resq_Header];
        [self.contents safeSetObject:@"" forKey:Req_InterHotelId];
        [self.contents safeSetObject:@"" forKey:Req_ArriveDate];
        [self.contents safeSetObject:@"" forKey:Req_DepartureDate];
        [self.contents safeSetObject:[NSNull null] forKey:Req_RoomGroup];
        [self.contents safeSetObject:[NSNumber numberWithInt:0] forKey:Req_PromotionTag];
    }
}

 //获取对象
-(id)getObjectForKey:(NSString *)key{
    id obj = [self.contents safeObjectForKey:key];
    
    return obj;
}

//设置酒店ID
-(void)setInterHotelId:(NSString *)hotelId{
    [self.contents safeSetObject:hotelId forKey:Req_InterHotelId];
}

 //设置入住离店日期
-(void)setLiveDate:(NSString *)liveDateStr andLeaveDate:(NSString *)leaveDateStr{
    if(STRINGHASVALUE(liveDateStr) && STRINGHASVALUE(leaveDateStr)){
        [self.contents safeSetObject:liveDateStr forKey:Req_ArriveDate];
        [self.contents safeSetObject:leaveDateStr forKey:Req_DepartureDate];
    }
}

//设置房间信息,rooms里面是房间的Dict信息
-(void)setRoomGroup:(NSArray *)rooms{
    if(ARRAYHASVALUE(rooms)){
        [self.contents safeSetObject:rooms forKey:Req_RoomGroup];
    }
}

//设置促销标识******此处注意，必传字段，用来注明该酒店是否参与促销，否则返回房间价格会有错误！
-(void)setPromotionTag:(int)promotionTag{
    [self.contents safeSetObject:[NSNumber numberWithInt:promotionTag] forKey:Req_PromotionTag];
}

//请求Content
- (NSString *)requestString:(BOOL)iscompress{
    NSLog(@"RoomRequest:%@",[self.contents JSONRepresentation]);
     return [NSString stringWithFormat:@"action=GetGlobalHotelRoomResp&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[self.contents JSONRepresentationWithURLEncoding]];
}

@end
