//
//  XGHotelInfo.m
//  ElongClient
//
//  Created by guorendong on 14-4-21.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGHotelInfo.h"
@implementation XGHoldingTimeOption


@end
@implementation XGRoomStyle
/*

@property(nonatomic,readonly,strong)NSString *breakfast;
@property(nonatomic,readonly,strong)NSString *bed;
@property(nonatomic,readonly,strong)NSString *network;
@property(nonatomic,readonly,strong)NSString *area;
@property(nonatomic,readonly,strong)NSString *floor;
@property(nonatomic,readonly,strong)NSString *other;
@property(nonatomic,readonly,strong)NSString *personnum;
@property(nonatomic,readonly,strong)NSString *roomtype;
*/
-(void)setAdditionInfoListForAll
{
    for (NSDictionary *dic in self.AdditionInfoList) {
        
        if ([[dic safeObjectForKey:@"Key"] isEqualToString:@"breakfast"]) {
            // 早餐说明
            self.breakfast= [dic safeObjectForKey:@"Content"];
        }
        else if ([[dic safeObjectForKey:@"Key"] isEqualToString:@"network"]) {
            // 宽带说明
            self.network = [dic safeObjectForKey:@"Content"];
        }
        else if ([[dic safeObjectForKey:@"Key"] isEqualToString:@"area"]) {
            // 面积说明
            self.area = [dic safeObjectForKey:@"Content"];
        }
        else if ([[dic safeObjectForKey:@"Key"] isEqualToString:@"floor"]) {
            // 楼层说明
            NSString *floorStr = [[dic safeObjectForKey:@"Content"] stringByReplacingOccurrencesOfString:@"、" withString:@"/"];
            floorStr = [floorStr stringByReplacingOccurrencesOfString:@"," withString:@"/"];
            floorStr = [floorStr stringByReplacingOccurrencesOfString:@"，" withString:@"/"];
            self.floor = floorStr;
        }
        else if ([[dic safeObjectForKey:@"Key"] isEqualToString:@"bed"]) {
            // 床型说明
            self.bed = [dic safeObjectForKey:@"Content"];
        }
        else if([[dic safeObjectForKey:@"Key"] isEqualToString:@"roomtype"]){
            //房间类型
            self.roomtype = [dic safeObjectForKey:@"Content"];
        }
        else if([[dic safeObjectForKey:@"Key"] isEqualToString:@"personnum"]){
            //人数
            self.personnum = [dic safeObjectForKey:@"Content"];
        }
        else if([[dic safeObjectForKey:@"Key"] isEqualToString:@"other"]){
            //其他
            self.other = [dic safeObjectForKey:@"Content"];
        }

    }

}


- (NSString *) roomTypeTips
{
    return [self roomTypeTips:[self.GuestType intValue]];
}
- (NSString *) roomTypeTips:(NSInteger)guestType{
    // GuestType: 1 统一价; 2 内宾价; 3 外宾价; 4 港澳台客人价; 5 日本客人价;
    /*
     1 统一价-（不显示）
     
     2 内宾价-国内客人专享
     
     3 外宾价-国外客人专享
     
     4 港澳台客人价-港澳台客人专享
     
     5 日本客人价-日本客人专享
     */
    
    NSString *roomTypeTips = @"";
    if (guestType == 2) {
        roomTypeTips = @"内宾";//@"内宾:须持大陆身份证入住";
    }else if(guestType == 3){
        roomTypeTips = @"国际（含港澳台）客人专供";
    }else if(guestType == 4){
        roomTypeTips = @"港澳台客人专供";
    }else if(guestType == 5){
        roomTypeTips = @"日本客人专供";
    }
    return roomTypeTips;
}


-(NSString *)getRoomTypeFormerTextByAdditionInfoList
{
    NSString *roomtype =[self getRoomTypeByAdditionInfoList];
    NSString *formerText = @"";
    if (roomtype && ![roomtype isEqualToString:@""]) {
        formerText = [NSString stringWithFormat:@"%@(%@)",self.RoomTypeName,roomtype];
    }else{
        formerText = self.RoomTypeName;
    }
    if(![self.Description isKindOfClass:[NSString class]])
    {
        self.Description=@"";
    }
    if ([self.Description rangeOfString:@"无窗"].length > 0) {
        formerText = [NSString stringWithFormat:@"%@(无窗)",formerText];
    }
    
    formerText = [formerText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return formerText;
}

-(NSString *)getRoomTypeByAdditionInfoList
{
    return self.roomtype;
}


-(void)convertObjectFromGievnDictionary:(NSDictionary *)dict relySelf:(BOOL)yes
{
    [super convertObjectFromGievnDictionary:dict relySelf:yes];
    [self setAdditionInfoListForAll];
    //id holdingTimeOption =dict[];
}
-(void)convertObjectFromGievnDictionary:(NSDictionary *)dict
{
    [super convertObjectFromGievnDictionary:dict];
    [self setAdditionInfoListForAll];
}
-(NSMutableArray *)HoldingTimeOptionsEntity
{
    if (_HoldingTimeOptionsEntity ==nil) {
        _HoldingTimeOptionsEntity =[[NSMutableArray alloc] init];
    }
    return _HoldingTimeOptionsEntity;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super init];
    if (self) {;
        
        self.finalPrice=[aDecoder decodeObjectForKey:@"finalPrice"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
}

@end

@implementation XGHotelInfo


-(NSMutableArray *)RoomsEntity
{
    if (_RoomsEntity ==nil) {
        _RoomsEntity=[[NSMutableArray alloc] init];
    }
    return _RoomsEntity;
}

-(void)convertObjectFromGievnDictionary:(NSDictionary *)dict relySelf:(BOOL)yes
{
    id resp =dict[@"Resp"];
    NSDictionary *dictA =resp?resp:dict;
    
    [super convertObjectFromGievnDictionary:dictA relySelf:yes];
    [self.RoomsEntity removeAllObjects];

    for(NSDictionary *roomdic in self.Rooms)
    {
        XGRoomStyle *style =[[XGRoomStyle alloc] init];
        [style convertObjectFromGievnDictionary:roomdic relySelf:yes];
        [self.RoomsEntity addObject:style];
    }
    [self.RoomsEntity sortUsingComparator:^(id obj1,id obj2){
        XGRoomStyle *o1 =obj1;
        XGRoomStyle *o2 =obj2;
        return [o1.FinalPrice doubleValue]>=[o2.FinalPrice doubleValue]?1:-1;
    }];
}
-(NSString *)Remark
{
    return self.room.Remark;
}
-(NSNumber *)FinalPrice
{
    return self.room?self.room.FinalPrice:nil;
}
-(XGRoomStyle *)room
{
    return self.RoomsEntity.count>0?self.RoomsEntity[0]:nil;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super init];
    if (self) {
        self.PicUrl=[aDecoder decodeObjectForKey:@"hotelImageURL"];
        
        self.hotelName=[aDecoder decodeObjectForKey:@"hotelName"];
        
        self.hotelId=[aDecoder decodeObjectForKey:@"hotelId"];
        
        //self.wifi=[aDecoder decodeObjectForKey:@"wifi"];
        
        self.finalPrice=[aDecoder decodeObjectForKey:@"finalPrice"];
        
        self.businessResponseId=[aDecoder decodeObjectForKey:@"businessResponseId"];
        
        self.distance=[aDecoder decodeObjectForKey:@"distance"];
        
        
        self.remark=[aDecoder decodeObjectForKey:@"remark"];
        
//        self.reqId =[aDecoder decodeObjectForKey:@"reqId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
}
@end

@implementation XGRequestHotels
ModelErrorPropertysImplement


-(NSMutableArray *)hotelList
{
    if (_hotelList==nil) {
        _hotelList =[[NSMutableArray alloc] initWithCapacity:0];

    }
    return _hotelList;
}


@end